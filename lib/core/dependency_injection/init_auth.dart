import 'package:mobile_app/core/dependency_injection/get_it.dart';
import 'package:mobile_app/core/current_user/data/local_data_soruce/user_local_data_source.dart';
import 'package:mobile_app/core/networking/network_service.dart';
import 'package:mobile_app/core/services/auth/onboarding_service.dart';
import 'package:mobile_app/core/utils/register_lazy_if_not_registered.dart';
import 'package:mobile_app/features/auth/data/data_source/auth_remote_data_source.dart';
import 'package:mobile_app/features/auth/data/repo_impl/auth_repo_impl.dart';
import 'package:mobile_app/features/auth/domain/repo/auth_repo.dart';
import 'package:mobile_app/features/auth/domain/use_cases/forgot_password_use_case.dart';
import 'package:mobile_app/features/auth/domain/use_cases/register_use_case.dart';
import 'package:mobile_app/features/auth/presentation/logic/auth_cubit.dart';

void initAuth() {
  if (getIt.isRegistered<AuthCubit>()) {
    return;
  }
  registerLazyIfNotRegistered<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(getIt<NetworkService>()),
  );

  registerLazyIfNotRegistered<AuthRepo>(
    () => AuthRepoImpl(
      authRemoteDataSource: getIt<AuthRemoteDataSource>(),
      localDataSource: getIt<UserLocalDataSource>(),
      onboardingService: getIt<OnboardingService>(),
    ),
  );
  registerLazyIfNotRegistered<ForgotPasswordUseCase>(
    () => ForgotPasswordUseCase(getIt()),
  );
  registerLazyIfNotRegistered<RegisterUseCase>(() => RegisterUseCase(getIt()));

  getIt.registerFactory<AuthCubit>(
    () => AuthCubit(
      registerUseCase: getIt<RegisterUseCase>(),
      forgotPasswordUseCase: getIt<ForgotPasswordUseCase>(),
    ),
  );
}
