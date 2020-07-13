import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo/data/api_provider/authentication_api.dart';
import 'package:todo/domain/repositories/i_user_repository.dart';

class UserRepository extends IUserRepository {
  UserRepository({this.api});
  final AuthenticationApi api;

  @override
  Future<String> getUser() async {
    try {
      return api.getUser();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> isSignedIn() async {
    try {
      return api.isSignedIn();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> signInWithCredentials(String email, String password) async {
    try {
      return api.signInWithCredentials(email, password);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<FirebaseUser> signInWithGoogle() async {
    try {
      return api.signInWithGoogle();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    try {
      return api.signOut();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> signUp({String email, String password}) async {
    try {
      return api.signUp(email: email, password: password);
    } catch (e) {
      rethrow;
    }
  }
}
