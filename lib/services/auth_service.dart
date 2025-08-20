import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  // Get Firebase Auth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Stream of auth changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign in with email and password
  Future<User?> signIn(String email, String password) async {
    final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password
    );
    return credential.user;
  }

  // Create new user
  Future<User?> signUp(String email, String password) async {
    final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password
    );
    return credential.user;
  }

  // Sign Out
  Future<void> signOut() async {
    await _auth.signOut();
  }
}