import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/features/attendance/domain/entities/nearby_session.dart';
import 'package:mobile_app/features/attendance/domain/use_cases/check_in_use_case.dart';
import 'package:mobile_app/features/attendance/presentation/logic/check_in/check_in_state.dart';

class CheckInCubit extends Cubit<CheckInState> {
  final CheckInUseCase _checkInUseCase;

  CheckInCubit({required CheckInUseCase checkInUseCase})
    : _checkInUseCase = checkInUseCase,
      super(const CheckInIdle());

  Future<void> checkIn(
    NearbySession session, {
    required String userId,
    required String userName,
  }) async {
    if (!isClosed) emit(CheckInLoading(session: session));

    try {
      final response = await _checkInUseCase.call(
        sessionId: session.sessionId,
        baseUrl: session.baseUrl,
        userId: userId,
        userName: userName,
        location: session.location,
      );

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
    } catch (_) {
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
