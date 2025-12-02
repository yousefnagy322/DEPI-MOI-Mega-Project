class NewReportState {}

class NewReportInitialState extends NewReportState {}

class NewReportLoadingState extends NewReportState {}

class NewReportSuccessState extends NewReportState {
  String id;

  NewReportSuccessState({required this.id});
}

class NewReportErrorState extends NewReportState {
  final String error;

  NewReportErrorState({required this.error});
}
