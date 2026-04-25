import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/features/privacy_and_security/domain/use_cases/change_password_use_case.dart';
import 'package:mobile_app/features/privacy_and_security/presentation/logic/privacy_and_secuirty_state.dart';


class PrivacySecurityCubit extends Cubit<PrivacySecurityState> {
  PrivacySecurityCubit({
  
    required this.changePasswordUseCase,
  }) : super(const PrivacySecurityState());

 
  final ChangePasswordUseCase changePasswordUseCase;

  void openSection(PrivacyAction action) {
    emit(
      state.copyWith(activeAction: action, clearError: true, isSuccess: false),
    );
  }

  void closeSection() {
    emit(
      state.copyWith(
        activeAction: PrivacyAction.none,
        clearError: true,
        isSuccess: false,
      ),
    );
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    emit(
      state.copyWith(
        isLoading: true,
        activeAction: PrivacyAction.changePassword,
      ),
    );
    final result = await changePasswordUseCase(currentPassword, newPassword);
    if (isClosed) return;
    result.when(
      onSuccess: (_) {
        emit(state.copyWith(isLoading: false, isSuccess: true));
      },
      onError: (e) =>
          emit(state.copyWith(isLoading: false, errorMessage: e.message)),
    );
  }
}
