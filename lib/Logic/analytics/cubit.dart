import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:migaproject/Data/analytics_model.dart';
import 'package:migaproject/Logic/analytics/state.dart';
import 'package:migaproject/core/api_paths.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AnalyticsCubit extends Cubit<AnalyticsState> {
  AnalyticsCubit() : super(AnalyticsInitialState());

  Future<void> fetchAnalytics() async {
    emit(AnalyticsLoadingState());
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');
    Dio dio = Dio();
    try {
      final response = await dio.get(
        ApiPaths.getHotReportsMatrix,
        options: Options(
          headers: {
            "accept": "application/json",
            "Authorization": "Bearer $token",
          },
        ),
      );

      final data = AnalyticsResponse.fromJson(response.data);

      emit(AnalyticsSuccessState(data: data));
    } catch (e) {
      emit(AnalyticsErrorState(error: e.toString()));
    }
  }
}
