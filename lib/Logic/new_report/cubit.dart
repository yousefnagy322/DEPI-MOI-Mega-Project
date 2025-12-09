import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:migaproject/Data/report_model.dart';
import 'package:migaproject/Logic/new_report/state.dart';
import 'package:migaproject/core/api_paths.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewReportCubit extends Cubit<NewReportState> {
  NewReportCubit() : super(NewReportInitialState());

  Future<void> createNewReport(Report sentreport) async {
    emit(NewReportLoadingState());

    Dio dio = Dio();

    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');

    try {
      final formData = await sentreport.toFormData();

      final response = await dio.post(
        ApiPaths.createReport,
        data: formData,
        options: Options(
          headers: {
            'authorization': 'Bearer ${accessToken}',
            'accept': 'application/json',
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      print(response.data);

      if (response.statusCode == 201) {
        String reportId = response.data['reportId'] ?? '';
        emit(NewReportSuccessState(id: reportId));
      } else {
        emit(NewReportErrorState(error: 'Failed to create report'));
      }
    } catch (e) {
      emit(NewReportErrorState(error: e.toString()));
    }
  }
}
