import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:migaproject/Data/count_model.dart';
import 'package:migaproject/Data/report_model.dart';
import 'package:migaproject/Data/user_model.dart';
import 'package:migaproject/Logic/officer_reports_list/state.dart';
import 'package:migaproject/core/api_paths.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OfficerReportsCubit extends Cubit<OfficerReportsState> {
  OfficerReportsCubit() : super(OfficerReportsInitialState());

  Future<void> fetchOfficerdata() async {
    emit(OfficerReportsLoadingState());

    Dio dio = Dio();
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');

    try {
      List<Report> allReports = [];

      final reportresponse = await dio.get(
        '${ApiPaths.listallReports}',

        options: Options(
          headers: {
            'authorization': 'Bearer $token',
            'accept': 'application/json',
          },
        ),
      );

      print(reportresponse.data);
      final reportdata = ReportsResponse.fromJson(reportresponse.data);

      allReports.addAll(reportdata.reports);

      final countresponse = await dio.get(
        '${ApiPaths.baseUrl}/api/v1/admin/dashboard/hot/statuscount',
        options: Options(
          headers: {
            'authorization': 'Bearer $token',
            'accept': 'application/json',
          },
        ),
      );

      final countdata = ReportCountsResponse.fromJson(countresponse.data);

      final userCountresponse = await dio.get(
        ApiPaths.listUsers,
        options: Options(
          headers: {
            'authorization': 'Bearer $token',
            'accept': 'application/json',
          },
        ),
      );

      // Parse the response correctly
      final List<dynamic> jsonList = userCountresponse.data;

      final List<UserModel> users = jsonList
          .map((item) => UserModel.fromJson(item))
          .toList();

      final usercount = users.length;

      emit(
        OfficerReportsSuccessState(
          reports: allReports,
          counts: countdata.counts,
          usercount: usercount,
        ),
      );
    } catch (e) {
      emit(OfficerReportsErrorState(error: e.toString()));
    }
  }
}
