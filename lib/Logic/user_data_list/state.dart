import 'package:migaproject/Data/user_model.dart';

class UserDataState {}

class UserDataInitialState extends UserDataState {}

class UserDataLoadingState extends UserDataState {}

class UserDataSuccessState extends UserDataState {
  final List<UserModel> users;
  UserDataSuccessState({required this.users});
}

class UserDataErrorState extends UserDataState {
  final String error;
  UserDataErrorState({required this.error});
}
