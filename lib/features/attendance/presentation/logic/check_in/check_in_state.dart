import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
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
  authenticationFailed,
}

extension CheckInFailureReasonX on CheckInFailureReason {
  Color get color => switch (this) {
    CheckInFailureReason.alreadyCheckedIn => Colors.orange,
    CheckInFailureReason.outsideZone => Colors.blue,
    CheckInFailureReason.authenticationFailed => Colors.purple,
    _ => Colors.red,
  };

  IconData get icon => switch (this) {
    CheckInFailureReason.alreadyCheckedIn => Icons.info,
    CheckInFailureReason.outsideZone => Icons.location_off,
    CheckInFailureReason.authenticationFailed => Icons.fingerprint,
    _ => Icons.error,
  };

  String get title => switch (this) {
    CheckInFailureReason.alreadyCheckedIn =>
      'attendance.check_in_fail_already_title'.tr(),
    CheckInFailureReason.outsideZone =>
      'attendance.check_in_fail_zone_title'.tr(),
    CheckInFailureReason.authenticationFailed =>
      'attendance.check_in_fail_auth_title'.tr(),
    _ => 'attendance.check_in_fail_generic_title'.tr(),
  };

  String get message => switch (this) {
    CheckInFailureReason.alreadyCheckedIn =>
      'attendance.check_in_fail_already_msg'.tr(),
    CheckInFailureReason.outsideZone =>
      'attendance.check_in_fail_zone_msg'.tr(),
    CheckInFailureReason.networkError =>
      'attendance.check_in_fail_network_msg'.tr(),
    CheckInFailureReason.authenticationFailed =>
      'attendance.check_in_fail_auth_msg'.tr(),
    CheckInFailureReason.unknown =>
      'attendance.check_in_fail_unknown_msg'.tr(),
  };
}