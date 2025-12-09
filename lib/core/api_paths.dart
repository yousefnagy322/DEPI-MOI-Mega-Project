class ApiPaths {
  static const String baseUrl =
      'https://moi-reporting-app-f2hwfsdaddexgcak.germanywestcentral-01.azurewebsites.net';

  static const String listallReports = '$baseUrl/api/v1/reports/';

  static const String listUserReports = '$baseUrl/api/v1/reports/user/';

  static const String createReport = '$baseUrl/api/v1/reports/';

  static const String login = '$baseUrl/api/v1/auth/login';

  static const String signup = '$baseUrl/api/v1/auth/register';

  static const String listUsers = '$baseUrl/api/v1/users/list';

  static const String getHotReportsMatrix =
      '$baseUrl/api/v1/admin/dashboard/hot/categorycount';
}
