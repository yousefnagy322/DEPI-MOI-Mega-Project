import 'package:migaproject/Data/report_model.dart';

class OfficerReportsState {}

class OfficerReportsInitialState extends OfficerReportsState {}

class OfficerReportsLoadingState extends OfficerReportsState {}

class OfficerReportsSuccessState extends OfficerReportsState {
  final List<Report> reports;
  OfficerReportsSuccessState(this.reports);
}

class OfficerReportsErrorState extends OfficerReportsState {
  final String error;
  OfficerReportsErrorState({required this.error});
}
