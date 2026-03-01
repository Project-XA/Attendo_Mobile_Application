import 'package:mobile_app/core/current_user/data/local_data_soruce/user_local_data_source.dart';
import 'package:mobile_app/core/services/auth/auth_state_service.dart';
import 'package:mobile_app/core/services/auth/dio_token_service.dart';
import 'package:mobile_app/core/services/auth/onboarding_service/i_ocr_service.dart';
import 'package:mobile_app/core/services/auth/onboarding_service/i_registeration_service.dart';
import 'package:mobile_app/core/services/auth/onboarding_service/i_session_service.dart';

/*
this service is responsible for managing the onboarding process, including tracking the user's progress through OCR, verification, and registration steps.
It also handles login/logout state and token management.
By centralizing this logic in a single service, we can easily manage the user's onboarding and authentication
 */
class OnboardingService
    implements IOcrService, IRegistrationService, ISessionService {
  final AuthStateService _authStateService;
  final UserLocalDataSource _userLocalDataSource;
  final ITokenService _tokenService;
  OnboardingService(
    this._authStateService,
    this._userLocalDataSource,
    this._tokenService,
  );

  @override
  Future<bool> hasCompletedOCR() async {
    return await _authStateService.hasCompletedOCR();
  }

  @override
  Future<void> markOCRComplete() async {
    await _authStateService.markOCRComplete();
  }

  @override
  Future<bool> hasCompletedOnboarding() async {
    return await _authStateService.hasRegistered();
  }

  @override
  Future<void> markOnboardingComplete(String userRole) async {
    await _authStateService.markRegistrationComplete(userRole);
  }

  @override
  Future<bool> hasCompletedVerification() async {
    return await _authStateService.hasCompletedVerification();
  }

  @override
  Future<void> markVerificationComplete() async {
    await _authStateService.markVerificationComplete();
  }

  @override
  Future<bool> isLoggedIn() async {
    final authStateLoggedIn = await _authStateService.isLoggedIn();

    if (!authStateLoggedIn) return false;

    try {
      final hasToken = await _userLocalDataSource.hasValidToken();
      return hasToken;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> logout() async {
    await _tokenService.clearTokens();
    await _userLocalDataSource.logout();
    await _authStateService.clearAuthState();
  }

  @override
  Future<void> markLoggedIn(String userRole) async {
    await _authStateService.markLoggedIn(userRole);
  }

  @override
  Future<String?> getUserRole() async {
    return await _authStateService.getUserRole();
  }

  @override
  Future<void> clearOnboardingState() async {
    await _authStateService.clearAll();
  }
}
