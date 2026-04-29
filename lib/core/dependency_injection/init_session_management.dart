import 'package:mobile_app/core/dependency_injection/get_it.dart';
import 'package:mobile_app/core/networking/network_service.dart';
import 'package:mobile_app/core/utils/register_lazy_if_not_registered.dart';
import 'package:mobile_app/features/session_mangement/data/data_source/local_session_data_source.dart';
import 'package:mobile_app/features/session_mangement/data/data_source/remote_session_data_source.dart';
import 'package:mobile_app/features/session_mangement/data/data_source/session_state_manager.dart';
import 'package:mobile_app/features/session_mangement/data/helpers/session_cache_helper.dart';
import 'package:mobile_app/features/session_mangement/data/repo_imp/session_repository_impl.dart';
import 'package:mobile_app/features/session_mangement/data/service/http_server_service.dart';
import 'package:mobile_app/features/session_mangement/data/service/network_info_service.dart';
import 'package:mobile_app/features/session_mangement/domain/repos/session_repository.dart';
import 'package:mobile_app/features/session_mangement/domain/use_cases/create_session_use_case.dart';
import 'package:mobile_app/features/session_mangement/domain/use_cases/delete_current_session_use_case.dart';
import 'package:mobile_app/features/session_mangement/domain/use_cases/end_session_use_case.dart';
import 'package:mobile_app/features/session_mangement/domain/use_cases/get_all_halls_use_case.dart';
import 'package:mobile_app/features/session_mangement/domain/use_cases/get_all_sections.dart';
import 'package:mobile_app/features/session_mangement/domain/use_cases/listen_attendence_use_case.dart';
import 'package:mobile_app/features/session_mangement/domain/use_cases/start_session_server_use_case.dart';
import 'package:mobile_app/features/session_mangement/presentation/logic/session_management_cubit.dart';

void initSessionManagement() {
  if (getIt.isRegistered<SessionManagementCubit>()) return;

  // Services
  registerLazyIfNotRegistered<HttpServerService>(() => HttpServerService());
  registerLazyIfNotRegistered<NetworkInfoService>(() => NetworkInfoService());

  registerLazyIfNotRegistered<RemoteSessionDataSource>(
    () => RemoteSessionDataSourceImpl(networkService: getIt<NetworkService>()),
  );

  registerLazyIfNotRegistered<LocalSessionDataSource>(
    () => LocalSessionDataSourceImpl(),
  );
  getIt.registerLazySingleton(
    () => SessionCacheHelper(local: getIt(), remote: getIt()),
  );

  getIt.registerLazySingleton(() => SessionStateManager());
  // Cubit

  registerLazyIfNotRegistered<SessionRepository>(
    () => SessionRepositoryImpl(
      serverService: getIt(),
      localDataSource: getIt(),
      cacheHelper: getIt(),
      stateManager: getIt(),
      remoteSessionDataSource: getIt(),
    ),
  );

  // Use Cases
  registerLazyIfNotRegistered<CreateSessionUseCase>(
    () => CreateSessionUseCase(getIt(), getIt()),
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

  registerLazyIfNotRegistered<GetAllHallsUseCase>(
    () => GetAllHallsUseCase(getIt()),
  );

  registerLazyIfNotRegistered<DeleteCurrentSessionUseCase>(
    () => DeleteCurrentSessionUseCase(getIt()),
  );
  registerLazyIfNotRegistered<GetAllSectionsUseCase>(
    () => GetAllSectionsUseCase(getIt()),
  );

  getIt.registerFactory<SessionManagementCubit>(
    () => SessionManagementCubit(
      createSessionUseCase: getIt(),
      startSessionServerUseCase: getIt(),
      endSessionUseCase: getIt(),
      listenAttendanceUseCase: getIt(),
      getAllHallsUseCase: getIt(),
      deleteCurrentSessionUseCase: getIt(),
      getAllSectionsUseCase: getIt(),
    ),
  );
}
