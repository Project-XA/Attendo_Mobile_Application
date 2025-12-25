import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/routing/app_route.dart';

class AttendencyApp extends StatelessWidget {
  const AttendencyApp({
    super.key,
    required this.appRouter,
    required this.initialRoute,
    this.initialRouteArguments,
  });
  final AppRoute appRouter;
  final String initialRoute;
  final Object? initialRouteArguments;
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: initialRoute,
        onGenerateRoute: (settings) {
          if (settings.name == initialRoute && initialRouteArguments != null) {
            return appRouter.generateRoute(
              RouteSettings(
                name: settings.name,
                arguments: initialRouteArguments,
              ),
            );
          }
          return appRouter.generateRoute(settings);
        },
      ),
    );
  }
}
