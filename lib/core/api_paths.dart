class ApiPaths {
  static const String baseUrl =
      'https://moi-bxe3dvd5hnayazbs.uaenorth-01.azurewebsites.net';

  static const String listallReports = '$baseUrl/api/v1/reports/';

  static const String listUserReports = '$baseUrl/api/v1/reports/user/';

  static const String createReport = '$baseUrl/api/v1/reports/';

  static const String login = '$baseUrl/api/v1/auth/login';

  static const String signup = '$baseUrl/api/v1/auth/register';
}
