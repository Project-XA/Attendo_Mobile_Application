import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:mobile_app/features/session_mangement/data/helpers/location_validator.dart';
import 'package:mobile_app/features/session_mangement/data/helpers/network_utils.dart';
import 'package:mobile_app/features/session_mangement/data/helpers/session_response_builder.dart';
import 'package:mobile_app/features/session_mangement/data/models/attendence_request.dart';
import 'package:mobile_app/features/session_mangement/domain/entities/server_info.dart';
import 'package:mobile_app/features/session_mangement/domain/entities/session.dart';
import 'package:nsd/nsd.dart';
/*
this service is responsible for managing the HTTP server that listens for attendance requests from clients. It handles starting and stopping the server, processing incoming requests, validating user location, and broadcasting attendance events to the rest of the app.
The service also registers itself on the local network using mDNS so that clients can discover it without needing to know the IP address in advance.
By centralizing all server-related logic in this service, we can keep the rest of the app decoupled from the specifics of how attendance requests are received and processed.
 */
class HttpServerService {
  HttpServer? _server;
  Registration? _mdnsRegistration;
  final StreamController<AttendanceRequest> _attendanceController =
      StreamController<AttendanceRequest>.broadcast();

  Stream<AttendanceRequest> get attendanceStream =>
      _attendanceController.stream;

  int? _currentSessionId;
  Session? _currentSession;
  LocationValidator? _locationValidator;

  bool get isServerRunning => _server != null;

  void updateSessionData(Session session) {
    _currentSession = session;
  }

  Future<ServerInfo> startServer(
    int sessionId,
    Session session, {
    double? latitude,
    double? longitude,
    double? allowedRadius,
    int? orgainzationId,
  }) async {
    try {
      _server = await HttpServer.bind(InternetAddress.anyIPv4, 8080);
      _currentSessionId = sessionId;
      _currentSession = session;

      if (latitude != null && longitude != null && allowedRadius != null) {
        _locationValidator = LocationValidator(
          sessionLatitude: latitude,
          sessionLongitude: longitude,
          allowedRadius: allowedRadius,
        );
      }

      _server!.listen(_handleRequest);

      await _registerMdnsService();

      final localIp = await NetworkUtils.getLocalIpAddress();

      return ServerInfo(ipAddress: localIp, port: 8080, sessionId: sessionId);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _handleRequest(HttpRequest request) async {
    request.response.headers.add('Access-Control-Allow-Origin', '*');
    request.response.headers.add('Content-Type', 'application/json');

    try {
      if (request.method == 'POST' && request.uri.path == '/attend') {
        await _handleAttendanceRequest(request);
      } else if (request.method == 'GET' && request.uri.path == '/health') {
        _handleHealthCheck(request);
      } else if (request.method == 'GET' && request.uri.path == '/session-info') {
        _handleSessionInfo(request);
      } else {
        request.response
          ..statusCode = HttpStatus.notFound
          ..write(jsonEncode({'error': 'Not found'}));
      }
    } catch (e) {
      request.response
        ..statusCode = HttpStatus.internalServerError
        ..write(jsonEncode({'error': e.toString()}));
    } finally {
      await request.response.close();
    }
  }

  Future<void> _handleAttendanceRequest(HttpRequest request) async {
    try {
      final body = await utf8.decoder.bind(request).join();
      final data = jsonDecode(body) as Map<String, dynamic>;
      final attendanceRequest = AttendanceRequest.fromJson(data);

      if (_currentSessionId == null || _currentSession == null) {
        request.response
          ..statusCode = HttpStatus.badRequest
          ..write(jsonEncode(SessionResponseBuilder.error('No active session')));
        return;
      }

      final alreadyCheckedIn = _currentSession!.attendanceList.any(
        (record) => record.deviceIdHash == attendanceRequest.deviceIdHash,
      );

      if (alreadyCheckedIn) {
        request.response
          ..statusCode = HttpStatus.conflict
          ..write(jsonEncode(SessionResponseBuilder.error(
            'Already checked in',
            code: 'ALREADY_CHECKED_IN',
          )));
        return;
      }

      if (attendanceRequest.location == null) {
        request.response
          ..statusCode = HttpStatus.badRequest
          ..write(jsonEncode(SessionResponseBuilder.error(
            'Location is required',
            code: 'LOCATION_REQUIRED',
          )));
        return;
      }

      final locationValid = _locationValidator?.validate(attendanceRequest.location!) ?? false;

      if (!locationValid) {
        request.response
          ..statusCode = HttpStatus.forbidden
          ..write(jsonEncode(SessionResponseBuilder.error(
            'Out of zone',
            code: 'OUT_OF_ZONE',
          )));
        return;
      }

      _attendanceController.add(attendanceRequest);

      request.response
        ..statusCode = HttpStatus.ok
        ..write(jsonEncode(SessionResponseBuilder.success(_currentSessionId)));
    } catch (e) {
      request.response
        ..statusCode = HttpStatus.badRequest
        ..write(jsonEncode(SessionResponseBuilder.error('Invalid request format')));
    }
  }

  void _handleHealthCheck(HttpRequest request) {
    request.response
      ..statusCode = HttpStatus.ok
      ..write(jsonEncode(SessionResponseBuilder.health(
        sessionId: _currentSessionId,
        session: _currentSession,
      )));
  }

  void _handleSessionInfo(HttpRequest request) {
    if (_currentSession == null) {
      request.response
        ..statusCode = HttpStatus.notFound
        ..write(jsonEncode({'error': 'No active session'}));
      return;
    }

    request.response
      ..statusCode = HttpStatus.ok
      ..write(jsonEncode(SessionResponseBuilder.sessionInfo(_currentSession!)));
  }

  Future<void> _registerMdnsService() async {
    try {
      await startDiscovery('_http._tcp');

      const service = Service(
        name: 'attendance',
        type: '_http._tcp',
        port: 8080,
      );

      _mdnsRegistration = await register(service);
    } catch (e) {
      // mDNS registration failed
    }
  }

  Future<void> stopServer() async {
    try {
      if (_mdnsRegistration != null) {
        await unregister(_mdnsRegistration!);
        _mdnsRegistration = null;
      }

      await _server?.close(force: true);
      _server = null;
      _currentSessionId = null;
      _currentSession = null;
      _locationValidator = null;
    } catch (e) {
      // Error stopping server
    }
  }

  void dispose() {
    _attendanceController.close();
    stopServer();
  }
}