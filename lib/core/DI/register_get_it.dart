import 'package:mobile_app/core/DI/get_it.dart';
import 'package:mobile_app/feature/auth/data/repo_imp/register_repo_imp.dart';
import 'package:mobile_app/feature/auth/domain/repos/register_repo.dart';
import 'package:mobile_app/feature/auth/domain/use_cases/register_use_case.dart';
import 'package:mobile_app/feature/auth/presentation/logic/register_cubit.dart';

void initRegister() {
  if (getIt.isRegistered<RegisterRepo>()) return;

  getIt.registerLazySingleton<RegisterRepo>(
    () => RegisterRepoImp(
      userRemoteDataSource: getIt(),
      localDataSource: getIt(),
      onboardingService: getIt(),
    ),
  );

  getIt.registerLazySingleton(() => RegisterUseCase(getIt()));

  getIt.registerFactory(() => RegisterCubit(getIt()));
}
