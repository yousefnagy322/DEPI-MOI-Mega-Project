class UserRoleState {}

class UserRoleInitialState extends UserRoleState {}

class UserRoleLoadingState extends UserRoleState {}

class UserRoleSuccessState extends UserRoleState {}

class UserRoleErrorState extends UserRoleState {
  final String error;
  UserRoleErrorState({required this.error});
}
