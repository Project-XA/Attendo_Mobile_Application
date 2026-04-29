import 'package:mobile_app/core/current_user/data/local_data_soruce/user_local_data_source.dart';
import 'package:mobile_app/core/networking/api_error_model.dart';
import 'package:mobile_app/features/session_mangement/data/data_source/session_state_manager.dart';
import 'package:mobile_app/features/session_mangement/data/helpers/session_cache_helper.dart';
import 'package:mobile_app/features/session_mangement/data/models/remote_models/create_session/create_session_request_model.dart';
import 'package:mobile_app/features/session_mangement/data/models/remote_models/get_all_halls/get_all_halls_response.dart';
import 'package:mobile_app/features/session_mangement/data/models/remote_models/get_all_sections/get_all_sections_response.dart';
import 'package:mobile_app/features/session_mangement/data/models/remote_models/save_attendance/save_attendance_request.dart';
import 'package:mobile_app/features/session_mangement/data/models/remote_models/save_attendance/save_attendance_response.dart';
import 'package:mobile_app/features/session_mangement/data/models/attendency_record.dart';
import 'package:mobile_app/features/session_mangement/data/service/http_server_service.dart';
import 'package:mobile_app/features/session_mangement/domain/entities/server_info.dart';
import 'package:mobile_app/features/session_mangement/domain/entities/session.dart';
import 'package:mobile_app/features/session_mangement/domain/repos/session_repository.dart';
import 'package:mobile_app/features/session_mangement/data/data_source/remote_session_data_source.dart';

class SessionRepositoryImpl implements SessionRepository {
  final HttpServerService _serverService;
  final UserLocalDataSource _localDataSource;
  final RemoteSessionDataSource _remoteSessionDataSource;
  final SessionCacheHelper _cacheHelper;
  final SessionStateManager _stateManager;

  SessionRepositoryImpl({
    required HttpServerService serverService,
    required UserLocalDataSource localDataSource,
    required SessionCacheHelper cacheHelper,
    required SessionStateManager stateManager,
    required RemoteSessionDataSource remoteSessionDataSource,
  }) : _serverService = serverService,
       _localDataSource = localDataSource,
       _cacheHelper = cacheHelper,
       _stateManager = stateManager,
       _remoteSessionDataSource = remoteSessionDataSource;

  Future<int> _getOrganizationId() async {
    final userData = await _localDataSource.getCurrentUser();
    final orgId = userData.organizations?.isNotEmpty == true
        ? userData.organizations!.first.organizationId
        : null;

    if (orgId == null) {
      throw const ApiErrorModel(
        message: 'Invalid organization ID',
        type: ApiErrorType.defaultError,
        statusCode: 400,
      );
    }

    return orgId;
  }

  void _validateSession(int sessionId) {
    if (!_stateManager.hasSession(sessionId)) {
      throw const ApiErrorModel(
        message: 'Session not found',
        type: ApiErrorType.defaultError,
        statusCode: 404,
      );
    }
  }

  Future<void> _stopAndClearSession() async {
    await _serverService.stopServer();
    _stateManager.updateStatus(SessionStatus.ended);
    _stateManager.clear();
  }

  @override
  Future<Session> createSession({
    required String name,
    required String location,
    required String connectionMethod,
    required DateTime startAt,
    required DateTime endAt,
    required double allowedRadius,
    required String networkSSID,
    required String networkBSSID,
    required double latitude,
    required double longitude,
    required int? hallId,
  }) async {
    final userData = await _localDataSource.getCurrentUser();
    final organizationId = await _getOrganizationId();

    final sessionId = await _remoteSessionDataSource.createSession(
      CreateSessionRequestModel(
        organizationId: organizationId,
        sessionName: name,
        createdBy: userData.id!,
        hallName: location,
        connectionType: connectionMethod,
        longitude: longitude,
        latitude: latitude,
        allowedRadius: allowedRadius,
        networkSSID: networkSSID,
        networkBSSID: networkBSSID,
        startAt: startAt.toIso8601String(),
        endAt: endAt.toIso8601String(),
        hallId: hallId!,
      ),
    );

    final session = Session(
      id: sessionId,
      name: name,
      organizationId: organizationId,
      location: location,
      connectionMethod: connectionMethod,
      startTime: startAt,
      durationMinutes: endAt.difference(startAt).inMinutes,
      status: SessionStatus.inactive,
      connectedClients: 0,
      attendanceList: [],
    );

    _stateManager.setSession(
      session,
      latitude: latitude,
      longitude: longitude,
      allowedRadius: allowedRadius,
    );

    return session;
  }

  @override
  Future<ServerInfo> startSessionServer(int sessionId) async {
    _validateSession(sessionId);

    final session = _stateManager.currentSession!;

    final serverInfo = await _serverService.startServer(
      sessionId,
      session,
      latitude: _stateManager.latitude,
      longitude: _stateManager.longitude,
      allowedRadius: _stateManager.allowedRadius,
      orgainzationId: session.organizationId,
    );

    _stateManager.updateStatus(SessionStatus.active);
    return serverInfo;
  }

  @override
  Future<void> endSession(int sessionId) async {
    _validateSession(sessionId);
    await _stopAndClearSession();
  }

  @override
  Future<void> deleteCurrentSession() async {
    await _stopAndClearSession();
  }

  @override
  Future<Session?> getCurrentActiveSession() async {
    return _stateManager.currentSession;
  }

  // ─── Attendance ──────────────────────────────────────────

  @override
  Stream<AttendanceRecord> getAttendanceStream() {
    return _serverService.attendanceStream.map((request) {
      final record = request.toAttendanceRecord();
      final session = _stateManager.currentSession;

      if (session != null) {
        final updatedList = List<AttendanceRecord>.from(session.attendanceList)
          ..add(record);

        _stateManager.updateAttendance(updatedList);
        _serverService.updateSessionData(_stateManager.currentSession!);
      }

      return record;
    });
  }

  @override
  Future<SaveAttendanceResponse> saveAttendance(
    SaveAttendanceRequest request,
  ) async {
    return _remoteSessionDataSource.saveAttendance(request);
  }

  @override
  Future<GetAllHallsResponse> getAllHalls() async {
    final orgId = await _getOrganizationId();
    return _cacheHelper.getHalls(orgId);
  }

  @override
  Future<GetAllSectionsResponse> getAllSections() async {
    final orgId = await _getOrganizationId();
    return _cacheHelper.getSections(orgId);
  }
}
