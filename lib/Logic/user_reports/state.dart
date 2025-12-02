import 'package:migaproject/Data/report_model.dart';

class MyReportsState {}

class MyReportsInitialState extends MyReportsState {}

class MyReportsLoadingState extends MyReportsState {}

class MyReportsSuccessState extends MyReportsState {
  final List<Report> reports;

  MyReportsSuccessState(this.reports);
}

class MyReportsErrorState extends MyReportsState {
  final String error;

  MyReportsErrorState({required this.error});
}
