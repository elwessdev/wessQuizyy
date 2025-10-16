import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wessQuizyy/Auth/Signin.dart';
import 'package:wessQuizyy/App/Home.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Supabase.instance.client.auth.onAuthStateChange,

      builder: (context, snapshot) {
        
        // Loading
        if(snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Check if the user is authenticated
        final session = snapshot.hasData ? snapshot.data?.session : null;
        if (session != null && session.user != null) {
          return HomePage();
        } else {
          return SignInPage();
        }

      },

    );
  }
}