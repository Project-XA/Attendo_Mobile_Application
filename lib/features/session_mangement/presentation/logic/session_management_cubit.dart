import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/core/networking/api_error_model.dart';
import 'package:mobile_app/features/session_mangement/data/service/session_time_service.dart';
import 'package:mobile_app/features/session_mangement/data/models/attendency_record.dart';
import 'package:mobile_app/features/session_mangement/domain/entities/session.dart';
import 'package:mobile_app/features/session_mangement/domain/use_cases/create_session_use_case.dart';
import 'package:mobile_app/features/session_mangement/domain/use_cases/end_session_use_case.dart';
import 'package:mobile_app/features/session_mangement/domain/use_cases/get_all_halls_use_case.dart';
import 'package:mobile_app/features/session_mangement/domain/use_cases/listen_attendence_use_case.dart';
import 'package:mobile_app/features/session_mangement/domain/use_cases/start_session_server_use_case.dart';
import 'package:mobile_app/features/session_mangement/domain/use_cases/delete_current_session_use_case.dart';
import 'package:mobile_app/features/session_mangement/presentation/logic/session_management_state.dart';
import 'package:mobile_app/features/session_mangement/data/models/remote_models/get_all_halls/get_all_halls_response.dart';

class SessionManagementCubit extends Cubit<SessionManagementState> {
  final CreateSessionUseCase createSessionUseCase;
  final StartSessionServerUseCase startSessionServerUseCase;
  final EndSessionUseCase endSessionUseCase;
  final ListenAttendanceUseCase listenAttendanceUseCase;
  final GetAllHallsUseCase getAllHallsUseCase;
  final DeleteCurrentSessionUseCase deleteCurrentSessionUseCase;
  final SessionTimerService _timerService;

  StreamSubscription<AttendanceRecord>? _attendanceSubscription;

  List<HallInfo>? _cachedHalls;

  SessionManagementCubit({
    required this.createSessionUseCase,
    required this.startSessionServerUseCase,
    required this.endSessionUseCase,
    required this.listenAttendanceUseCase,
    required this.getAllHallsUseCase,
    required this.deleteCurrentSessionUseCase,
    SessionTimerService? timerService,
  })  : _timerService = timerService ?? SessionTimerService(),
        super(const SessionManagementInitial());

  
  // Halls

  Future<void> loadHalls() async {
    final currentSelectedTab = _currentTabIndex;

    // First load (no cache) → show full-screen shimmer, same as old loadStats()
    if (_cachedHalls == null) {
      emit(const SessionManagementLoading());
    } else {
      // Subsequent loads → keep existing content, just show inline loader
      emit(
        SessionManagementIdle(
          selectedTabIndex: currentSelectedTab,
          halls: _cachedHalls,
          isLoadingHalls: true,
        ),
      );
    }

    try {
      final halls = await getAllHallsUseCase();
      _cachedHalls = halls.halls;

      emit(
        SessionManagementIdle(
          selectedTabIndex: currentSelectedTab,
          halls: _cachedHalls,
          isLoadingHalls: false,
        ),
      );
    } on ApiErrorModel catch (error) {
      emit(SessionError(error: error, selectedTabIndex: currentSelectedTab));
    } catch (_) {
      emit(
        SessionError(
          error: const ApiErrorModel(
            message: 'Failed to load halls',
            type: ApiErrorType.connectionError,
            statusCode: 0,
          ),
          selectedTabIndex: currentSelectedTab,
        ),
      );
    }
  }

  // Tab

  void changeTab(int index) {
    final currentState = state;
    if (currentState is SessionManagementIdle) {
      emit(currentState.copyWith(selectedTabIndex: index));
    } else if (currentState is SessionState) {
      emit(currentState.copyWith(selectedTabIndex: index));
    }
  }

  // Session Lifecycle
  

  Future<void> createAndStartSession({
    required String name,
    required String location,
    required String connectionMethod,
    required TimeOfDay startTime,
    required int durationMinutes,
    required double allowedRadius,
    required int? hallId,
  }) async {
    final currentState = state;
    if (currentState is! SessionManagementStateWithTab) return;

    try {
      await _createSession(
        name: name,
        location: location,
        connectionMethod: connectionMethod,
        startTime: startTime,
        durationMinutes: durationMinutes,
        allowedRadius: allowedRadius,
        selectedTabIndex: currentState.selectedTabIndex,
        hallId: hallId,
      );

      await _startServer(currentState.selectedTabIndex);
    } on ApiErrorModel catch (error) {
      _handleSessionError(error, currentState.selectedTabIndex);
    } catch (_) {
      _handleSessionError(
        const ApiErrorModel(
          message: 'An unexpected error occurred',
          type: ApiErrorType.unknown,
          statusCode: 500,
        ),
        currentState.selectedTabIndex,
      );
    }
  }

  Future<void> endSession() async {
    final currentState = state;
    if (currentState is! SessionState) return;

    try {
      emit(currentState.copyWith(operation: SessionOperation.ending));

      _timerService.cancel();
      await _cancelAttendanceSubscription();

      await endSessionUseCase(currentState.session.id, currentState.session);

      emit(
        currentState.copyWith(
          session: currentState.session.copyWith(status: SessionStatus.ended),
          operation: SessionOperation.ended,
        ),
      );

      await Future.delayed(const Duration(seconds: 2));
      _goIdle(currentState.selectedTabIndex);
    } on ApiErrorModel catch (error) {
      _handleSessionError(error, currentState.selectedTabIndex);
    } catch (_) {
      _handleSessionError(
        const ApiErrorModel(
          message: 'Failed to end session',
          type: ApiErrorType.unknown,
          statusCode: 500,
        ),
        currentState.selectedTabIndex,
      );
    }
  }

  Future<void> deleteSession() async {
    final currentState = state;
    if (currentState is! SessionState) return;

    try {
      emit(currentState.copyWith(operation: SessionOperation.deleting));

      _timerService.cancel();
      await _cancelAttendanceSubscription();

      await deleteCurrentSessionUseCase();

      emit(
        currentState.copyWith(
          session: currentState.session.copyWith(status: SessionStatus.ended),
          operation: SessionOperation.deleted,
        ),
      );

      await Future.delayed(const Duration(seconds: 2));
      _goIdle(currentState.selectedTabIndex);

      loadHalls().catchError((_) {});
    } on ApiErrorModel catch (error) {
      _handleSessionError(error, currentState.selectedTabIndex);
    } catch (_) {
      _handleSessionError(
        const ApiErrorModel(
          message: 'Failed to delete session',
          type: ApiErrorType.unknown,
          statusCode: 500,
        ),
        currentState.selectedTabIndex,
      );
    }
  }

  // Private helpers

  Future<void> _createSession({
    required String name,
    required String location,
    required String connectionMethod,
    required TimeOfDay startTime,
    required int durationMinutes,
    required double allowedRadius,
    required int selectedTabIndex,
    required int? hallId,
  }) async {
    final now = DateTime.now();
    final sessionStartTime = DateTime(
      now.year,
      now.month,
      now.day,
      startTime.hour,
      startTime.minute,
    );

    // Show optimistic placeholder while creating
    emit(
      SessionState(
        session: Session(
          id: 0,
          name: name,
          location: location,
          connectionMethod: connectionMethod,
          startTime: sessionStartTime,
          durationMinutes: durationMinutes,
          status: SessionStatus.inactive,
          connectedClients: 0,
          attendanceList: [],
        ),
        operation: SessionOperation.creating,
        selectedTabIndex: selectedTabIndex,
      ),
    );

    final session = await createSessionUseCase(
      name: name,
      location: location,
      connectionMethod: connectionMethod,
      startTime: sessionStartTime,
      durationMinutes: durationMinutes,
      allowedRadius: allowedRadius,
      hallId: hallId,
    );

    await Future.delayed(const Duration(milliseconds: 500));

    emit(
      SessionState(
        session: session,
        operation: SessionOperation.starting,
        selectedTabIndex: selectedTabIndex,
      ),
    );
  }

  Future<void> _startServer(int selectedTabIndex) async {
    final currentState = state;
    if (currentState is! SessionState) return;

    final serverInfo = await startSessionServerUseCase(
      currentState.session.id,
    );

    final activeSession = currentState.session.copyWith(
      status: SessionStatus.active,
    );

    _listenToAttendance();

    emit(
      SessionState(
        session: activeSession,
        operation: SessionOperation.active,
        serverInfo: serverInfo,
        selectedTabIndex: selectedTabIndex,
      ),
    );

    // Delegate timer logic to the dedicated service
    _timerService.start(
      session: activeSession,
      onExpired: _onSessionExpired,
      onWarning: _onSessionWarning,
    );
  }

  void _listenToAttendance() {
    _attendanceSubscription?.cancel();
    _attendanceSubscription = listenAttendanceUseCase().listen(
      (record) {
        final currentState = state;
        if (currentState is! SessionState) return;

        final updatedAttendance = List<AttendanceRecord>.from(
          currentState.session.attendanceList,
        )..add(record);

        emit(
          currentState.copyWith(
            session: currentState.session.copyWith(
              attendanceList: updatedAttendance,
              connectedClients: updatedAttendance.length,
            ),
            latestRecord: record,
          ),
        );

        // Clear the latest record badge after a short delay
        Future.delayed(const Duration(milliseconds: 100), () {
          final s = state;
          if (s is SessionState && s.latestRecord != null) {
            emit(s.copyWith(clearLatestRecord: true));
          }
        });
      },
      onError: (_) {},
    );
  }

  // --- Timer callbacks (called by SessionTimerService) ---

  void _onSessionExpired() {
    if (state is! SessionState) return;
    endSession().catchError((_) {});
  }

  void _onSessionWarning() {
    final currentState = state;
    if (currentState is! SessionState) return;

    emit(currentState.copyWith(showWarning: true));

    Future.delayed(const Duration(seconds: 5), () {
      final s = state;
      if (s is SessionState && s.showWarning) {
        emit(s.copyWith(showWarning: false));
      }
    });
  }


  void _handleSessionError(ApiErrorModel error, int selectedTabIndex) {
    emit(SessionError(error: error, selectedTabIndex: selectedTabIndex));

    Future.delayed(const Duration(seconds: 3), () {
      if (state is SessionError) {
        _goIdle(selectedTabIndex);
      }
    });
  }

  void _goIdle(int tabIndex) {
    emit(SessionManagementIdle(selectedTabIndex: tabIndex, halls: _cachedHalls));
  }

  Future<void> _cancelAttendanceSubscription() async {
    await _attendanceSubscription?.cancel();
    _attendanceSubscription = null;
  }

  int get _currentTabIndex => state is SessionManagementStateWithTab
      ? (state as SessionManagementStateWithTab).selectedTabIndex
      : 0;

  

  @override
  Future<void> close() {
    _timerService.dispose();
    _attendanceSubscription?.cancel();
    return super.close();
  }
}