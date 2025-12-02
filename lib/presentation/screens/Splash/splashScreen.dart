import 'package:flutter/material.dart';
import 'package:migaproject/presentation/screens/Auth_screens/login_screen.dart';

class Splashscreen extends StatelessWidget {
  const Splashscreen({super.key});

  static String id = "SplashScreen";

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Image.asset("assets/images/Report 1.png")],
          ),
        ),
      ),
    );
  }
}
