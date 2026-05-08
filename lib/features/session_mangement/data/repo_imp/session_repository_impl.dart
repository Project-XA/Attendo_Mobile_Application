import 'package:mobile_app/core/current_user/data/local_data_soruce/user_local_data_source.dart';
import 'package:mobile_app/core/networking/api_error_handler.dart';
import 'package:mobile_app/core/networking/api_error_model.dart';
import 'package:mobile_app/features/session_mangement/data/data_source/session_state_manager.dart';
import 'package:mobile_app/features/session_mangement/data/helpers/session_cache_helper.dart';
import 'package:mobile_app/features/session_mangement/data/models/remote_models/create_session/create_hall_session_request_model.dart';
import 'package:mobile_app/features/session_mangement/data/models/remote_models/create_session/create_section_session_request_model.dart';
import 'package:mobile_app/features/session_mangement/data/models/remote_models/get_all_halls/get_all_halls_response.dart';
import 'package:mobile_app/features/session_mangement/data/models/remote_models/get_all_sections/get_all_sections_response.dart';
import 'package:mobile_app/features/session_mangement/data/models/remote_models/save_attendance/save_attendance_request.dart';
import 'package:mobile_app/features/session_mangement/data/models/remote_models/save_attendance/save_attendance_response.dart';
import 'package:mobile_app/features/session_mangement/data/models/attendency_record.dart';
import 'package:mobile_app/features/session_mangement/data/service/http_server_service.dart';
import 'package:mobile_app/features/session_mangement/domain/entities/server_info.dart';
import 'package:mobile_app/features/session_mangement/domain/entities/session.dart';
import 'package:mobile_app/features/session_mangement/domain/entities/session_creation_params.dart';
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

  // ─── Helpers ──────────────────────────────────────────────

  Future<int> _getOrganizationId() async {
    try {
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
    } on ApiErrorModel {
      rethrow;
    } catch (e) {
      throw ApiErrorHandler.handle(e);
    }
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
    try {
      await _serverService.stopServer();
      _stateManager.updateStatus(SessionStatus.ended);
      _stateManager.clear();
    } on ApiErrorModel {
      rethrow;
    } catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }

  Session _buildSession(
    SessionCreationParams params,
    int sessionId,
    int organizationId,
  ) {
    final session = Session(
      id: sessionId,
      name: params.name,
      organizationId: organizationId,
      location: params.location,
      connectionMethod: params.connectionMethod,
      startTime: params.startAt,
      durationMinutes: params.endAt.difference(params.startAt).inMinutes,
      status: SessionStatus.inactive,
      connectedClients: 0,
      attendanceList: [],
    );

    _stateManager.setSession(
      session,
      latitude: params.latitude,
      longitude: params.longitude,
      allowedRadius: params.allowedRadius,
    );

    return session;
  }

  // ─── Create Session ────────────────────────────────────────

  @override
  Future<Session> createSessionHall({
    required SessionCreationParams params,
    required int? hallId,
  }) async {
    try {
      final userData = await _localDataSource.getCurrentUser();
      final organizationId = await _getOrganizationId();

      final sessionId = await _remoteSessionDataSource.createSessionHall(
        CreateHallSessionRequestModel(
          organizationId: organizationId,
          sessionName: params.name,
          createdBy: userData.id!,
          hallName: params.location,
          connectionType: params.connectionMethod,
          longitude: params.longitude,
          latitude: params.latitude,
          allowedRadius: params.allowedRadius,
          networkSSID: params.networkSSID,
          networkBSSID: params.networkBSSID,
          startAt: params.startAt.toIso8601String(),
          endAt: params.endAt.toIso8601String(),
          hallId: hallId!,
        ),
      );

      return _buildSession(params, sessionId, organizationId);
    } on ApiErrorModel {
      rethrow;
    } catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }

  @override
  Future<Session> createSessionSection({
    required SessionCreationParams params,
    required int? sectionId,
  }) async {
    try {
      final userData = await _localDataSource.getCurrentUser();
      final organizationId = await _getOrganizationId();

      final sessionId = await _remoteSessionDataSource.createSessionSection(
        CreateSectionSessionRequestModel(
          organizationId: organizationId,
          sessionName: params.name,
          createdBy: userData.id!,
          sectionName: params.location,
          connectionType: params.connectionMethod,
          longitude: params.longitude,
          latitude: params.latitude,
          allowedRadius: params.allowedRadius,
          networkSSID: params.networkSSID,
          networkBSSID: params.networkBSSID,
          startAt: params.startAt.toIso8601String(),
          endAt: params.endAt.toIso8601String(),
          sectionId: sectionId!,
        ),
      );

      return _buildSession(params, sessionId, organizationId);
    } on ApiErrorModel {
      rethrow;
    } catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }

  // ─── Server ────────────────────────────────────────────────

  @override
  Future<ServerInfo> startSessionServer(int sessionId) async {
    try {
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
    } on ApiErrorModel {
      rethrow;
    } catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }

  // ─── End & Delete ──────────────────────────────────────────

  @override
  Future<void> endSession(int sessionId) async {
    try {
      _validateSession(sessionId);
      await _stopAndClearSession();
    } on ApiErrorModel {
      rethrow;
    } catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }

  @override
  Future<void> deleteCurrentSession() async {
    try {
      await _stopAndClearSession();
    } on ApiErrorModel {
      rethrow;
    } catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }

  @override
  Future<Session?> getCurrentActiveSession() async {
    return _stateManager.currentSession;
  }

  // ─── Attendance ────────────────────────────────────────────

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
    try {
      return await _remoteSessionDataSource.saveAttendance(request);
    } on ApiErrorModel {
      rethrow;
    } catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }


  @override
  Future<GetAllHallsResponse> getAllHalls() async {
    try {
      final orgId = await _getOrganizationId();
      return await _cacheHelper.getHalls(orgId);
    } on ApiErrorModel {
      rethrow;
    } catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }

  @override
  Future<GetAllSectionsResponse> getAllSections() async {
    try {
      final orgId = await _getOrganizationId();
      return await _cacheHelper.getSections(orgId);
    } on ApiErrorModel {
      rethrow;
    } catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }
}
