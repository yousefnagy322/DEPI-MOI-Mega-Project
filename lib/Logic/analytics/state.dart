import 'package:migaproject/Data/analytics_model.dart';

class AnalyticsState {}

class AnalyticsInitialState extends AnalyticsState {}

class AnalyticsLoadingState extends AnalyticsState {}

class AnalyticsSuccessState extends AnalyticsState {
  final AnalyticsResponse data;
  AnalyticsSuccessState({required this.data});
}

class AnalyticsErrorState extends AnalyticsState {
  final String error;
  AnalyticsErrorState({required this.error});
}
