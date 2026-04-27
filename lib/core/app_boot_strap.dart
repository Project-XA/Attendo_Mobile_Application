import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:mobile_app/attendency_app.dart';
import 'package:mobile_app/core/dependency_injection/get_it.dart';
import 'package:mobile_app/core/helpers/inital_route_resolver.dart';
import 'package:mobile_app/core/routing/app_route.dart';
import 'package:mobile_app/core/services/auth/onboarding_service.dart';
import 'package:mobile_app/core/themes/theme_cubit.dart';
import 'package:mobile_app/features/splash/animated_splash_screen.dart';

class AppBootstrap extends StatefulWidget {
  const AppBootstrap({super.key, required this.themeBox});
  final Box<bool> themeBox;
  @override
  State<AppBootstrap> createState() => _AppBootstrapState();
}

class _AppBootstrapState extends State<AppBootstrap> {
  bool _showAnimatedSplash = true;
  bool _isInitialized = false;
  String? _initialRoute;
  String? _routeArgument;
  late final ThemeCubit _themeCubit;
  @override
  void initState() {
    super.initState();
    _themeCubit = ThemeCubit(themeBox: widget.themeBox);
    _init();
  }

  Future<void> _init() async {
    await initCore();
    final onboardingService = getIt<OnboardingService>();
    final (route, argument) = await InitialRouteResolver.resolve(
      onboardingService,
    );

    setState(() {
      _initialRoute = route;
      _routeArgument = argument;
      _isInitialized = true;
    });
  }

  void _onAnimationComplete() {
    setState(() {
      _showAnimatedSplash = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ThemeCubit>.value(
      value: _themeCubit,
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          if (!_isInitialized || _showAnimatedSplash) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              theme: ThemeData.light(),
              darkTheme: ThemeData.dark(),
              themeMode: themeMode,
              home: AnimatedSplashScreen(
                onAnimationComplete: _onAnimationComplete,
              ),
            );
          }

          return AttendencyApp(
            appRouter: AppRoute(),
            initialRoute: _initialRoute!,
            initialRouteArguments: _routeArgument,
            themeMode: themeMode,
          );
        },
      ),
    );
  }
}
