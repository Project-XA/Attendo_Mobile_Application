import 'package:mobile_app/core/dependency_injection/get_it.dart';
import 'package:mobile_app/core/utils/register_lazy_if_not_registered.dart';
import 'package:mobile_app/features/student_auth/data/data_source/student_auth_remote_data_source.dart';
import 'package:mobile_app/features/student_auth/data/repo_impl.dart/auth_student_repo_impl.dart';
import 'package:mobile_app/features/student_auth/domain/repo/auth_student_repo.dart';
import 'package:mobile_app/features/student_auth/domain/use_case/student_login_use_case.dart';
import 'package:mobile_app/features/student_auth/domain/use_case/student_register_use_case.dart';
import 'package:mobile_app/features/student_auth/presentation/logic/student_auth_cubit.dart';

void initAuthStudent() {
  if (getIt.isRegistered<AuthStudentCubit>()) return;
  registerLazyIfNotRegistered<StudentAuthRemoteDataSource>(
    () => StudentAuthRemoteDataSourceImpl(networkService: getIt()),
  );

  registerLazyIfNotRegistered<AuthStudentRepo>(
    () => AuthStudentRepoImpl(remoteDataSource: getIt()),
  );

  registerLazyIfNotRegistered<StudentLoginUseCase>(
    () => StudentLoginUseCase(authRepo: getIt()),
  );
  registerLazyIfNotRegistered<StudentRegisterUseCase>(
    () => StudentRegisterUseCase(getIt()),
  );
  getIt.registerFactory<AuthStudentCubit>(
    () => AuthStudentCubit(
      studentLoginUseCase: getIt(),
      studentRegisterUseCase: getIt(),
    ),
  );
}
