import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:migaproject/Data/analyricline_model.dart';
import 'package:migaproject/Logic/analytic_line_chart/state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AnalyticsLineCubit extends Cubit<AnalyticsLineState> {
  AnalyticsLineCubit() : super(AnalyticsLineInitial());

  final Dio _dio = Dio(); // or inject it

  Future<void> fetchLineAnalytics() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');

    emit(AnalyticsLineLoading());
    try {
      final response = await _dio.get(
        'https://moi-reporting-app-f2hwfsdaddexgcak.germanywestcentral-01.azurewebsites.net/api/v1/admin/dashboard/hot/monthly-category-breakdown', // replace with your URL
        options: Options(
          headers: {
            "accept": "application/json",
            "Authorization": "Bearer $token",
          },
        ),
      );

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        List<AnalyticsItem> items = data
            .map((json) => AnalyticsItem.fromJson(json))
            .toList();

        emit(AnalyticsLineLoaded(items: items));
      } else {
        emit(AnalyticsLineError(message: 'Failed to load analytics'));
      }
    } catch (e) {
      emit(AnalyticsLineError(message: e.toString()));
    }
  }

  /// Utility: Get items grouped by category for line chart
  Map<String, List<AnalyticsItem>> getItemsGroupedByCategory(
    List<AnalyticsItem> items,
  ) {
    Map<String, List<AnalyticsItem>> grouped = {};
    for (var item in items) {
      if (!grouped.containsKey(item.category)) {
        grouped[item.category] = [];
      }
      grouped[item.category]!.add(item);
    }
    return grouped;
  }
}
