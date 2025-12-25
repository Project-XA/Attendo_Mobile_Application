import 'package:mobile_app/core/DI/get_it.dart';
import 'package:mobile_app/feature/home/presentation/admin/profile/data/repo_imp/profile_repo_imp.dart';
import 'package:mobile_app/feature/home/presentation/admin/profile/domain/repos/profile_repo.dart';
import 'package:mobile_app/feature/home/presentation/admin/profile/domain/usecases/get_current_user_use_case.dart';
import 'package:mobile_app/feature/home/presentation/admin/profile/domain/usecases/update_user_profile_image.dart';
import 'package:mobile_app/feature/home/presentation/admin/profile/domain/usecases/update_user_use_case.dart';
import 'package:mobile_app/feature/home/presentation/admin/profile/presentation/logic/user_profile_cubit.dart';

void initProfile() {
  if (getIt.isRegistered<ProfileRepo>()) return; 

  getIt.registerLazySingleton<ProfileRepo>(
    () => ProfileRepoImp(localDataSource: getIt()),
  );

  getIt.registerLazySingleton(() => GetCurrentUserUseCase(getIt()));
  getIt.registerLazySingleton(() => UpdateUserUseCase(getIt()));
  getIt.registerLazySingleton(() => UpdateUserProfileImage(getIt()));

  getIt.registerFactory(
    () => UserProfileCubit(
      getIt(),
      getIt(),
      getIt(),
    ),
  );
}