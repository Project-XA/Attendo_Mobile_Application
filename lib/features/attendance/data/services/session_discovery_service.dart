import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:mobile_app/features/attendance/data/models/discover_session_model.dart';
import 'package:nsd/nsd.dart' as nsd;

class SessionDiscoveryService {
  StreamController<DiscoveredSession>? _sessionController;
  nsd.Discovery? _discovery;
  Timer? _discoveryTimer;

  final Set<String> _discoveredSessionIds = {};

  Stream<DiscoveredSession> get sessionStream =>
      _sessionController?.stream ?? const Stream.empty();

  Future<void> startDiscovery() async {
    try {
      _discoveredSessionIds.clear();
      _sessionController = StreamController<DiscoveredSession>.broadcast();

      try {
        _discovery = await nsd.startDiscovery('_http._tcp');

        _discovery!.addServiceListener((service, status) {
          if (status == nsd.ServiceStatus.found) {
            _handleDiscoveredService(service);
          }
        });
      } catch (e) {
        // mDNS not available
      }

      _startNetworkScan();
    } catch (e) {
      _startNetworkScan();
    }
  }

  Future<void> _handleDiscoveredService(nsd.Service service) async {
    try {
      if (service.name == 'attendance') {
        final resolved = await nsd.resolve(service);

        if (resolved.host != null && resolved.port != null) {
          await _verifyAndAddSession(resolved.host!, resolved.port!);
        }
      }
    } catch (e) {
      // Error handling mDNS service
    }
  }

  void _startNetworkScan() {
    _scanLocalNetwork();

    _discoveryTimer?.cancel();
    _discoveryTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      _scanLocalNetwork();
    });
  }

  Future<void> _scanLocalNetwork() async {
    try {
      // Get local IP
      final localIp = await _getLocalIpAddress();
      if (localIp == null) {
        return;
      }

      final parts = localIp.split('.');
      if (parts.length != 4) return;

      final networkPrefix = '${parts[0]}.${parts[1]}.${parts[2]}';

      // Scan in parallel with better error handling
      final futures = <Future>[];

      // Scan common IPs first (1-20, then 100-254)
      final priorityIPs = [
        ...List.generate(20, (i) => i + 1),
        ...List.generate(155, (i) => i + 100),
      ];

      for (int i in priorityIPs) {
        final ip = '$networkPrefix.$i';
        futures.add(
          _checkSessionAt(ip, 8080).catchError((e) {
            return;
          }),
        );

        if (futures.length >= 30) {
          await Future.wait(futures, eagerError: false);
          futures.clear();
        }
      }

      if (futures.isNotEmpty) {
        await Future.wait(futures, eagerError: false);
      }
    } catch (e) {
      // Network scan error
    }
  }

  Future<void> _checkSessionAt(String ip, int port) async {
    try {
      final response = await http
          .get(Uri.parse('http://$ip:$port/health'))
          .timeout(const Duration(seconds: 1)); // 

      if (response.statusCode == 200) {
        await _verifyAndAddSession(ip, port);
      }
    } catch (_) {
      // Silent fail - expected for non-session IPs
    }
  }

  Future<void> _verifyAndAddSession(String host, int port) async {
    try {
      final sessionKey = '$host:$port';
      if (_discoveredSessionIds.contains(sessionKey)) {
        return; 
      }

      // First check health
      final healthResponse = await http
          .get(Uri.parse('http://$host:$port/health'))
          .timeout(const Duration(seconds: 2));

      if (healthResponse.statusCode == 200) {
        final healthData = jsonDecode(healthResponse.body);

        if (healthData['status'] == 'active' &&
            healthData['sessionId'] != null) {
          // ✅ Now fetch full session info
          try {
            final infoResponse = await http
                .get(Uri.parse('http://$host:$port/session-info'))
                .timeout(const Duration(seconds: 2));

            if (infoResponse.statusCode == 200) {
              final sessionData = jsonDecode(infoResponse.body);

              // Mark as discovered
              _discoveredSessionIds.add(sessionKey);

              // Create discovered session with full details
              final session = DiscoveredSession(
                sessionId: sessionData['sessionId'],
                ipAddress: host,
                port: port,
                timestamp: DateTime.parse(sessionData['timestamp']),
                name: sessionData['name'],
                location: sessionData['location'],
              );

              _sessionController?.add(session);
              return;
            }
          } catch (e) {
            // Could not fetch session-info
          }

          // Fallback: create basic session if /session-info fails
          _discoveredSessionIds.add(sessionKey);

          final session = DiscoveredSession(
            sessionId: healthData['sessionId'],
            ipAddress: host,
            port: port,
            timestamp: DateTime.parse(healthData['timestamp']),
          );

          _sessionController?.add(session);
        }
      }
    } catch (e) {
      // Silent fail - don't spam logs
    }
  }

  // Get local IP address
  Future<String?> _getLocalIpAddress() async {
    try {
      final interfaces = await NetworkInterface.list(
        type: InternetAddressType.IPv4,
      );

      for (var interface in interfaces) {
        for (var addr in interface.addresses) {
          //  Check for both 192.168.x.x or 10.x.x.x  or 172.networks
          if (!addr.isLoopback &&
              (addr.address.startsWith('192.168') ||
                  addr.address.startsWith('10.') ||
                  addr.address.startsWith('172.'))) {
            return addr.address;
          }
        }
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  // Stop discovery
  Future<void> stopDiscovery() async {
    try {
      _discoveryTimer?.cancel();
      _discoveryTimer = null;

      if (_discovery != null) {
        await nsd.stopDiscovery(_discovery!);
        _discovery = null;
      }

      await _sessionController?.close();
      _sessionController = null;

      _discoveredSessionIds.clear();
    } catch (e) {
      // Error stopping discovery
    }
  }

  void dispose() {
    stopDiscovery();
  }
}
