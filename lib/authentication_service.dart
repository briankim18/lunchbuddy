import 'package:firebase_auth/firebase_auth.dart';

/// Class that is used to provide Firebase authentication services
class AuthenticationService {
  final FirebaseAuth _firebaseAuth;

  AuthenticationService(this._firebaseAuth);

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  // Logs a user out of the app
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  // Attempts to sign into the app
  Future<String?> signIn(
      {required String email, required String password}) async {
    String? errorMessage;

    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return "Signed in";

    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "invalid-email":
          errorMessage = "ERROR: This is not a valid email. Please try again.";
          break;
        case "user-disabled":
          errorMessage = "ERROR: This user is disabled. Please try again.";
          break;
        case "user-not-found":
          errorMessage = "ERROR: This user is not found. Please try again.";
          break;
        case "wrong-password":
          errorMessage = "ERROR: This password is incorrect. Please try again.";
          break;
        default:
          errorMessage = "ERROR: Unknown sign in error. Please try again.";
      }
    }

    return errorMessage;

  }

  /// Performs signing up for a new user
  Future<String?> signUp(
      {required String email, required String password}) async {
    UserCredential? credential;
    String? errorMessage;

    // Attempts to sign up
    try {
      credential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      // Handles errors
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

    // Returns the error message if there is one
    if (errorMessage != null) {
      return errorMessage;
    }

    return credential?.user?.uid;
  }

  /// Attempts to update a user's email
  Future<String?> updateEmail({required String email}) async {
    try {
      await getCurrentUser()?.updateEmail(email);
    } on FirebaseAuthException {
      return "ERROR: Reauthentication required";
    }

    return "Updated email";
  }

  /// Updates a user's password
  Future<String?> updatePassword({required String password}) async {
    try {
      await getCurrentUser()?.updatePassword(password);
    } on FirebaseAuthException {
      return "ERROR: Reauthentication required";
    }

    return "Updated password";
  }

  /// Deletes a user from the database
  Future<String?> deleteUser() async {
    try {
      await getCurrentUser()?.delete();
    } on FirebaseAuthException {
      return "ERROR: Reauthentication required";
    }

    return "Deleted user";
  }

  /// Re-authenticates a user when trying to change email or password
  Future<String?> reauthenticate({required String email, required String password}) async {
    try {
      AuthCredential credential = EmailAuthProvider.credential(email: email, password: password);
      await getCurrentUser()?.reauthenticateWithCredential(credential);
    } on FirebaseAuthException {
      return "ERROR: Invalid credentials";
    }

    return "Reauthenticated";
  }
}
