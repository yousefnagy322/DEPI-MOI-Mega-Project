import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:migaproject/presentation/admin/admin_login_screen.dart';
import 'package:migaproject/presentation/screens/Splash/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue[100]!),
      ),

      home: kIsWeb ? AdminLoginScreen() : Splashscreen(),
    );
  }
}
