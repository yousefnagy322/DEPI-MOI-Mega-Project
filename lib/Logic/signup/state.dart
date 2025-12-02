class SignUpState {}

class SignUpInitialState extends SignUpState {}

class SignUpLoadingState extends SignUpState {}

class SignUpSuccessState extends SignUpState {
  final String userId;
  SignUpSuccessState({required this.userId});
}

class SignUpErrorState extends SignUpState {
  final String error;
  SignUpErrorState({required this.error});
}
