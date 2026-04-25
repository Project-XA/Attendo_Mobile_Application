import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/features/attendance/data/services/discover_timer_service.dart';
import 'package:mobile_app/features/attendance/domain/entities/nearby_session.dart';
import 'package:mobile_app/features/attendance/domain/use_cases/discover_session_use_case.dart';
import 'package:mobile_app/features/attendance/domain/use_cases/start_discovery_use_case.dart';
import 'package:mobile_app/features/attendance/domain/use_cases/stop_discover_use_case.dart';
import 'package:mobile_app/features/attendance/presentation/logic/discover/discover_state.dart';

class DiscoveryCubit extends Cubit<DiscoveryState> {
  final StartDiscoveryUseCase _startDiscoveryUseCase;
  final StopDiscoveryUseCase _stopDiscoveryUseCase;
  final DiscoverSessionsUseCase _discoverSessionsUseCase;
  final DiscoveryTimerService _timerService;

  StreamSubscription<NearbySession>? _discoverySubscription;
  Duration searchTimeout = const Duration(seconds: 30);

  DiscoveryCubit({
    required StartDiscoveryUseCase startDiscoveryUseCase,
    required StopDiscoveryUseCase stopDiscoveryUseCase,
    required DiscoverSessionsUseCase discoverSessionsUseCase,
    DiscoveryTimerService? timerService,
  }) : _startDiscoveryUseCase = startDiscoveryUseCase,
       _stopDiscoveryUseCase = stopDiscoveryUseCase,
       _discoverSessionsUseCase = discoverSessionsUseCase,
       _timerService = timerService ?? DiscoveryTimerService(),
       super(const DiscoveryIdle());

  Future<void> startSessionDiscovery() async {
    try {
      if (!isClosed) emit(const DiscoverySearching());

      await _startDiscoveryUseCase.call();

      _timerService.startSearchTimeout(
        timeout: searchTimeout,
        onTimeout: _handleSearchTimeout,
      );

      _timerService.startSessionRefresh(onRefresh: _refreshSessions);

      _discoverySubscription?.cancel();
      _discoverySubscription = _discoverSessionsUseCase.call().listen((
        session,
      ) {
        _timerService.cancelSearchTimeout();
        _handleDiscoveredSession(session);
      }, onError: (_) {});
    } catch (_) {
      if (!isClosed) emit(const DiscoveryIdle());
    }
  }

  Future<void> stopSessionDiscovery() async {
    try {
      await _cancelDiscovery();
      await _stopDiscoveryUseCase.call();
      if (!isClosed) emit(const DiscoveryStopped());
    } catch (_) {}
  }

  Future<void> refreshSessions() async {
    final currentState = state;
    if (currentState is DiscoverySessionFound) {
      if (!isClosed) emit(const DiscoverySearching());

      _timerService.startSearchTimeout(
        timeout: searchTimeout,
        onTimeout: _handleSearchTimeout,
      );
    } else {
      await startSessionDiscovery();
    }
  }

  Future<void> stopSearch() async {
    await stopSessionDiscovery();
  }

  void _handleSearchTimeout() {
    if (isClosed) return;
    final currentState = state;

    // لو لقى sessions قبل الـ timeout يفضل عليها
    if (currentState is DiscoverySessionFound) return;

    emit(const DiscoveryTimeout());
  }

  void _handleDiscoveredSession(NearbySession session) {
    if (isClosed) return;
    final currentState = state;

    if (currentState is DiscoverySessionFound) {
      final alreadyExists = currentState.allSessions.any(
        (s) => s.sessionId == session.sessionId,
      );
      if (alreadyExists) return;

      emit(
        currentState.copyWith(
          allSessions: [...currentState.allSessions, session],
        ),
      );
    } else {
      emit(
        DiscoverySessionFound(activeSession: session, allSessions: [session]),
      );
    }
  }

  void _refreshSessions() {
    if (isClosed) return;
    final currentState = state;
    if (currentState is! DiscoverySessionFound) return;

    final now = DateTime.now();
    final activeSessions = currentState.allSessions
        .where((s) => s.endTime.isAfter(now))
        .toList();

    if (activeSessions.length == currentState.allSessions.length) return;

    if (activeSessions.isEmpty) {
      emit(const DiscoveryTimeout());
      return;
    }

    emit(
      currentState.copyWith(
        allSessions: activeSessions,
        activeSession: activeSessions.first,
      ),
    );
  }

  Future<void> _cancelDiscovery() async {
    await _discoverySubscription?.cancel();
    _discoverySubscription = null;
    _timerService.cancel();
  }

  @override
  Future<void> close() {
    _timerService.dispose();
    _discoverySubscription?.cancel();
    return super.close();
  }
}
