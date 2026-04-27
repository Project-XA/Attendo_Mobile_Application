import 'package:mobile_app/core/routing/routes.dart';
import 'package:mobile_app/core/services/auth/onboarding_service.dart';

class InitialRouteResolver {
  const InitialRouteResolver._();

  static Future<(String route, String? argument)> resolve(
    OnboardingService onboardingService,
  ) async {
    final hasCompletedOCR = await onboardingService.hasCompletedOCR();
    if (!hasCompletedOCR) return (Routes.startPage, null);

    final hasCompletedVerification = await onboardingService.hasCompletedVerification();
    if (!hasCompletedVerification) return (Routes.verficationScreen, null);

    final hasRegistered = await onboardingService.hasCompletedOnboarding();
    if (!hasRegistered) return (Routes.registerScreen, null);

    final isLoggedIn = await onboardingService.isLoggedIn();
    if (!isLoggedIn) return (Routes.registerScreen, null);

    final userRole = await onboardingService.getUserRole();
    if (userRole?.toLowerCase() == 'student') return (Routes.studentNavigation, null);

    return (Routes.mainNavigation, userRole ?? 'User');
  }
}