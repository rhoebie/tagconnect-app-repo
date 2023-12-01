class ApiConstants {
  // BaseUrl
  static String baseUrl = 'http://10.0.2.2:8000';

  // Account
  static String registerUser = '/register-user';
  static String verifyCode = '/verify-otp';
  static String loginUser = '/login-user';
  static String logoutUser = '/logout-user';
  static String requestCode = '/request-otp';
  static String resetPassword = '/reset-password';
  static String changePassword = '/change-password';

  // Data of the user
  static String countReportEndpoint = '/get-user-reports';
  static String feedReports = '/get-feed-reports';
  static String userEndpoint = '/users';
  static String barangayEndpoint = '/get-barangay';
  static String reportEndpoint = '/reports';

  // News
  static String newsEndpoint = '/get-news';

  // Api Url for request
  static String apiUrl = '$baseUrl/api';
}
