import 'package:mobile_app/core/dependency_injection/get_it.dart';
import 'package:mobile_app/core/utils/register_lazy_if_not_registered.dart';
import 'package:mobile_app/features/attendance/domain/use_cases/get_attendence_history_use_case.dart';
import 'package:mobile_app/features/user_analysis/presentation/logic/user_analysis_cubit.dart';

void initUserAnalysis() {
  if (getIt.isRegistered<UserAnalysisCubit>()) return;
  registerLazyIfNotRegistered<GetAttendanceHistoryUseCase>(
    () => GetAttendanceHistoryUseCase(getIt()),
  );

  getIt.registerFactory<UserAnalysisCubit>(
    () => UserAnalysisCubit(
      getAttendanceStatsUseCase: getIt(),
      getAttendanceHistoryUseCase: getIt(),
    ),
  );
}
