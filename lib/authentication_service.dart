import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;

  AuthenticationService(this._firebaseAuth);

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<String?> signIn(
      {required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return "Signed in";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<String?> signUp(
      {required String email, required String password}) async {
    UserCredential? credential;
    String? errorMessage;

    try {
      credential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "email-already-in-use":
          errorMessage =
              "ERROR: This email is already being used. Please try again.";
          break;
        case "invalid-email":
          errorMessage = "ERROR: This is not a valid email. Please try again.";
          break;
        case "operation-not-allowed":
          errorMessage =
              "ERROR: Developers: Please enable email/password accounts in Firebase.";
          break;
        default:
          errorMessage = "ERROR: Unknown sign up error. Please try again.";
      }
    }

    if (errorMessage != null) {
      return errorMessage;
    }

    return credential?.user?.uid;
  }

  Future<String?> updateEmail({required String email}) async {
    try {
      await getCurrentUser()?.updateEmail(email);
    } on FirebaseAuthException catch (e) {
      print("Fail");
      return "ERROR: Reauthentication required";
    }
    print("Successful email update!");
    return "Updated email";
  }

  Future<String?> updatePassword({required String password}) async {
    try {
      await getCurrentUser()?.updatePassword(password);
    } on FirebaseAuthException catch (e) {
      print(e.message);
      return "ERROR: Reauthentication required";
    }
    return "Updated password";
  }

  Future<String?> deleteUser() async {
    try {
      await getCurrentUser()?.delete();
    } on FirebaseAuthException catch (e) {
      print(e.message);
      return "ERROR: Reauthentication required";
    }
    return "Deleted user";
  }

  Future<String?> reauthenticate({required String email, required String password}) async {
    try {
      AuthCredential credential = EmailAuthProvider.credential(email: email, password: password);
      await getCurrentUser()?.reauthenticateWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      print(e.message);
      return "ERROR: Invalid credentials";
    }
    print("Successful authenticate!");
    return "Reauthenticated";
  }
}
