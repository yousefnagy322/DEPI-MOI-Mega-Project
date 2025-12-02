import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:migaproject/presentation/admin/admin_login_screen.dart';
import 'package:migaproject/presentation/screens/Splash/splashScreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: kIsWeb ? AdminLoginScreen() : Splashscreen());
  }
}
