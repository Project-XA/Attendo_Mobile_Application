import 'package:mobile_app/core/DI/get_it.dart';
import 'package:mobile_app/core/utils/register_lazy_if_not_registered.dart';
import 'package:mobile_app/features/session_mangement/data/repo_imp/session_repository_impl.dart';
import 'package:mobile_app/features/session_mangement/data/service/http_server_service.dart';
import 'package:mobile_app/features/session_mangement/domain/repos/session_repository.dart';
import 'package:mobile_app/features/session_mangement/domain/use_cases/create_session_use_case.dart';
import 'package:mobile_app/features/session_mangement/domain/use_cases/end_session_use_case.dart';
import 'package:mobile_app/features/session_mangement/domain/use_cases/listen_attendence_use_case.dart';
import 'package:mobile_app/features/session_mangement/domain/use_cases/start_session_server_use_case.dart';
import 'package:mobile_app/features/session_mangement/presentation/logic/session_management_cubit.dart';



void initSessionManagement() {
  if (getIt.isRegistered<SessionMangementCubit>()) return;

  registerLazyIfNotRegistered<HttpServerService>(() => HttpServerService());

  registerLazyIfNotRegistered<SessionRepository>(
    () => SessionRepositoryImpl(serverService: getIt<HttpServerService>()),
  );

  

  registerLazyIfNotRegistered<CreateSessionUseCase>(
    () => CreateSessionUseCase(getIt<SessionRepository>()),
  );

  registerLazyIfNotRegistered<StartSessionServerUseCase>(
    () => StartSessionServerUseCase(getIt<SessionRepository>()),
  );

  registerLazyIfNotRegistered<EndSessionUseCase>(
    () => EndSessionUseCase(getIt<SessionRepository>()),
  );

  registerLazyIfNotRegistered<ListenAttendanceUseCase>(
    () => ListenAttendanceUseCase(getIt<SessionRepository>()),
  );

  getIt.registerFactory<SessionMangementCubit>(
    () => SessionMangementCubit(
      createSessionUseCase: getIt(),
      startSessionServerUseCase: getIt(),
      endSessionUseCase: getIt(),
      listenAttendanceUseCase: getIt(),
    ),
  );
}
