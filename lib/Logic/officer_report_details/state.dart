class OfficerReportDetailsState {}

class OfficerReportDetailsInitialState extends OfficerReportDetailsState {}

class OfficerReportDetailsLoadingState extends OfficerReportDetailsState {}

class OfficerReportDetailsErrorState extends OfficerReportDetailsState {
  final String error;
  OfficerReportDetailsErrorState({required this.error});
}

class OfficerReportDetailsSuccessState extends OfficerReportDetailsState {}
