import 'package:mobile_app/core/services/auth/onboarding_service.dart';
import 'package:mobile_app/core/services/auth/secure_storage_service.dart';

class AuthSessionHelper {
  AuthSessionHelper._();

  static Future<void> persistSession({
    required String token,
    required String role,
    required OnboardingService onboardingService,
  }) async {
    await SecureStorageService.saveToken(token);
    await onboardingService.markOnboardingComplete(role);
    await onboardingService.markVerificationComplete();
    await onboardingService.markLoggedIn(role);
  }
}
