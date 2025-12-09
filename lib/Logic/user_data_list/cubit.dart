import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:migaproject/Data/user_model.dart';
import 'package:migaproject/Logic/user_data_list/state.dart';
import 'package:migaproject/core/api_paths.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserDataCubit extends Cubit<UserDataState> {
  UserDataCubit() : super(UserDataInitialState());

  Future<void> fetchUserData() async {
    emit(UserDataLoadingState());

    Dio dio = Dio();
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');
    try {
      final response = await dio.get(
        ApiPaths.listUsers,
        options: Options(
          headers: {
            'authorization': 'Bearer $token',
            'accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        // Parse the response correctly
        final List<dynamic> jsonList = response.data;

        final List<UserModel> users = jsonList
            .map((item) => UserModel.fromJson(item))
            .toList();

        emit(UserDataSuccessState(users: users));
      } else {
        emit(UserDataErrorState(error: 'Failed to load users'));
      }
    } catch (e) {
      emit(UserDataErrorState(error: e.toString()));
    }
  }
}
