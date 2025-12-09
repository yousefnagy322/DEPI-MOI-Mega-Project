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

      // SUCCESS CASE
      final userId = response.data['user_id'];
      final role = response.data['role'];
      final accessToken = response.data['access_token'];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userId', userId);
      await prefs.setString('accessToken', accessToken);

      emit(LoginSuccessState(role: role, toekn: accessToken));
    } on DioException catch (e) {
      // SPECIFIC ERROR HANDLING
      final status = e.response?.statusCode;
      final data = e.response?.data;

      if (status == 401) {
        emit(LoginErrorState(error: data?['detail'] ?? "Unauthorized"));
      } else {
        emit(
          LoginErrorState(
            error: data?['detail'] ?? e.message ?? 'Unknown error',
          ),
        );
      }
    } catch (e) {
      emit(LoginErrorState(error: e.toString()));
    }
  }
}
