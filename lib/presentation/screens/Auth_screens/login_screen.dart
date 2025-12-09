import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:migaproject/Logic/login/cubit.dart';
import 'package:migaproject/Logic/login/state.dart';
import 'package:migaproject/presentation/screens/Auth_screens/signup_screen.dart';

import 'package:migaproject/presentation/screens/my_reports/my_reports_screen.dart';
import 'package:migaproject/presentation/screens/officer_dashboard/officer_dashboared.dart';
import 'package:migaproject/presentation/widgets/loading_snackbar.dart';
import 'package:migaproject/presentation/widgets/success_snackbar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static String id = "LoginScreen";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isloading = false;
  final formkey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _guestMode = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginLoadingState) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(LoadingSnackBar(message: "Logging in..."));
            setState(() {
              isloading = true;
            });
          } else if (state is LoginErrorState) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SuccessSnackBar(message: state.error));
          } else if (state is LoginSuccessState) {
            setState(() {
              isloading = false;
            });
            if (state.role == "citizen") {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();

              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SuccessSnackBar(message: 'Login successful'));
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ReportsScreen()),
              );
            } else if (state.role == "officer") {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();

              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SuccessSnackBar(message: 'Login successful'));
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => OfficerDashboard()),
              );
            } else if (state.role == "admin") {
              ScaffoldMessenger.of(context).showSnackBar(
                SuccessSnackBar(message: "Please use Admin panel"),
              );
            }
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Padding(
              padding: EdgeInsetsGeometry.all(12),
              child: SingleChildScrollView(
                child: Form(
                  key: formkey,
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
                      const Text(
                        'Welcome to Moi',
                        style: TextStyle(
                          fontFamily: 'inter',
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff424242),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Login to continue',
                        style: TextStyle(
                          fontFamily: 'inter',
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff424242),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Email Field
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
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

                      // Password Field
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                        controller: passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          hintText: 'Password',
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
                              if (formkey.currentState!.validate()) {
                                context.read<LoginCubit>().loginUser(
                                  email: emailController.text,
                                  password: passwordController.text,
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
                              'Login',
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

                      // Or Text
                      Center(
                        child: Text(
                          'Or',
                          style: TextStyle(
                            fontFamily: 'inter',
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: Color(0xffBDBDBD),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),

                      // Forgot Password
                      const SizedBox(height: 8),

                      const Text(
                        'Guest Mode',
                        style: TextStyle(
                          fontFamily: 'inter',
                          color: Color(0xff424242),
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      // Guest Mode
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Continue as Anonymous',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                  color: Color(0xff6C757D),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 40,
                            height: 32,
                            child: Transform.scale(
                              scale: 0.7,
                              child: Switch(
                                value: _guestMode,
                                onChanged: (val) =>
                                    setState(() => _guestMode = val),
                                activeTrackColor: Color(0xff1A73E8),
                                activeThumbColor: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Don\'t have an account?',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff424242),
                            ),
                          ),

                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SignUpScreen(),
                                ),
                              );
                            },
                            child: Text(
                              ' Sign Up',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Color(0xff1A73E8),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
