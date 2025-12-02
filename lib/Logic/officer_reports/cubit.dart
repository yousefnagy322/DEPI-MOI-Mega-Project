import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:migaproject/Data/report_model.dart';
import 'package:migaproject/Logic/officer_reports/state.dart';
import 'package:migaproject/core/api_paths.dart';

class OfficerReportsCubit extends Cubit<OfficerReportsState> {
  OfficerReportsCubit() : super(OfficerReportsInitialState());

  Future<void> fetchOfficerReports() async {
    emit(OfficerReportsLoadingState());

    Dio dio = Dio();

    try {
      final response = await dio.get(
        ApiPaths.listallReports,
        options: Options(headers: {'accept': 'application/json'}),
      );

      print(response.data);

      final data = ReportsResponse.fromJson(response.data);

      print(data);

      if (response.statusCode == 200) {
        emit(OfficerReportsSuccessState(data.reports));
      } else {
        emit(OfficerReportsErrorState(error: 'Failed to load reports'));
      }
    } catch (e) {
      emit(OfficerReportsErrorState(error: e.toString()));
    }
  }
}
