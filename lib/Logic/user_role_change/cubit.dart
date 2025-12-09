import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:migaproject/Logic/user_role_change/state.dart';
import 'package:migaproject/core/api_paths.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRoleCubit extends Cubit<UserRoleState> {
  UserRoleCubit() : super(UserRoleInitialState());

  Future changeUserRole({required String userId, required String role}) async {
    emit(UserRoleLoadingState());

    Dio dio = Dio();
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');
    try {
      final response = await dio.put(
        '${ApiPaths.baseUrl}/api/v1/users/$userId/role',
        data: {'role': role},
        options: Options(
          headers: {
            'authorization': 'Bearer $token',
            'accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
      );
      if (response.statusCode == 200) {
        emit(UserRoleSuccessState());
      } else {
        emit(UserRoleErrorState(error: 'Failed to change user role'));
      }
    } catch (e) {
      emit(UserRoleErrorState(error: e.toString()));
    }
  }
}
