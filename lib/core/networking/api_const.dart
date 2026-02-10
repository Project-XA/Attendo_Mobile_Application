class ApiConst {
  static const String baseurl =
      'https://backend-production-9a44e.up.railway.app/api/';
  static const String register = 'user/get-user';
  static const String forgotPassword = 'Account/Forgot-Password';
  static const String verifyResetPasswordOtp = 'Account/verify-reset-password-otp';
  static const String createSession = 'Session/Create-Session';
  static const String refreshToken = "null";
  static const String userStatistics = "user/statistics";
  static const String saveAttendance = "Session/save-attend";
  static String getAllHalls(int organizationId) =>
      '/hall/get-all-halls/$organizationId';
}
