import 'dart:async';

typedef OnSearchTimeout = void Function();
typedef OnSessionRefresh = void Function();

/// Responsible ONLY for managing discovery-related timers.
/// Has zero knowledge of Cubit, State, or UI.
class DiscoveryTimerService {
  Timer? _searchTimeoutTimer;
  Timer? _sessionRefreshTimer;

  static const _refreshInterval = Duration(seconds: 30);

  bool get isTimeoutActive => _searchTimeoutTimer?.isActive ?? false;

  /// Starts the search timeout timer.
  void startSearchTimeout({
    required Duration timeout,
    required OnSearchTimeout onTimeout,
  }) {
    _searchTimeoutTimer?.cancel();
    _searchTimeoutTimer = Timer(timeout, onTimeout);
  }

  /// Cancels the search timeout — call this when a session is found.
  void cancelSearchTimeout() {
    _searchTimeoutTimer?.cancel();
    _searchTimeoutTimer = null;
  }

  /// Starts the periodic session refresh timer.
  /// [onRefresh] fires every 30 seconds to clean up expired sessions.
  void startSessionRefresh({required OnSessionRefresh onRefresh}) {
    _sessionRefreshTimer?.cancel();
    _sessionRefreshTimer = Timer.periodic(_refreshInterval, (_) => onRefresh());
  }

  /// Cancels all active timers.
  void cancel() {
    _searchTimeoutTimer?.cancel();
    _searchTimeoutTimer = null;
    _sessionRefreshTimer?.cancel();
    _sessionRefreshTimer = null;
  }

  /// Must be called when the service is no longer needed.
  void dispose() => cancel();
}