import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import "SplashScreen.dart";
import "Auth/Signin.dart";
import "Auth/Signup.dart";
import 'Service/auth_gate.dart';
import 'App/Game.dart';

void main() async{
  await dotenv.load(fileName: ".env");
  await Supabase.initialize(
    url: dotenv.env['DB_URL'],
    anonKey: dotenv.env['SECRET_KEY'],
  );
  runApp(const MyApp());
}

// #4e75ff
// #0a1653

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'wessQuizyy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Color(0xFF0a1653),
        scaffoldBackgroundColor: Color.fromARGB(255, 255, 255, 255),
        fontFamily: 'Roboto',
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/authgate': (context) => const AuthGate(),
        '/signin': (context) => const SignInPage(),
        '/signup': (context) => const SignUpPage(),
        '/game': (context) => const GamePage(),
      },
    );
  }
}

