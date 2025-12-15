import 'package:mobile_app/core/DI/get_it.dart';
import 'package:mobile_app/feature/home/presentation/admin/home/data/repo_imp/admin_repo_imp.dart';
import 'package:mobile_app/feature/home/presentation/admin/home/domain/repos/admin_repo.dart';
import 'package:mobile_app/feature/home/presentation/admin/home/domain/use_cases/get_current_user_use_case.dart';
import 'package:mobile_app/feature/home/presentation/admin/home/presentation/logic/admin_cubit.dart';

void initAdminHome() {
  if (getIt.isRegistered<AdminCubit>()) return;
  
  if (!getIt.isRegistered<AdminRepository>()) {
    getIt.registerLazySingleton<AdminRepository>(
      () => AdminRepositoryImpl(localDataSource: getIt()),
    );
  }
  
  if (!getIt.isRegistered<GetCurrentUserUseCase>()) {
    getIt.registerLazySingleton<GetCurrentUserUseCase>(
      () => GetCurrentUserUseCase(getIt()),
    );
  }
  
  getIt.registerFactory<AdminCubit>(
    () => AdminCubit(getCurrentUserUseCase: getIt()),
  );
}