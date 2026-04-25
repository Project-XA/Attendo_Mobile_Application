import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/routing/app_route.dart';
import 'package:mobile_app/core/themes/app_theme.dart';

class AttendencyApp extends StatelessWidget {
  const AttendencyApp({
    super.key,
    required this.appRouter,
    required this.initialRoute,
    this.initialRouteArguments, required this.themeMode,
  });
  final AppRoute appRouter;
  final String initialRoute;
  final Object? initialRouteArguments;
    final ThemeMode themeMode;
   @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeMode,
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
