import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/core/services/auth/authentication_manager.dart';
import 'package:mobile_app/features/attendance/domain/entities/nearby_session.dart';
import 'package:mobile_app/features/attendance/domain/use_cases/check_in_use_case.dart';
import 'package:mobile_app/features/attendance/presentation/logic/check_in/check_in_state.dart';

class CheckInCubit extends Cubit<CheckInState> {
  final CheckInUseCase _checkInUseCase;
  final AuthenticationManager _authManager;

  CheckInCubit({
    required CheckInUseCase checkInUseCase,
    required AuthenticationManager authManager,
  }) : _checkInUseCase = checkInUseCase,
       _authManager = authManager,
       super(const CheckInIdle());

  Future<void> checkIn(
    NearbySession session, {
    required String userId,
    required String userName,
    required BuildContext context,
  }) async {
    // أولاً: Local Authentication
    final authenticated = await _authManager.authenticate(context);
    if (!authenticated) {
      if (!isClosed) {
        emit(
          CheckInFailed(
            session: session,
            reason: CheckInFailureReason.authenticationFailed,
          ),
        );
      }
      return;
    }

    if (!isClosed) emit(CheckInLoading(session: session));

    try {
      final response = await _checkInUseCase.call(
        sessionId: session.sessionId,
        baseUrl: session.baseUrl,
        userId: userId,
        userName: userName,
        location: session.location,
      );
      print(response.success);
      print(response.message);

      if (response.success) {
        if (!isClosed) {
          emit(CheckInSuccess(session: session, checkInTime: DateTime.now()));
        }
      } else {
        if (!isClosed) {
          emit(
            CheckInFailed(
              session: session,
              reason: _mapToReason(response.message),
            ),
          );
        }
      }
    } catch (e, stack) {
      print('CheckIn error: $e');
      print('Stack: $stack');
      if (!isClosed) {
        emit(
          CheckInFailed(
            session: session,
            reason: CheckInFailureReason.networkError,
          ),
        );
      }
    }
  }

  void reset() => emit(const CheckInIdle());

  CheckInFailureReason _mapToReason(String? message) {
    final msg = message?.toLowerCase() ?? '';
    if (msg.contains('already')) return CheckInFailureReason.alreadyCheckedIn;
    if (msg.contains('zone') || msg.contains('outside')) {
      return CheckInFailureReason.outsideZone;
    }
    if (msg.contains('network')) return CheckInFailureReason.networkError;
    return CheckInFailureReason.unknown;
  }
}
