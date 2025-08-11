import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  Future<User> signInAnonymously() async {
    final cred = await _auth.signInAnonymously();
    return cred.user!;
  }

  Future<void> signOut() => _auth.signOut();

  Future<String> getIdToken() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('No authenticated user');
    return await user.getIdToken(true);
  }
}
