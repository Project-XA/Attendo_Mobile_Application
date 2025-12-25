import 'package:flutter/material.dart';
import 'package:mobile_app/attendency_app.dart';
import 'package:mobile_app/core/DI/get_it.dart';
import 'package:mobile_app/core/routing/app_route.dart';
import 'package:mobile_app/core/routing/routes.dart';
import 'package:mobile_app/core/services/onboarding_service.dart';

class AppBootstrap extends StatefulWidget {
  const AppBootstrap({super.key});

  @override
  State<AppBootstrap> createState() => _AppBootstrapState();
}

class _AppBootstrapState extends State<AppBootstrap> {
  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await initCore();

    final onboardingService = getIt<OnboardingService>();
    final hasCompleted = await onboardingService.hasCompletedOnboarding();
    
    String initialRoute;
    String? routeArgument;
    
    if (hasCompleted) {
      final userRole = await onboardingService.getUserRole();
      initialRoute = Routes.mainNavigation;
      routeArgument = userRole ?? 'User';
    } else {
      initialRoute = Routes.startPage;
    }

    runApp(
      AttendencyApp(
        appRouter: AppRoute(),
        initialRoute: initialRoute,
        initialRouteArguments: routeArgument,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }
}
