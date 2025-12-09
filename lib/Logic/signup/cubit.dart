import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:migaproject/Logic/signup/state.dart';
import 'package:migaproject/core/api_paths.dart';
import 'package:shared_preferences/shared_preferences.dart';

// class SignUpCubit extends Cubit<SignUpState> {
//   SignUpCubit() : super(SignUpInitialState());

//   Future createNewUser({
//     required String email,
//     required String password,
//     required String phoneNumber,
//   }) async {
//     emit(SignUpLoadingState());

//     Dio dio = Dio();

//     try {
//       final response = await dio.post(
//         'https://moi-bxe3dvd5hnayazbs.uaenorth-01.azurewebsites.net/api/v1/auth/register',
//         data: {
//           'email': email,
//           'password': password,
//           'phoneNumber': phoneNumber,
//           "role": "citizen",
//           "hashedDeviceId": "string",
//         },
//         options: Options(
//           headers: {
//             'accept': 'application/json',
//             'Content-Type': 'application/json',
//           },
//         ),
//       );

//       print(response.data);

//       if (response.statusCode == 201) {
//         final userid = response.data['userId'];
//         final prefs = await SharedPreferences.getInstance();
//         prefs.setString('userId', userid);
//         emit(SignUpSuccessState(userId: userid));
//       } else {
//         emit(
//           SignUpErrorState(
//             error:
//                 'Registration failed with status: ${response.statusCode}, body: ${response.data}, headers: ${response.data['detail']}',
//           ),
//         );
//       }
//     } catch (e) {
//       emit(SignUpErrorState(error: e.toString()));
//     }
//   }
// }

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit() : super(SignUpInitialState());

  Future createNewUser({
    required String email,
    required String password,
    required String phoneNumber,
    String? role,
  }) async {
    emit(SignUpLoadingState());

    // Pre-validation
    if (!email.contains('@')) {
      emit(SignUpErrorState(error: 'Invalid email'));
      return;
    }

    if (password.length < 8) {
      emit(SignUpErrorState(error: 'Password must be at least 8 characters'));
      return;
    }

    if (!phoneNumber.startsWith('+')) {
      phoneNumber = '+2$phoneNumber';
    }

    Dio dio = Dio();

    try {
      final response = await dio.post(
        ApiPaths.signup,
        data: {
          'email': email,
          'password': password,
          'phoneNumber': phoneNumber,
          'role': role ?? 'citizen',
          'hashedDeviceId': 'string',
        },
        options: Options(
          headers: {
            'accept': 'application/json',
            'Content-Type': 'application/json',
          },
          validateStatus: (status) =>
              true, // accept all responses for debugging
        ),
      );

      print('Status: ${response.statusCode}');
      print('Body: ${response.data}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        final userid = response.data['userId']?.toString() ?? '';
        if (userid.isNotEmpty) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('userId', userid);
          emit(SignUpSuccessState(userId: userid));
        } else {
          emit(SignUpErrorState(error: 'userId not returned from API'));
        }
      } else {
        emit(
          SignUpErrorState(
            error:
                'Registration failed with status: ${response.statusCode}, body: ${response.data}',
          ),
        );
      }
    } catch (e) {
      emit(SignUpErrorState(error: e.toString()));
    }
  }
}
