import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart'; // for kIsWeb
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // GoogleSignIn instance with optional clientId for web
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: kIsWeb
        ? 'YOUR_WEB_CLIENT_ID.apps.googleusercontent.com' // 🔁 Replace this
        : null,
    scopes: ['email'],
  );

  /// 🔐 Try silent sign-in (Web & Mobile)
  Future<UserCredential?> trySilentSignIn() async {
    try {
      if (kIsWeb) {
        // For web, Firebase handles persistence automatically.
        final user = _auth.currentUser;
        if (user != null) {
          print('Already signed in: ${user.email}');
          return Future.value(user as UserCredential);
        } else {
          print('No user signed in yet.');
          return null;
        }
      } else {
        final account = await _googleSignIn.signInSilently();
        if (account != null) {
          final auth = await account.authentication;
          final credential = GoogleAuthProvider.credential(
            accessToken: auth.accessToken,
            idToken: auth.idToken,
          );
          return await _auth.signInWithCredential(credential);
        } else {
          print('Silent sign-in failed');
          return null;
        }
      }
    } catch (e) {
      print('Silent sign-in error: $e');
      return null;
    }
  }

  /// 🔑 Google Sign-In (Cross-platform)
  Future<UserCredential?> signInWithGoogle() async {
    try {
      if (kIsWeb) {
        final provider = GoogleAuthProvider()
          ..setCustomParameters({'prompt': 'select_account'});

        return await _auth.signInWithPopup(provider);
      } else {
        final account = await _googleSignIn.signIn();
        if (account == null) return null; // User cancelled

        final auth = await account.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: auth.accessToken,
          idToken: auth.idToken,
        );
        return await _auth.signInWithCredential(credential);
      }
    } catch (e) {
      print('Google sign-in error: $e');
      return null;
    }
  }

  /// 🚪 Sign out from Firebase and Google
  Future<void> signOut() async {
    try {
      if (!kIsWeb) {
        await _googleSignIn.disconnect();
        await _googleSignIn.signOut();
      }
      await _auth.signOut();
    } catch (e) {
      print('Sign-out error: $e');
    }
  }

  /// Current Firebase User
  User? get currentUser => _auth.currentUser;

  /// Auth state stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}
