import 'package:mobile_app/core/DI/get_it.dart';
import 'package:mobile_app/feature/navigation_screen/presentation/logic/navigation_cubit.dart';

void initNavigation() {
  if (getIt.isRegistered<NavigationCubit>()) return;

  getIt.registerFactory(
    () => NavigationCubit(
      localDataSource: getIt(),
    ),
  );
}