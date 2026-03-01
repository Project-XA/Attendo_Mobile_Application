abstract class IRegistrationService {
  Future<bool> hasCompletedOnboarding();
  Future<void> markOnboardingComplete(String userRole);
  Future<bool> hasCompletedVerification();
  Future<void> markVerificationComplete();
  Future<void> clearOnboardingState();
}