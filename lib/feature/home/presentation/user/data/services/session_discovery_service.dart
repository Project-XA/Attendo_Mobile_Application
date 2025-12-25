import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:mobile_app/feature/home/presentation/user/data/models/discover_session_model.dart';
import 'package:nsd/nsd.dart' as nsd; // ✅ Import with prefix to avoid confusion

class SessionDiscoveryService {
  StreamController<DiscoveredSession>? _sessionController;
  nsd.Discovery? _discovery;
  Timer? _discoveryTimer;
  
  Stream<DiscoveredSession> get sessionStream => 
      _sessionController?.stream ?? const Stream.empty();

  // Start discovering nearby sessions via mDNS
  Future<void> startDiscovery() async {
    try {
      _sessionController = StreamController<DiscoveredSession>.broadcast();
      
      // ✅ FIX: Use nsd package's startDiscovery with prefix
      _discovery = await nsd.startDiscovery('_http._tcp');
      
      _discovery!.addServiceListener((service, status) {
        if (status == nsd.ServiceStatus.found) {
          _handleDiscoveredService(service);
        }
      });

      // Also scan local network periodically
      _startNetworkScan();
      
      print('✅ Session discovery started');
    } catch (e) {
      print('❌ Discovery error: $e');
      // Don't rethrow - start network scan anyway
      _startNetworkScan();
    }
  }

  // Handle discovered mDNS service
  Future<void> _handleDiscoveredService(nsd.Service service) async {
    try {
      if (service.name == 'attendance') {
        // Resolve service to get IP and port
        final resolved = await nsd.resolve(service);
        
        if (resolved.host != null && resolved.port != null) {
          await _verifyAndAddSession(
            resolved.host!,
            resolved.port!,
          );
        }
      }
    } catch (e) {
      print('⚠️ Error handling service: $e');
    }
  }

  // Scan local network for sessions (backup method)
  void _startNetworkScan() {
    _discoveryTimer = Timer.periodic(
      const Duration(seconds: 10),
      (_) => _scanLocalNetwork(),
    );
  }

  Future<void> _scanLocalNetwork() async {
    try {
      // Get local IP
      final localIp = await _getLocalIpAddress();
      if (localIp == null) return;

      final parts = localIp.split('.');
      if (parts.length != 4) return;
      
      final networkPrefix = '${parts[0]}.${parts[1]}.${parts[2]}';

      // Scan common IPs in parallel (limited to avoid overwhelming network)
      final futures = <Future>[];
      for (int i = 1; i <= 254; i++) {
        final ip = '$networkPrefix.$i';
        futures.add(_checkSessionAt(ip, 8080));
        
        // Process in batches of 20
        if (futures.length >= 20) {
          await Future.wait(futures, eagerError: false);
          futures.clear();
        }
      }
      
      if (futures.isNotEmpty) {
        await Future.wait(futures, eagerError: false);
      }
    } catch (e) {
      print('⚠️ Network scan error: $e');
    }
  }

  // Check if session exists at IP:port
  Future<void> _checkSessionAt(String ip, int port) async {
    try {
      final response = await http
          .get(Uri.parse('http://$ip:$port/health'))
          .timeout(const Duration(seconds: 2));

      if (response.statusCode == 200) {
        await _verifyAndAddSession(ip, port);
      }
    } catch (_) {
      // Silent fail - expected for non-session IPs
    }
  }

  // ✅ Verify and add session - fetch full details from /session-info
  Future<void> _verifyAndAddSession(String host, int port) async {
    try {
      // First check health
      final healthResponse = await http
          .get(Uri.parse('http://$host:$port/health'))
          .timeout(const Duration(seconds: 3));

      if (healthResponse.statusCode == 200) {
        final healthData = jsonDecode(healthResponse.body);
        
        if (healthData['status'] == 'active' && healthData['sessionId'] != null) {
          
          // ✅ Now fetch full session info
          try {
            final infoResponse = await http
                .get(Uri.parse('http://$host:$port/session-info'))
                .timeout(const Duration(seconds: 3));

            if (infoResponse.statusCode == 200) {
              final sessionData = jsonDecode(infoResponse.body);
              
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
              print('✅ Session discovered with details: ${session.name} at $host:$port');
              return;
            }
          } catch (e) {
            print('⚠️ Could not fetch session-info, using basic info: $e');
          }
          
          // Fallback: create basic session if /session-info fails
          final session = DiscoveredSession(
            sessionId: healthData['sessionId'],
            ipAddress: host,
            port: port,
            timestamp: DateTime.parse(healthData['timestamp']),
          );

          _sessionController?.add(session);
          print('✅ Session discovered (basic): $host:$port');
        }
      }
    } catch (e) {
      print('⚠️ Verification failed for $host:$port - $e');
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
          if (!addr.isLoopback && addr.address.startsWith('192.168')) {
            return addr.address;
          }
        }
      }
      return null;
    } catch (e) {
      print('❌ Error getting IP: $e');
      return null;
    }
  }

  // Stop discovery
  Future<void> stopDiscovery() async {
    try {
      _discoveryTimer?.cancel();
      _discoveryTimer = null;

      if (_discovery != null) {
        await nsd.stopDiscovery(_discovery!); // ✅ Use nsd prefix
        _discovery = null;
      }

      await _sessionController?.close();
      _sessionController = null;

      print('✅ Session discovery stopped');
    } catch (e) {
      print('❌ Error stopping discovery: $e');
    }
  }

  void dispose() {
    stopDiscovery();
  }
}