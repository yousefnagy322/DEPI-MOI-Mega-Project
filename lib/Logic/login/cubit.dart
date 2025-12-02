import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:migaproject/Logic/login/state.dart';
import 'package:migaproject/core/api_paths.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitialState());

  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    emit(LoginLoadingState());

    Dio dio = Dio();

    try {
      final response = await dio.post(
        ApiPaths.login,
        data: {
          'grant_type': 'password',
          'username': email,
          'password': password,
          'scope': '',
          'client_id': '',
          'client_secret': '',
        },
        options: Options(
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        final userId = response.data['user_id'];
        final role = response.data['role'];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('userId', userId);

        emit(LoginSuccessState(role: role));
      } else {
        emit(LoginErrorState(error: 'Login failed: ${response.statusCode}'));
      }
    } catch (e) {
      emit(LoginErrorState(error: e.toString()));
    }
  }
}
