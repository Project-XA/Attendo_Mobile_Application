import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/feature/home/presentation/admin/home/data/models/server_info.dart';
import 'package:mobile_app/feature/home/presentation/admin/home/domain/entities/attendency_record.dart';
import 'package:mobile_app/feature/home/presentation/admin/home/domain/entities/session.dart';
import 'package:mobile_app/feature/home/presentation/admin/home/domain/use_cases/create_session_use_case.dart';
import 'package:mobile_app/feature/home/presentation/admin/home/domain/use_cases/end_session_use_case.dart';
import 'package:mobile_app/feature/home/presentation/admin/home/domain/use_cases/listen_attendence_use_case.dart';
import 'package:mobile_app/feature/home/presentation/admin/home/domain/use_cases/start_session_server_use_case.dart';
import 'package:mobile_app/feature/home/presentation/admin/home/presentation/logic/admin_state.dart';

class AdminCubit extends Cubit<AdminState> {
  final CreateSessionUseCase createSessionUseCase;
  final StartSessionServerUseCase startSessionServerUseCase;
  final EndSessionUseCase endSessionUseCase;
  final ListenAttendanceUseCase listenAttendanceUseCase;

  StreamSubscription<AttendanceRecord>? _attendanceSubscription;

  AdminCubit({
    required this.createSessionUseCase,
    required this.startSessionServerUseCase,
    required this.endSessionUseCase,
    required this.listenAttendanceUseCase,
  }) : super(const AdminInitial());

  Future<void> loadStats() async {
    try {
      emit(const AdminLoading());
      await Future.delayed(const Duration(milliseconds: 500));
      emit(const AdminIdle());
    } catch (e) {
      emit(AdminError('Failed to load: $e'));
    }
  }

  // ===================== Tab Navigation =====================

  void changeTab(int index) {
    final currentState = state;

    if (currentState is AdminIdle) {
      emit(currentState.copyWith(selectedTabIndex: index));
    } else if (currentState is SessionState) {
      emit(currentState.copyWith(selectedTabIndex: index));
    }
  }

  // ===================== Session Management =====================

  Future<void> createAndStartSession({
    required String name,
    required String location,
    required String connectionMethod,
    required TimeOfDay startTime,
    required int durationMinutes,
  }) async {
    final currentState = state;
    if (currentState is! AdminStateWithTab) return;

    try {
      // Step 1: Create session
      await _createSession(
        name: name,
        location: location,
        connectionMethod: connectionMethod,
        startTime: startTime,
        durationMinutes: durationMinutes,
        selectedTabIndex: currentState.selectedTabIndex,
      );

      // Step 2: Start server and activate session
      await _startServer(currentState.selectedTabIndex);
    } catch (e) {
      _handleSessionError(
        'Failed to start session: $e',
        currentState.selectedTabIndex,
      );
    }
  }

  Future<void> _createSession({
    required String name,
    required String location,
    required String connectionMethod,
    required TimeOfDay startTime,
    required int durationMinutes,
    required int selectedTabIndex,
  }) async {
    final now = DateTime.now();
    final sessionStartTime = DateTime(
      now.year,
      now.month,
      now.day,
      startTime.hour,
      startTime.minute,
    );

    final placeholderSession = Session(
      id: '',
      name: name,
      location: location,
      connectionMethod: connectionMethod,
      startTime: sessionStartTime,
      durationMinutes: durationMinutes,
      status: SessionStatus.inactive,
      connectedClients: 0,
      attendanceList: [],
    );

    emit(
      SessionState(
        session: placeholderSession,
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

    _listenToAttendance(
      currentState.session,
      serverInfo,
      selectedTabIndex,
    );

    final activeSession = currentState.session.copyWith(
      status: SessionStatus.active,
    );

    emit(
      SessionState(
        session: activeSession,
        operation: SessionOperation.active,
        serverInfo: serverInfo,
        selectedTabIndex: selectedTabIndex,
      ),
    );
  }

  // ===================== Attendance Listening =====================

  void _listenToAttendance(
    Session session,
    ServerInfo serverInfo,
    int selectedTabIndex,
  ) {
    _attendanceSubscription?.cancel();
    _attendanceSubscription = listenAttendanceUseCase().listen(
      (record) {
        final currentState = state;
        if (currentState is! SessionState) return;

        final updatedAttendance = List<AttendanceRecord>.from(
          currentState.session.attendanceList,
        )..add(record);

        final updatedSession = currentState.session.copyWith(
          attendanceList: updatedAttendance,
          connectedClients: updatedAttendance.length,
        );

        emit(
          currentState.copyWith(session: updatedSession, latestRecord: record),
        );

        Future.delayed(const Duration(milliseconds: 100), () {
          final state = this.state;
          if (state is SessionState && state.latestRecord != null) {
            emit(state.copyWith(clearLatestRecord: true));
          }
        });
      },
      onError: (error) {
        debugPrint('❌ Attendance stream error: $error');
      },
    );
  }

  // ===================== End Session =====================

  Future<void> endSession() async {
    final currentState = state;
    if (currentState is! SessionState) return;

    try {
      emit(currentState.copyWith(operation: SessionOperation.ending));

      await _attendanceSubscription?.cancel();
      _attendanceSubscription = null;

      await endSessionUseCase(currentState.session.id);

      final endedSession = currentState.session.copyWith(
        status: SessionStatus.ended,
      );

      emit(
        currentState.copyWith(
          session: endedSession,
          operation: SessionOperation.ended,
        ),
      );

      await Future.delayed(const Duration(seconds: 2));

      emit(
        AdminIdle(
          selectedTabIndex: currentState.selectedTabIndex,
        ),
      );
    } catch (e) {
      _handleSessionError(
        'Failed to end session: $e',
        currentState.selectedTabIndex,
      );
    }
  }

  // ===================== Error Handling =====================

  void _handleSessionError(String message, int selectedTabIndex) {
    emit(
      SessionError(
        message: message,
        selectedTabIndex: selectedTabIndex,
      ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      if (state is SessionError) {
        emit(AdminIdle(selectedTabIndex: selectedTabIndex));
      }
    });
  }

  // ===================== Cleanup =====================

  @override
  Future<void> close() {
    _attendanceSubscription?.cancel();
    return super.close();
  }
}