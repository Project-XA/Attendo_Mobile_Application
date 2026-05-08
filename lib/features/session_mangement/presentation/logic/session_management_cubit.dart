import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/core/networking/api_error_model.dart';
import 'package:mobile_app/features/session_mangement/data/models/attendency_record.dart';
import 'package:mobile_app/features/session_mangement/data/service/session_time_service.dart';
import 'package:mobile_app/features/session_mangement/domain/entities/create_and_start_sessoin_params.dart';
import 'package:mobile_app/features/session_mangement/domain/entities/session.dart';
import 'package:mobile_app/features/session_mangement/domain/use_cases/get_all_halls_use_case.dart';
import 'package:mobile_app/features/session_mangement/domain/use_cases/get_all_sections.dart';
import 'package:mobile_app/features/session_mangement/presentation/logic/session_attendance_manager.dart';
import 'package:mobile_app/features/session_mangement/presentation/logic/session_lifcycle_handler.dart';
import 'package:mobile_app/features/session_mangement/presentation/logic/session_management_state.dart';

/// Cubit that orchestrates session management UI state.
///
/// It delegates:
/// - API calls          → [SessionLifecycleHandler]
/// - Attendance stream  → [SessionAttendanceManager]
/// - Session timer      → [SessionTimerService]
///
/// This cubit is only responsible for:
/// - Deciding which state to emit based on outcomes
/// - Coordinating the sequence of operations
class SessionManagementCubit extends Cubit<SessionManagementState> {
  // ─── Dependencies ──────────────────────────────────────────

  final GetAllHallsUseCase _getAllHalls;
  final GetAllSectionsUseCase _getAllSections;
  final SessionLifecycleHandler _lifecycle;
  final SessionAttendanceManager _attendance;
  final SessionTimerService _timer;

  /// Cached idle state so that halls/sections are never lost
  /// when transitioning back from a session or error state.
  SessionManagementIdle _lastIdleState = const SessionManagementIdle();

  // ─── Constructor ───────────────────────────────────────────

  SessionManagementCubit({
    required GetAllHallsUseCase getAllHalls,
    required GetAllSectionsUseCase getAllSections,
    required SessionLifecycleHandler lifecycle,
    required SessionAttendanceManager attendance,
    SessionTimerService? timer,
  }) : _getAllHalls = getAllHalls,
       _getAllSections = getAllSections,
       _lifecycle = lifecycle,
       _attendance = attendance,
       _timer = timer ?? SessionTimerService(),
       super(const SessionManagementInitial());

  // ─── Public: Data Loading ──────────────────────────────────

  /// Loads halls and sections in parallel. Safe to call on screen init.
  Future<void> loadInitialData() async {
    await Future.wait([loadHalls(), loadSections()]);
  }

  Future<void> loadHalls() async {
    final baseline = _idleBaseline();
    _emitIdle(baseline.copyWith(isLoadingHalls: true));

    try {
      final halls = (await _getAllHalls()).halls;
      _emitIdle(baseline.copyWith(halls: halls, isLoadingHalls: false));
    } catch (error) {
      _emitLoadError('Failed to load halls', error);
    }
  }

  Future<void> loadSections() async {
    final baseline = _idleBaseline();
    _emitIdle(baseline.copyWith(isLoadingSections: true));

    try {
      final sections = (await _getAllSections()).sections;
      _emitIdle(
        baseline.copyWith(sections: sections, isLoadingSections: false),
      );
    } catch (error) {
      _emitLoadError('Failed to load sections', error);
    }
  }

  // ─── Public: Tab ───────────────────────────────────────────

  void changeTab(int index) {
    final s = state;
    if (s is SessionManagementIdle) {
      _emitIdle(s.copyWith(selectedTabIndex: index));
    }
    if (s is SessionState) emit(s.copyWith(selectedTabIndex: index));
  }

  // ─── Public: Session Lifecycle ─────────────────────────────

  /// Full flow: create session on backend → start server → begin attendance.
  Future<void> createAndStartSession(CreateAndStartSessoinParams params) async {
    final tabIndex = _tabIndex;
    if (state is! SessionManagementStateWithTab) return;

    try {
      final session = await _createSessionWithOptimisticUI(params, tabIndex);
      await _activateSession(session, tabIndex);
    } catch (error) {
      _emitSessionError('An unexpected error occurred', error, tabIndex);
    }
  }

  Future<void> endSession() async {
    final current = _requireSessionState();
    if (current == null) return;

    try {
      emit(current.copyWith(operation: SessionOperation.ending));
      await _stopSessionResources();
      await _lifecycle.end(current.session.id, current.session);
      await _emitEndedAndWait(current, SessionOperation.ended);
      _goIdle(current.selectedTabIndex);
    } catch (error) {
      _emitSessionError(
        'Failed to end session',
        error,
        current.selectedTabIndex,
      );
    }
  }

  Future<void> deleteSession() async {
    final current = _requireSessionState();
    if (current == null) return;

    try {
      emit(current.copyWith(operation: SessionOperation.deleting));
      await _stopSessionResources();
      await _lifecycle.delete();
      await _emitEndedAndWait(current, SessionOperation.deleted);
      _goIdle(current.selectedTabIndex);
      // Silent reload — never shows error even if it fails
      _silentReloadHalls();
    } catch (error) {
      _emitSessionError(
        'Failed to delete session',
        error,
        current.selectedTabIndex,
      );
    }
  }

  // ─── Private: Session Creation ─────────────────────────────

  /// Shows optimistic "creating" UI, calls the backend, then shows "starting".
  Future<Session> _createSessionWithOptimisticUI(
    CreateAndStartSessoinParams params,
    int tabIndex,
  ) async {
    emit(
      SessionState(
        session: Session.placeholder(params),
        operation: SessionOperation.creating,
        selectedTabIndex: tabIndex,
      ),
    );

    final session = await _lifecycle.create(
      name: params.name,
      location: params.location,
      connectionMethod: params.connectionMethod,
      startTime: params.startTime,
      durationMinutes: params.durationMinutes,
      allowedRadius: params.allowedRadius,
      target: params.target,
    );

    await Future.delayed(const Duration(milliseconds: 500));

    emit(
      SessionState(
        session: session,
        operation: SessionOperation.starting,
        selectedTabIndex: tabIndex,
      ),
    );

    return session;
  }

  /// Starts the server, wires up attendance + timer, emits active state.
  Future<void> _activateSession(Session session, int tabIndex) async {
    final serverInfo = await _lifecycle.startServer(session.id);
    final activeSession = session.copyWith(status: SessionStatus.active);

    _attendance.startListening(onNewRecord: _onAttendanceRecord);

    emit(
      SessionState(
        session: activeSession,
        operation: SessionOperation.active,
        serverInfo: serverInfo,
        selectedTabIndex: tabIndex,
      ),
    );

    _timer.start(
      session: activeSession,
      onExpired: _onSessionExpired,
      onWarning: _onSessionWarning,
    );
  }

  // ─── Private: Attendance Callbacks ─────────────────────────

  void _onAttendanceRecord(AttendanceRecord record) {
    final current = state;
    if (current is! SessionState) return;

    final updatedList = [...current.session.attendanceList, record];

    emit(
      current.copyWith(
        session: current.session.copyWith(
          attendanceList: updatedList,
          connectedClients: updatedList.length,
        ),
        latestRecord: record,
      ),
    );

    _scheduleStateUpdate(
      delay: const Duration(milliseconds: 100),
      condition: (s) => s.latestRecord != null,
      update: (s) => s.copyWith(clearLatestRecord: true),
    );
  }

  // ─── Private: Timer Callbacks ──────────────────────────────

  void _onSessionExpired() {
    if (state is SessionState) endSession().catchError((_) {});
  }

  void _onSessionWarning() {
    final current = state;
    if (current is! SessionState) return;

    emit(current.copyWith(showWarning: true));

    _scheduleStateUpdate(
      delay: const Duration(seconds: 5),
      condition: (s) => s.showWarning,
      update: (s) => s.copyWith(showWarning: false),
    );
  }

  // ─── Private: State Helpers ────────────────────────────────

  SessionManagementIdle _idleBaseline() {
    return state is SessionManagementIdle
        ? state as SessionManagementIdle
        : _lastIdleState.copyWith(selectedTabIndex: _tabIndex);
  }

  void _emitIdle(SessionManagementIdle idle) {
    _lastIdleState = idle;
    emit(idle);
  }

  void _goIdle(int tabIndex) {
    _emitIdle(_lastIdleState.copyWith(selectedTabIndex: tabIndex));
  }

  Future<void> _emitEndedAndWait(
    SessionState current,
    SessionOperation op,
  ) async {
    emit(
      current.copyWith(
        session: current.session.copyWith(status: SessionStatus.ended),
        operation: op,
      ),
    );
    await Future.delayed(const Duration(seconds: 2));
  }

  Future<void> _stopSessionResources() async {
    _timer.cancel();
    await _attendance.cancel();
  }

  SessionState? _requireSessionState() {
    final s = state;
    return s is SessionState ? s : null;
  }

  void _scheduleStateUpdate({
    required Duration delay,
    required bool Function(SessionState) condition,
    required SessionState Function(SessionState) update,
  }) {
    Future.delayed(delay, () {
      final s = state;
      if (s is SessionState && condition(s)) emit(update(s));
    });
  }

  /// Refreshes halls in the background after delete.
  /// Never emits an error — failures are silently ignored
  /// and the previously cached halls remain intact.
  Future<void> _silentReloadHalls() async {
    try {
      final halls = (await _getAllHalls()).halls;
      _lastIdleState = _lastIdleState.copyWith(halls: halls);
      if (state is SessionManagementIdle) {
        _emitIdle(_lastIdleState);
      }
    } catch (_) {
      // Silent — old halls remain in _lastIdleState
    }
  }

  // ─── Private: Error Handling ───────────────────────────────

  /// Emits a [SessionError] and auto-recovers to idle after 3 seconds.
  void _emitSessionError(String fallbackMessage, Object error, int tabIndex) {
    final apiError = error is ApiErrorModel
        ? error
        : ApiErrorModel(
            message: fallbackMessage,
            type: ApiErrorType.unknown,
            statusCode: 500,
          );

    emit(SessionError(error: apiError, selectedTabIndex: tabIndex));

    Future.delayed(const Duration(seconds: 3), () {
      if (state is SessionError) _goIdle(tabIndex);
    });
  }

  /// Emits a [SessionError] for load failures (halls/sections)
  /// and auto-recovers to idle after 3 seconds.
  void _emitLoadError(String fallbackMessage, Object error) {
    final tabIndex = _tabIndex;

    final apiError = error is ApiErrorModel
        ? error
        : ApiErrorModel(
            message: fallbackMessage,
            type: ApiErrorType.connectionError,
            statusCode: 0,
          );

    emit(SessionError(error: apiError, selectedTabIndex: tabIndex));

    Future.delayed(const Duration(seconds: 3), () {
      if (state is SessionError) _goIdle(tabIndex);
    });
  }

  // ─── Private: Getters ──────────────────────────────────────

  int get _tabIndex => state is SessionManagementStateWithTab
      ? (state as SessionManagementStateWithTab).selectedTabIndex
      : 0;

  // ─── Dispose ───────────────────────────────────────────────

  @override
  Future<void> close() {
    _timer.dispose();
    _attendance.dispose();
    return super.close();
  }
}
