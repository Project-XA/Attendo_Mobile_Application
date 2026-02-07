import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_app/core/current_user/data/local_data_soruce/user_local_data_source.dart';
import 'package:mobile_app/features/attendance/data/models/nearby_session_model.dart';
import 'package:mobile_app/features/attendance/data/services/session_discovery_service.dart';
import 'package:mobile_app/features/attendance/domain/entities/nearby_session.dart';
import 'package:mobile_app/features/attendance/domain/repos/session_discovery_repo.dart';

class SessionDiscoveryRepositoryImpl implements SessionDiscoveryRepository {
  final SessionDiscoveryService _discoveryService;
  final UserLocalDataSource _localDataSource;

  SessionDiscoveryRepositoryImpl({
    required SessionDiscoveryService discoveryService,
    required UserLocalDataSource userLocalDataSource,
  }) : _discoveryService = discoveryService,
       _localDataSource = userLocalDataSource;

  @override
  Stream<NearbySession> discoverSessions() {
    return _discoveryService.sessionStream
        .asyncMap((discovered) async {
          final userData = await _localDataSource.getCurrentUser();

          final userOrgId = userData.organizations?.isNotEmpty == true
              ? userData.organizations!.first.organizationId
              : null;

          if (userOrgId == null) {
            return null;
          }

          final details = await getSessionDetails(discovered.baseUrl);

          if (details == null) {
            return null;
          }

          if (details.organizationId != userOrgId) {
            return null;
          }

          return details;
        })
        .where((session) => session != null)
        .cast<NearbySession>();
  }

  @override
  Future<void> startDiscovery() async {
    await _discoveryService.startDiscovery();
  }

  @override
  Future<void> stopDiscovery() async {
    await _discoveryService.stopDiscovery();
  }

  @override
  Future<NearbySession?> getSessionDetails(String baseUrl) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/session-info'))
          .timeout(const Duration(seconds: 3));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final uri = Uri.parse(baseUrl);
        final model = NearbySessionModel.fromJson(data, uri.host, uri.port);
        return model.toEntity();
      }

      return null;
    } catch (e) {
      return null;
    }
  }
}
