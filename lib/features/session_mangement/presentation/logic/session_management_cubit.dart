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
import 'package:mobile_app/features/session_mangement/domain/use_cases/get_all_sections.dart';
import 'package:mobile_app/features/session_mangement/domain/use_cases/listen_attendence_use_case.dart';
import 'package:mobile_app/features/session_mangement/domain/use_cases/start_session_server_use_case.dart';
import 'package:mobile_app/features/session_mangement/domain/use_cases/delete_current_session_use_case.dart';
import 'package:mobile_app/features/session_mangement/presentation/logic/session_management_state.dart';

class SessionManagementCubit extends Cubit<SessionManagementState> {
  final CreateSessionUseCase createSessionUseCase;
  final StartSessionServerUseCase startSessionServerUseCase;
  final EndSessionUseCase endSessionUseCase;
  final ListenAttendanceUseCase listenAttendanceUseCase;
  final GetAllHallsUseCase getAllHallsUseCase;
  final DeleteCurrentSessionUseCase deleteCurrentSessionUseCase;
  final SessionTimerService _timerService;
  final GetAllSectionsUseCase getAllSectionsUseCase;

  StreamSubscription<AttendanceRecord>? _attendanceSubscription;

  SessionManagementCubit({
    required this.getAllSectionsUseCase,
    required this.createSessionUseCase,
    required this.startSessionServerUseCase,
    required this.endSessionUseCase,
    required this.listenAttendanceUseCase,
    required this.getAllHallsUseCase,
    required this.deleteCurrentSessionUseCase,
    SessionTimerService? timerService,
  }) : _timerService = timerService ?? SessionTimerService(),
       super(const SessionManagementInitial());

  Future<void> loadSections() async {
    final tabIndex = _currentTabIndex;
    final currentIdle = state is SessionManagementIdle
        ? state as SessionManagementIdle
        : null;

    if (currentIdle == null) {
      emit(const SessionManagementLoading());
    } else {
      emit(currentIdle.copyWith(isLoadingSections: true));
    }

    try {
      final sections = (await getAllSectionsUseCase()).sections;
      emit(
        SessionManagementIdle(
          selectedTabIndex: tabIndex,
          sections: sections,
          isLoadingSections: false,
        ),
      );
    } on ApiErrorModel catch (error) {
      emit(SessionError(error: error, selectedTabIndex: tabIndex));
    } catch (_) {
      emit(
        SessionError(
          error: const ApiErrorModel(
            message: 'Failed to load sections',
            type: ApiErrorType.connectionError,
            statusCode: 0,
          ),
          selectedTabIndex: tabIndex,
        ),
      );
    }
  }

  Future<void> loadHalls() async {
    final tabIndex = _currentTabIndex;
    final currentIdle = state is SessionManagementIdle
        ? state as SessionManagementIdle
        : null;

    if (currentIdle == null) {
      emit(const SessionManagementLoading());
    } else {
      emit(currentIdle.copyWith(isLoadingHalls: true));
    }

    try {
      final halls = (await getAllHallsUseCase()).halls;
      emit(
        SessionManagementIdle(
          selectedTabIndex: tabIndex,
          halls: halls,
          isLoadingHalls: false,
        ),
      );
    } on ApiErrorModel catch (error) {
      emit(SessionError(error: error, selectedTabIndex: tabIndex));
    } catch (_) {
      emit(
        SessionError(
          error: const ApiErrorModel(
            message: 'Failed to load halls',
            type: ApiErrorType.connectionError,
            statusCode: 0,
          ),
          selectedTabIndex: tabIndex,
        ),
      );
    }
  }

  // ─── Tab ───────────────────────────────────────────────────

  void changeTab(int index) {
    final s = state;
    if (s is SessionManagementIdle) emit(s.copyWith(selectedTabIndex: index));
    if (s is SessionState) emit(s.copyWith(selectedTabIndex: index));
  }

  // ─── Session Lifecycle ─────────────────────────────────────

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

  // ─── Private: Session Creation ─────────────────────────────

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

    final serverInfo = await startSessionServerUseCase(currentState.session.id);
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

    _timerService.start(
      session: activeSession,
      onExpired: _onSessionExpired,
      onWarning: _onSessionWarning,
    );
  }

  void _listenToAttendance() {
    _attendanceSubscription?.cancel();
    _attendanceSubscription = listenAttendanceUseCase().listen((record) {
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

      _clearFlagAfterDelay(
        const Duration(milliseconds: 100),
        (s) => s.latestRecord != null,
        (s) => s.copyWith(clearLatestRecord: true),
      );
    }, onError: (_) {});
  }

  void _onSessionExpired() {
    if (state is! SessionState) return;
    endSession().catchError((_) {});
  }

  void _onSessionWarning() {
    final currentState = state;
    if (currentState is! SessionState) return;

    emit(currentState.copyWith(showWarning: true));

    _clearFlagAfterDelay(
      const Duration(seconds: 5),
      (s) => s.showWarning,
      (s) => s.copyWith(showWarning: false),
    );
  }

  /// Emits a cleared state after [delay] if [check] is still true.
  void _clearFlagAfterDelay(
    Duration delay,
    bool Function(SessionState) check,
    SessionState Function(SessionState) clear,
  ) {
    Future.delayed(delay, () {
      final s = state;
      if (s is SessionState && check(s)) emit(clear(s));
    });
  }

  void _handleSessionError(ApiErrorModel error, int selectedTabIndex) {
    emit(SessionError(error: error, selectedTabIndex: selectedTabIndex));
    Future.delayed(const Duration(seconds: 3), () {
      if (state is SessionError) _goIdle(selectedTabIndex);
    });
  }

  void _goIdle(int tabIndex) {
    // halls list is now owned by the repository/use-case layer
    emit(SessionManagementIdle(selectedTabIndex: tabIndex));
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
