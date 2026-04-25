import 'package:mobile_app/features/attendance/domain/entities/nearby_session.dart';

sealed class CheckInState {
  const CheckInState();
}

final class CheckInIdle extends CheckInState {
  const CheckInIdle();
}

final class CheckInLoading extends CheckInState {
  final NearbySession session;
  const CheckInLoading({required this.session});
}

final class CheckInSuccess extends CheckInState {
  final NearbySession session;
  final DateTime checkInTime;

  const CheckInSuccess({required this.session, required this.checkInTime});
}

final class CheckInFailed extends CheckInState {
  final NearbySession session;
  final CheckInFailureReason reason;

  const CheckInFailed({required this.session, required this.reason});
}

enum CheckInFailureReason {
  alreadyCheckedIn,
  outsideZone,
  networkError,
  unknown,
}
