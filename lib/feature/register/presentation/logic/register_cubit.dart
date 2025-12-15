import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/feature/home/data/models/user_model.dart';
import 'package:mobile_app/feature/register/domain/use_cases/register_use_case.dart';
import 'package:mobile_app/feature/register/presentation/logic/register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final RegisterUseCase registerUseCase;
  
  RegisterCubit(this.registerUseCase) : super(RegisterInitialState());
  
  Future<void> register({
    required String orgId,
    required String email,
    required String password,
    required UserModel localUserData,
  }) async {
    print('🔵 [RegisterCubit] register() called');
    print('📧 Email: $email');
    print('🏢 OrgId: $orgId');
    print('👤 LocalUserData: ${localUserData.toJson()}');
    
    emit(RegisterLoadingState());
    print('⏳ [RegisterCubit] Emitted RegisterLoadingState');
    
    final result = await registerUseCase(
      orgId: orgId,
      email: email,
      password: password,
      localUserData: localUserData,
    );
    
    print('📦 [RegisterCubit] Result received from useCase');
    
    result.when(
      onSuccess: (user) {
        print('✅ [RegisterCubit] Registration SUCCESS');
        print('👤 User: ${user.toJson()}');
        emit(RegisterLoadedState(user: user));
        print('🎉 [RegisterCubit] Emitted RegisterLoadedState');
      },
      onError: (error) {
        print('❌ [RegisterCubit] Registration FAILED');
        print('⚠️ Error: ${error.toString()}');
        emit(RegisterFailureState(message: error.toString()));
        print('💥 [RegisterCubit] Emitted RegisterFailureState');
      },
    );
  }
}