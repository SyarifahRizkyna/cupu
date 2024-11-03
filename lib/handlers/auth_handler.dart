import 'package:firebase_auth/firebase_auth.dart';

class AuthHandler {
  final String email;
  final String password;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthHandler({
    this.email = "",
    this.password = "",
  });

  Future<Map<String, dynamic>> signIn(String email, String password) async {
    try {
      final UserCredential res = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return {
        "isvalid": true,
        "data": res.user,
      };
    } on FirebaseAuthException catch (err) {
      return {
        "isvalid": false,
        "data": err.message, // Akses pesan error dari Firebase
      };
    } catch (err) {
      return {
        "isvalid": false,
        "data": "An unknown error occurred", // Pesan error default
      };
    }
  }

  Future<Map<String, dynamic>> register() async {
    try {
      final UserCredential res = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await res.user?.sendEmailVerification();

      return {
        "isvalid": true,
        "data": res.user,
      };
    } on FirebaseAuthException catch (err) {
      return {
        "isvalid": false,
        "data": err.message, // Akses pesan error dari Firebase
      };
    } catch (err) {
      return {
        "isvalid": false,
        "data": "An unknown error occurred", // Pesan error default
      };
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
