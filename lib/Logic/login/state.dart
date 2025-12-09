class LoginState {}

class LoginInitialState extends LoginState {}

class LoginLoadingState extends LoginState {}

class LoginErrorState extends LoginState {
  String error;
  LoginErrorState({required this.error});
}

class LoginSuccessState extends LoginState {
  String role;
  String toekn;
  LoginSuccessState({required this.role, required this.toekn});
}
