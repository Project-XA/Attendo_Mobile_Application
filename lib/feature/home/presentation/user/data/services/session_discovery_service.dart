import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:mobile_app/feature/home/presentation/user/data/models/discover_session_model.dart';
import 'package:nsd/nsd.dart' as nsd;

class SessionDiscoveryService {
  StreamController<DiscoveredSession>? _sessionController;
  nsd.Discovery? _discovery;
  Timer? _discoveryTimer;

  // ✅ Track discovered sessions to avoid duplicates
  final Set<String> _discoveredSessionIds = {};

  Stream<DiscoveredSession> get sessionStream =>
      _sessionController?.stream ?? const Stream.empty();

  // Start discovering nearby sessions via mDNS
  Future<void> startDiscovery() async {
    try {
      _discoveredSessionIds.clear(); // ✅ Clear previous sessions
      _sessionController = StreamController<DiscoveredSession>.broadcast();

      print('🔍 Starting mDNS discovery...');

      // ✅ Try mDNS first
      try {
        _discovery = await nsd.startDiscovery('_http._tcp');

        _discovery!.addServiceListener((service, status) {
          if (status == nsd.ServiceStatus.found) {
            print('📡 mDNS service found: ${service.name}');
            _handleDiscoveredService(service);
          }
        });

        print('✅ mDNS discovery started successfully');
      } catch (e) {
        print('⚠️ mDNS not available: $e');
      }

      // ✅ Start network scan immediately (don't wait for mDNS)
      _startNetworkScan();

      print('✅ Session discovery started (mDNS + Network Scan)');
    } catch (e) {
      print('❌ Discovery error: $e');
      // Continue with network scan even if mDNS fails
      _startNetworkScan();
    }
  }

  // Handle discovered mDNS service
  Future<void> _handleDiscoveredService(nsd.Service service) async {
    try {
      if (service.name == 'attendance') {
        print('🎯 Found attendance service, resolving...');

        // Resolve service to get IP and port
        final resolved = await nsd.resolve(service);

        if (resolved.host != null && resolved.port != null) {
          print('✅ Resolved to ${resolved.host}:${resolved.port}');
          await _verifyAndAddSession(resolved.host!, resolved.port!);
        }
      }
    } catch (e) {
      print('⚠️ Error handling mDNS service: $e');
    }
  }

  // Scan local network for sessions (backup method)
  void _startNetworkScan() {
    print('🔍 Starting network scan...');

    // ✅ Scan immediately
    _scanLocalNetwork();

    // ✅ Then scan periodically
    _discoveryTimer?.cancel();
    _discoveryTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      print('🔄 Periodic network scan...');
      _scanLocalNetwork();
    });
  }

  Future<void> _scanLocalNetwork() async {
    try {
      // Get local IP
      final localIp = await _getLocalIpAddress();
      if (localIp == null) {
        print('⚠️ Could not get local IP address');
        return;
      }

      print('📍 Local IP: $localIp');

      final parts = localIp.split('.');
      if (parts.length != 4) return;

      final networkPrefix = '${parts[0]}.${parts[1]}.${parts[2]}';
      print('🌐 Scanning network: $networkPrefix.x');

      // ✅ Scan in parallel with better error handling
      final futures = <Future>[];

      // ✅ Scan common IPs first (1-20, then 100-254)
      final priorityIPs = [
        ...List.generate(20, (i) => i + 1),
        ...List.generate(155, (i) => i + 100),
      ];

      for (int i in priorityIPs) {
        final ip = '$networkPrefix.$i';
        futures.add(
          _checkSessionAt(ip, 8080).catchError((e) {
            // Silent fail - expected for non-session IPs
            return;
          }),
        );

        // Process in batches of 30 for faster scanning
        if (futures.length >= 30) {
          await Future.wait(futures, eagerError: false);
          futures.clear();
        }
      }

      if (futures.isNotEmpty) {
        await Future.wait(futures, eagerError: false);
      }

      print('✅ Network scan completed');
    } catch (e) {
      print('⚠️ Network scan error: $e');
    }
  }

  // Check if session exists at IP:port
  Future<void> _checkSessionAt(String ip, int port) async {
    try {
      final response = await http
          .get(Uri.parse('http://$ip:$port/health'))
          .timeout(const Duration(seconds: 1)); // ✅ Reduced timeout

      if (response.statusCode == 200) {
        print('✅ Found potential session at $ip:$port');
        await _verifyAndAddSession(ip, port);
      }
    } catch (_) {
      // Silent fail - expected for non-session IPs
    }
  }

  // ✅ Verify and add session - fetch full details from /session-info
  Future<void> _verifyAndAddSession(String host, int port) async {
    try {
      // ✅ Check if already discovered
      final sessionKey = '$host:$port';
      if (_discoveredSessionIds.contains(sessionKey)) {
        return; // Already discovered
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

              // ✅ Mark as discovered
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
              print('🎉 Session discovered: ${session.name} at $host:$port');
              return;
            }
          } catch (e) {
            print('⚠️ Could not fetch session-info from $host:$port: $e');
          }

          // ✅ Fallback: create basic session if /session-info fails
          _discoveredSessionIds.add(sessionKey);

          final session = DiscoveredSession(
            sessionId: healthData['sessionId'],
            ipAddress: host,
            port: port,
            timestamp: DateTime.parse(healthData['timestamp']),
          );

          _sessionController?.add(session);
          print('✅ Session discovered (basic info): $host:$port');
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
          // ✅ Check for both 192.168.x.x and 10.x.x.x networks
          if (!addr.isLoopback &&
              (addr.address.startsWith('192.168') ||
                  addr.address.startsWith('10.'))) {
            return addr.address;
          }
        }
      }

      print('⚠️ No local IP found in 192.168.x.x or 10.x.x.x range');
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
        await nsd.stopDiscovery(_discovery!);
        _discovery = null;
      }

      await _sessionController?.close();
      _sessionController = null;

      _discoveredSessionIds.clear();

      print('✅ Session discovery stopped');
    } catch (e) {
      print('❌ Error stopping discovery: $e');
    }
  }

  void dispose() {
    stopDiscovery();
  }
}
