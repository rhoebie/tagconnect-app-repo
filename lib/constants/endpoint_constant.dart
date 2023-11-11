class ApiConstants {
  // BaseUrl
  static String baseUrl = 'https://taguigconnect.online';

  // Account
  static String registerUser = '/register-user';
  static String verifyCode = '/verify-otp';
  static String loginUser = '/login-user';
  static String logoutUser = '/logout-user';
  static String requestCode = '/request-otp';
  static String resetPassword = '/reset-password';
  static String changePassword = '/change-password';

  // Data of the user
  static String countReportEndpoint = '/user-reports';
  static String userEndpoint = '/users';
  static String hotlineEndpoint = '/hotlines';
  static String incidentEndpoint = '/incidents';
  static String barangayEndpoint = '/barangays';
  static String reportEndpoint = '/reports';

  // Api Url for request
  static String apiUrl = '$baseUrl/api';
}
