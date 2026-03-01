
abstract class ISessionService {
  Future<bool> isLoggedIn();
  Future<void> logout();
  Future<void> markLoggedIn(String userRole);
  Future<String?> getUserRole();
}