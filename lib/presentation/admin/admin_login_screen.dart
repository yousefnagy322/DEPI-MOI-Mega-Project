import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:migaproject/Logic/login/cubit.dart';
import 'package:migaproject/Logic/login/state.dart';
import 'admin_home.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  bool isLoading = false;
  final formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool _obscurePassword = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginLoadingState) {
            if (!isLoading) {
              setState(() {
                isLoading = true;
              });
            }
          } else if (state is LoginErrorState) {
            if (isLoading) {
              setState(() {
                isLoading = false;
              });
            }

            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.error)));
          } else if (state is LoginSuccessState) {
            if (isLoading) {
              setState(() {
                isLoading = false;
              });
            }
            if (state.role == "admin") {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (ctx) {
                    // Pass the existing LoginCubit down so admin area can use the token
                    return BlocProvider.value(
                      value: context.read<LoginCubit>(),
                      child: const AdminHome(),
                    );
                  },
                ),
              );
            } else if (state.role == "officer" || state.role == "citizen") {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('You are not an admin'),
                  backgroundColor: Colors.red,
                  duration: Duration(seconds: 5),
                ),
              );
            }
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 40),

                        // Logo
                        Center(
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(
                              Icons.admin_panel_settings,
                              size: 48,
                              color: Colors.white,
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Welcome Text
                        const Center(
                          child: Text(
                            'Admin Panel',
                            style: TextStyle(
                              fontFamily: 'inter',
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: Color(0xff424242),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Center(
                          child: Text(
                            'Login to access admin dashboard',
                            style: TextStyle(
                              fontFamily: 'inter',
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff77767C),
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),

                        // Email Field
                        _EmailField(controller: emailController),
                        const SizedBox(height: 20),

                        // Password Field
                        _PasswordField(
                          controller: passwordController,
                          obscureText: _obscurePassword,
                          onToggleVisibility: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        const SizedBox(height: 12),

                        // Forgot Password
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              // Handle forgot password
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Forgot password functionality coming soon',
                                  ),
                                ),
                              );
                            },
                            child: const Text(
                              'Forgot Password?',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Color(0xff1A73E8),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Login Button
                        _LoginButton(
                          isLoading: isLoading,
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              context.read<LoginCubit>().loginUser(
                                email: emailController.text,
                                password: passwordController.text,
                              );
                            }
                          },
                        ),

                        const SizedBox(height: 24),

                        // Info Text
                        const Center(
                          child: Text(
                            'Admin access only',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
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

// Extracted widgets for better performance

class _EmailField extends StatelessWidget {
  final TextEditingController controller;

  const _EmailField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email';
        }
        if (!value.contains('@')) {
          return 'Please enter a valid email';
        }
        return null;
      },
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: 'Enter Email',
        hintStyle: const TextStyle(
          fontFamily: 'inter',
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Color(0xff77767C),
        ),
        prefixIcon: const Icon(Icons.email_outlined, color: Color(0xffC1C1C3)),
        filled: true,
        fillColor: const Color(0xffF3F3F5),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFFD7D7D7)),
          borderRadius: BorderRadius.circular(16),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xff1A73E8), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
      ),
    );
  }
}

class _PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final bool obscureText;
  final VoidCallback onToggleVisibility;

  const _PasswordField({
    required this.controller,
    required this.obscureText,
    required this.onToggleVisibility,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your password';
        }
        if (value.length < 6) {
          return 'Password must be at least 6 characters';
        }
        return null;
      },
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: 'Password',
        hintStyle: const TextStyle(
          fontFamily: 'inter',
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Color(0xff77767C),
        ),
        prefixIcon: const Icon(Icons.lock_outline, color: Color(0xffC1C1C3)),
        suffixIcon: IconButton(
          icon: Icon(
            obscureText
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            color: const Color(0xffC1C1C3),
          ),
          onPressed: onToggleVisibility,
        ),
        filled: true,
        fillColor: const Color(0xffF3F3F5),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFD7D7D7)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xff1A73E8), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;

  const _LoginButton({required this.isLoading, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xff1A73E8),
          disabledBackgroundColor: const Color(0xff1A73E8).withOpacity(0.6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Text(
                'Login',
                style: TextStyle(
                  fontFamily: 'inter',
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}
