import 'package:mobile_app/core/DI/get_it.dart';
import 'package:mobile_app/core/current_user/data/local_data_soruce/user_local_data_source.dart';
import 'package:mobile_app/core/current_user/data/remote_data_source/user_remote_data_source.dart';
import 'package:mobile_app/core/utils/register_lazy_if_not_registered.dart';
import 'package:mobile_app/features/session_mangement/data/repo_imp/session_repository_impl.dart';
import 'package:mobile_app/features/session_mangement/data/service/http_server_service.dart';
import 'package:mobile_app/features/session_mangement/data/service/network_info_service.dart';
import 'package:mobile_app/features/session_mangement/domain/repos/session_repository.dart';
import 'package:mobile_app/features/session_mangement/domain/use_cases/create_session_use_case.dart';
import 'package:mobile_app/features/session_mangement/domain/use_cases/end_session_use_case.dart';
import 'package:mobile_app/features/session_mangement/domain/use_cases/listen_attendence_use_case.dart';
import 'package:mobile_app/features/session_mangement/domain/use_cases/start_session_server_use_case.dart';
import 'package:mobile_app/features/session_mangement/presentation/logic/session_management_cubit.dart';



void initSessionManagement() {
  if (getIt.isRegistered<SessionMangementCubit>()) return;

  /// Services
  registerLazyIfNotRegistered<HttpServerService>(
    () => HttpServerService(),
  );
registerLazyIfNotRegistered<NetworkInfoService>(
    () => NetworkInfoService(),
  );

  /// Repository
  registerLazyIfNotRegistered<SessionRepository>(
    () => SessionRepositoryImpl(
      serverService: getIt<HttpServerService>(),
      remoteDataSource: getIt<UserRemoteDataSource>(),
      localDataSource: getIt<UserLocalDataSource>(),
    ),
  );

  /// Use Cases
  registerLazyIfNotRegistered<CreateSessionUseCase>(
    () => CreateSessionUseCase(getIt(),getIt()) ,
  );

  registerLazyIfNotRegistered<StartSessionServerUseCase>(
    () => StartSessionServerUseCase(getIt()),
  );

  registerLazyIfNotRegistered<EndSessionUseCase>(
    () => EndSessionUseCase(getIt()),
  );

  registerLazyIfNotRegistered<ListenAttendanceUseCase>(
    () => ListenAttendanceUseCase(getIt()),
  );

  /// Cubit
  getIt.registerFactory<SessionMangementCubit>(
    () => SessionMangementCubit(
      createSessionUseCase: getIt(),
      startSessionServerUseCase: getIt(),
      endSessionUseCase: getIt(),
      listenAttendanceUseCase: getIt(),
    ),
  );
}
