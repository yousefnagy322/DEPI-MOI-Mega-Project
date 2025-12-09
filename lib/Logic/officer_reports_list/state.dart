import 'package:migaproject/Data/count_model.dart';
import 'package:migaproject/Data/report_model.dart';

class OfficerReportsState {}

class OfficerReportsInitialState extends OfficerReportsState {}

class OfficerReportsLoadingState extends OfficerReportsState {}

class OfficerReportsSuccessState extends OfficerReportsState {
  final List<Report> reports;
  final Counts counts;
  final int usercount;
  OfficerReportsSuccessState({
    required this.reports,
    required this.counts,
    required this.usercount,
  });
}

class OfficerReportsErrorState extends OfficerReportsState {
  final String error;
  OfficerReportsErrorState({required this.error});
}
