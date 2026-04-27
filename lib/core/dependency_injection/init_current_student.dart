import 'package:mobile_app/core/current_student/data/repo_impl/current_student_repo_imp.dart';
import 'package:mobile_app/core/dependency_injection/get_it.dart';
import 'package:mobile_app/core/current_student/domain/repo/current_student_repo.dart';
import 'package:mobile_app/core/current_student/domain/use_case/get_current_student_use_case.dart';
import 'package:mobile_app/core/current_student/domain/use_case/update_profile_image_use_case.dart';
import 'package:mobile_app/core/current_student/presentation/current_student_cubit.dart';
import 'package:mobile_app/core/utils/register_lazy_if_not_registered.dart';

void initCurrentStudentDi() {
  // Repository
  registerLazyIfNotRegistered<CurrentStudentRepository>(
    () => CurrentStudentRepositoryImpl(localDataSource: getIt()),
  );

  // Use Cases
  registerLazyIfNotRegistered<GetCurrentStudentUseCase>(
    () => GetCurrentStudentUseCase(getIt()),
  );
  registerLazyIfNotRegistered<UpdateStudentProfileImageUseCase>(
    () => UpdateStudentProfileImageUseCase(getIt()),
  );

  // Cubit
  registerLazyIfNotRegistered<CurrentStudentCubit>(
    () => CurrentStudentCubit(
      getCurrentStudentUseCase: getIt(),
      updateProfileImageUseCase: getIt(),
    ),
  );
}
