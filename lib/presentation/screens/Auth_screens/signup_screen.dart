import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:migaproject/Logic/signup/cubit.dart';
import 'package:migaproject/Logic/signup/state.dart';

import 'package:migaproject/presentation/screens/my_reports/my_reports_screen.dart';
import 'package:migaproject/presentation/widgets/loading_snackbar.dart';
import 'package:migaproject/presentation/widgets/success_snackbar.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  final fromkey = GlobalKey<FormState>();

  bool _obscurePassword = true;
  bool _guestMode = false;
  bool isloading = false;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: fromkey,
      child: BlocProvider(
        create: (context) => SignUpCubit(),
        child: BlocConsumer<SignUpCubit, SignUpState>(
          listener: (context, state) {
            if (state is SignUpLoadingState) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(LoadingSnackBar(message: "Signing up..."));
              setState(() {
                isloading = true;
              });
            } else if (state is SignUpSuccessState) {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();

              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SuccessSnackBar(message: 'Signup successful'));
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ReportsScreen()),
              );
            } else if (state is SignUpErrorState) {
              print(state.error);
            }
          },
          builder: (context, state) {
            return Scaffold(
              backgroundColor: Colors.white,
              body: Padding(
                padding: EdgeInsetsGeometry.all(12),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 60),
                      // Logo
                      Center(
                        child: Image(
                          image: AssetImage("assets/images/image 2.png"),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Title
                      const SizedBox(height: 24),

                      // Welcome Text
                      Center(
                        child: const Text(
                          'Create a New Account',
                          style: TextStyle(
                            fontFamily: 'inter',
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff424242),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.emailAddress,
                        controller: emailController,
                        decoration: InputDecoration(
                          hintText: 'Enter Email',
                          hintStyle: TextStyle(
                            fontFamily: 'inter',
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff77767C),
                          ),
                          prefixIcon: Icon(
                            Icons.email_outlined,
                            color: Color(0xffC1C1C3),
                          ),

                          filled: true,
                          fillColor: Color(0xffF3F3F5),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFD7D7D7)),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(color: Color(0xFFD7D7D7)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // phone number Field
                      TextFormField(
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty && value.length >= 11) {
                            return 'Please enter your phone number';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.number,
                        controller: phoneNumberController,
                        decoration: InputDecoration(
                          hintText: 'Enter Phone Number',
                          hintStyle: TextStyle(
                            fontFamily: 'inter',
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff77767C),
                          ),
                          prefixIcon: Icon(
                            Icons.phone_outlined,
                            color: Color(0xffC1C1C3),
                          ),

                          filled: true,
                          fillColor: Color(0xffF3F3F5),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFD7D7D7)),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(color: Color(0xFFD7D7D7)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Password Field
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                        textAlignVertical: TextAlignVertical.center,

                        obscureText: _obscurePassword,
                        controller: passwordController,
                        decoration: InputDecoration(
                          hintText: 'Password',

                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                            child: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Color(0xffC1C1C3),
                            ),
                          ),
                          prefixIcon: Icon(
                            Icons.lock_outline,
                            color: Color(0xffC1C1C3),
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(color: Color(0xFFD7D7D7)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(color: Color(0xFFD7D7D7)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Sign In Button
                      Center(
                        child: SizedBox(
                          width: 292,
                          height: 46,
                          child: ElevatedButton(
                            onPressed: () {
                              if (fromkey.currentState!.validate()) {
                                context.read<SignUpCubit>().createNewUser(
                                  email: emailController.text,
                                  password: passwordController.text,
                                  phoneNumber: phoneNumberController.text,
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xff1A73E8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: const Text(
                              'Sign Up',
                              style: TextStyle(
                                fontFamily: 'inter',
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
