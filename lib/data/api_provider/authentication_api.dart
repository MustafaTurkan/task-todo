import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:todo/infrastructure/logger/logger.dart';

class AuthenticationApi {
  AuthenticationApi(this.logger)
      : _firebaseAuth = FirebaseAuth.instance,
        _googleSignIn = GoogleSignIn();

  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final Logger logger;

  Future<FirebaseUser> signInWithGoogle() async {
    try {
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await _firebaseAuth.signInWithCredential(credential);
      return _firebaseAuth.currentUser();
    } catch (e) {
      logger.error(e.toString());
      throw Exception(e);
    }
  }

  Future<void> signInWithCredentials(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      logger.error(e.toString());
      throw Exception(e);
    }
  }

  Future<void> signUp({String email, String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      logger.error(e.toString());
      throw Exception(e);
    }
  }

  Future<bool> isSignedIn() async {
    try {
      final currentUser = await _firebaseAuth.currentUser();
      return currentUser != null;
    } catch (e) {
      logger.error(e.toString());
      throw Exception(e);
    }
  }

  Future<String> getUser() async {
    try {
      return (await _firebaseAuth.currentUser()).email;
    } catch (e) {
      logger.error(e.toString());
      throw Exception(e);
    }
  }

  Future<void> signOut() async {
    return Future.wait([
      _firebaseAuth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }
}
