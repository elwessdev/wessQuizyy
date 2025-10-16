import 'package:flutter/material.dart';
import 'package:wessQuizyy/Service/auth_service.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SignInPage> {
  final authService = AuthService();

  String errorMessage = "";
  bool isLoading = false;

  final _email = TextEditingController();
  final _password = TextEditingController();

  void handleLogin() async {

    if (isLoading) return;

    final email = _email.text;
    final password = _password.text;

    if(email.isEmpty || password.isEmpty) {
      setState(() {
        errorMessage = "Email and password cannot be empty.";
      });
      return;
    }

    if(!email.contains('@') || password.length < 6) {
      setState(() {
        errorMessage = "Please enter a valid email and password (min 6 characters).";
      });
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = "";
    });

    try {
      await authService.signIn(email, password);

      if (mounted) {
        Navigator.pushReplacementNamed(context, '/auth');
      }
    } catch (err) {
      if (mounted) {
        setState(() {
          errorMessage = "Invalid username or password.";
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("Let's Sign you in.", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                      Text("Welcome back", style: TextStyle(fontSize: 18, color: Colors.grey)),
                      Text("You've been missed!", style: TextStyle(fontSize: 18, color: Colors.grey)),
                    ],
                  ),
                ),
                const SizedBox(height: 50),
                
                // Email
                const Text('Email', style: TextStyle(color: Color(0xFF0a1653), fontWeight: FontWeight.w500, fontSize: 16)),
                const SizedBox(height: 8),
                TextField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Enter your email',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFF0a1653), width: 2)),
                    prefixIcon: const Icon(Icons.person, color: Color(0xFF0a1653)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Password
                const Text('Password', style: TextStyle(color: Color(0xFF0a1653), fontWeight: FontWeight.w500, fontSize: 16)),
                const SizedBox(height: 8),
                TextField(
                  controller: _password,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Enter your password',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFF0a1653), width: 2)),
                    prefixIcon: const Icon(Icons.lock, color: Color(0xFF0a1653)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Sign In button
                ElevatedButton(
                  onPressed: handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0a1653),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Text('Sign In', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white)),
                ),

                const SizedBox(height: 16),
                
                if (errorMessage.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.red.shade300),
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.red.shade50,
                    ),
                    child: Text(
                      errorMessage,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ),

                const SizedBox(height: 16),
                
                // OR divider
                Row(
                  children: [
                    Expanded(child: Divider(thickness: 1, color: Colors.grey.shade300)),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text('OR', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500)),
                    ),
                    Expanded(child: Divider(thickness: 1, color: Colors.grey.shade300)),
                  ],
                ),
                const SizedBox(height: 16),

                // Google Sign-In
                OutlinedButton.icon(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: BorderSide(color: Colors.grey.shade300),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  icon: Image.network(
                      'https://cdn.iconscout.com/icon/free/png-256/google-160-189824.png',
                      height: 24),
                  label: const Text('Sign in with Google', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w500)),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account? "),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/signup');
                      },
                      child: const Text('Sign Up', style: TextStyle(color: Color(0xFF0a1653), fontWeight: FontWeight.w500)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
