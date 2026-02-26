import 'dart:async';
import 'package:mobile_app/features/session_mangement/domain/entities/session.dart';

/// Callbacks triggered by the timer service
typedef OnSessionExpired = void Function();
typedef OnSessionWarning = void Function();

/// Responsible ONLY for managing session timers.
/// Has zero knowledge of Cubit, State, or UI.
class SessionTimerService {
  Timer? _sessionTimer;
  Timer? _warningTimer;

  static const _warningBeforeEnd = Duration(minutes: 5);
  bool get isRunning => _sessionTimer?.isActive ?? false;

  /// Starts the session countdown.
  /// [onExpired] fires when the session time is up.
  /// [onWarning] fires 5 minutes before the session ends.
  void start({
    required Session session,
    required OnSessionExpired onExpired,
    required OnSessionWarning onWarning,
  }) {
    cancel(); // cancel any previous timers first

    final endTime = session.startTime.add(
      Duration(minutes: session.durationMinutes),
    );
    final timeUntilEnd = endTime.difference(DateTime.now());

    // Session already expired
    if (timeUntilEnd.isNegative) {
      onExpired();
      return;
    }

    // Schedule end timer
    _sessionTimer = Timer(timeUntilEnd, onExpired);

    // Schedule warning timer
    final timeUntilWarning = timeUntilEnd - _warningBeforeEnd;
    if (timeUntilWarning.isNegative) {
      // Less than 5 minutes left — show warning immediately
      onWarning();
    } else {
      _warningTimer = Timer(timeUntilWarning, onWarning);
    }
  }

  /// Cancels all active timers.
  void cancel() {
    _sessionTimer?.cancel();
    _sessionTimer = null;
    _warningTimer?.cancel();
    _warningTimer = null;
  }

  /// Must be called when the service is no longer needed.
  void dispose() => cancel();
}