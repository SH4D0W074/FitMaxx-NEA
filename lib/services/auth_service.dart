import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<UserCredential> registerWithEmailPassword({required String email, required String password}) async {
    // try creating the user
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      // display error message to user
      throw _mapAuthError(e);
    }
  }

  Future<UserCredential> signInWithEmailPassword({required String email, required String password}) async {
    // try signing in the user
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      // display error message to user
      throw _mapAuthError(e);
    }
  }

  // sign out user
  Future<void> signOut() => _auth.signOut();

  // delete user account
  Future<void> deleteAccount() async {
    final user = _auth.currentUser;
    if (user == null) return;
    final uid = user.uid;
    await _db.collection('Users').doc(uid).delete();
    await user.delete();
  }

  // map FirebaseAuthException codes to user-friendly messages
  String _mapAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'That email is already in use.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'weak-password':
        return 'Password is too weak (minimum 6 characters).';
      default:
        return e.message ?? 'Authentication error. Please try again.';
    }
  }
}
