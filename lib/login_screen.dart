// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'auth_service.dart';
// import 'home_screen.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final AuthService _auth = AuthService();
//   bool _loading = false;

//   Future<void> _handleGoogle() async {
//     setState(() => _loading = true);
//     final UserCredential? cred = await _auth.signInWithGoogle(

//     );
//     setState(() => _loading = false);

//     if (cred != null) {
//       if (!mounted) return;
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => const HomeScreen()),
//       );
//     } else {
//       // ignore: use_build_context_synchronously
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Google sign‑in cancelled or failed')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: _loading
//             ? const CircularProgressIndicator()
//             : ElevatedButton.icon(
//                 onPressed: _handleGoogle,
//                 icon: const Icon(Icons.login),
//                 label: const Text('Sign in with Google'),
//               ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_service.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _auth = AuthService();
  bool _loading = false;

  Future<void> _handleGoogle() async {
    setState(() => _loading = true);
    final UserCredential? cred = await _auth.signInWithGoogle();
    setState(() => _loading = false);

    if (cred != null) {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Google sign‑in cancelled or failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Icon and Name
            const Icon(Icons.note_alt_rounded, size: 64, color: Colors.blue),
            const SizedBox(height: 16),
            const Text(
              'NoteKeeper',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 48),

            // Google Sign-In Button
            if (_loading)
              const CircularProgressIndicator()
            else
              ElevatedButton(
                onPressed: _handleGoogle,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black87,
                  minimumSize: const Size(240, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: Colors.grey.shade300),
                  ),
                  elevation: 1,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.g_mobiledata, size: 24), // Using built-in icon
                    SizedBox(width: 12),
                    Text('Sign in with Google', style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
