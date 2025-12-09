import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:migaproject/Logic/officer_report_details/state.dart';
import 'package:migaproject/core/api_paths.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OfficerReportDetailsCubit extends Cubit<OfficerReportDetailsState> {
  OfficerReportDetailsCubit() : super(OfficerReportDetailsInitialState());

  Future reportStatusUpdate({
    required String reportid,
    required String status,
    required String notes,
  }) async {
    emit(OfficerReportDetailsLoadingState());

    Dio dio = Dio();

    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');

    try {
      final response = await dio.put(
        '${ApiPaths.baseUrl}/api/v1/reports/$reportid/status',
        data: {'status': status, 'notes': notes},
        options: Options(
          headers: {
            'authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
            'accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        emit(OfficerReportDetailsSuccessState());
      }
    } catch (e) {
      emit(OfficerReportDetailsErrorState(error: e.toString()));
    }
  }
}
