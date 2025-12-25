import 'package:shared_preferences/shared_preferences.dart';

class OnboardingService {
  final SharedPreferences _prefs;

  static const String _keyHasCompletedOnboarding = 'has_completed_onboarding';
  static const String _keyUserRole = 'user_role';

  OnboardingService(this._prefs);

  Future<bool> hasCompletedOnboarding() async {
    return _prefs.getBool(_keyHasCompletedOnboarding) ?? false;
  }


  /// [userRole] should be 'Admin' or 'User'
  Future<void> markOnboardingComplete(String userRole) async {
    await _prefs.setBool(_keyHasCompletedOnboarding, true);
    await _prefs.setString(_keyUserRole, userRole);
  }


  Future<String?> getUserRole() async {
    return _prefs.getString(_keyUserRole);
  }

  Future<void> clearOnboardingState() async {
    await _prefs.remove(_keyHasCompletedOnboarding);
    await _prefs.remove(_keyUserRole);
  }
}
