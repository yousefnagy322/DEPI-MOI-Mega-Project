import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:migaproject/Data/report_model.dart';
import 'package:migaproject/Logic/user_reports_list/state.dart';
import 'package:migaproject/core/api_paths.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyReportsCubit extends Cubit<MyReportsState> {
  MyReportsCubit() : super(MyReportsInitialState());

  Future<void> fetchMyReports() async {
    emit(MyReportsLoadingState());

    Dio dio = Dio();

    final prefs = await SharedPreferences.getInstance();

    final userId = prefs.getString('userId');

    try {
      final response = await dio.get(
        '${ApiPaths.listUserReports}$userId',
        options: Options(
          headers: {
            'authorization': 'Bearer ${prefs.getString('accessToken')}',
            'accept': 'application/json',
          },
        ),
      );

      print(response.data);

      final data = ReportsResponse.fromJson(response.data);

      print(data);

      if (response.statusCode == 200) {
        emit(MyReportsSuccessState(data.reports));
      } else {
        emit(MyReportsErrorState(error: 'Failed to load reports'));
      }
    } catch (e) {
      emit(MyReportsErrorState(error: e.toString()));
    }
  }
}
