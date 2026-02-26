import 'package:mobile_app/core/current_user/data/local_data_soruce/user_local_data_source.dart';
import 'package:mobile_app/features/attendance/data/data_source/attendance_remote_data_source.dart';
import 'package:mobile_app/features/attendance/data/services/session_discovery_service.dart';
import 'package:mobile_app/features/attendance/domain/entities/nearby_session.dart';
import 'package:mobile_app/features/attendance/domain/repos/session_discovery_repo.dart';

class SessionDiscoveryRepositoryImpl implements SessionDiscoveryRepository {
  final SessionDiscoveryService _discoveryService;
  final UserLocalDataSource _localDataSource;
  final AttendanceRemoteDataSource _remoteDataSource;

  SessionDiscoveryRepositoryImpl({
    required SessionDiscoveryService discoveryService,
    required UserLocalDataSource userLocalDataSource,
    required AttendanceRemoteDataSource remoteDataSource,
  })  : _discoveryService = discoveryService,
        _localDataSource = userLocalDataSource,
        _remoteDataSource = remoteDataSource;

  @override
  Stream<NearbySession> discoverSessions() {
    return _discoveryService.sessionStream
        .asyncExpand((discovered) async* {
          final session = await _resolveSession(discovered.baseUrl);
          if (session != null) yield session;
        });
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
  Future<NearbySession?> getSessionDetails(String baseUrl) {
    return _remoteDataSource.getSessionDetails(baseUrl);
  }



  Future<NearbySession?> _resolveSession(String baseUrl) async {
    final userOrgId = await _getUserOrgId();
    if (userOrgId == null) return null;

    final details = await _remoteDataSource.getSessionDetails(baseUrl);
    if (details == null) return null;

    if (details.organizationId != userOrgId) return null;

    return details;
  }

  Future<int?> _getUserOrgId() async {
    final userData = await _localDataSource.getCurrentUser();
    return userData.organizations?.isNotEmpty == true
        ? userData.organizations!.first.organizationId
        : null;
  }
}