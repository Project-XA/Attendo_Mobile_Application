import 'package:mobile_app/core/DI/get_it.dart';
import 'package:mobile_app/features/auth/forget_password/data/remote_data_source/auth_remote_data_source.dart';
import 'package:mobile_app/features/auth/forget_password/data/repo_imp/forgot_password_repo_imp.dart';
import 'package:mobile_app/features/auth/forget_password/domain/repos/forgot_password_repo.dart';
import 'package:mobile_app/features/auth/forget_password/domain/use_cases/forgot_password_use_case.dart';
import 'package:mobile_app/features/auth/forget_password/presentation/logic/forgot_password_cubit.dart';

void initForgotPassword() {
  if (getIt.isRegistered<ForgotPasswordRepo>()) return;

  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImp(getIt()),
  );

  getIt.registerLazySingleton<ForgotPasswordRepo>(
    () => ForgotPasswordRepoImp(remote: getIt()),
  );

  getIt.registerLazySingleton(() => ForgotPasswordUseCase(getIt()));

  getIt.registerFactory(() => ForgotPasswordCubit(getIt()));
}

