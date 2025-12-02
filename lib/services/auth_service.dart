import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Stream to listen to auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Sign in with email and password
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('An unknown error occurred.');
    }
  }

  // Sign up with email and password
  Future<UserCredential> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('An unknown error occurred.');
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Sign in with Google
  Future<UserCredential> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      // Using GoogleSignIn.instance for v7 compatibility

      // TODO: If you see "serverClientId must be provided", either:
      // 1. Download a new google-services.json with Web OAuth Client (type 3)
      // 2. OR provide your Web Client ID below:
      const String? serverClientId =
          "815772245980-m4us9j1fpv42b1sefanrotitnj5o8qbe.apps.googleusercontent.com";

      await GoogleSignIn.instance.initialize(serverClientId: serverClientId);

      // signIn() is removed in v7, use authenticate()
      final GoogleSignInAccount googleUser = await GoogleSignIn.instance
          .authenticate();

      // authenticate() returns a non-nullable Future<GoogleSignInAccount>
      // If the user cancels, it throws an exception (usually PlatformException or similar)
      // So we don't need to check for null here.

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      // Create a new credential
      // Note: accessToken is no longer available in v7's GoogleSignInAuthentication
      // and is not strictly required for Firebase Auth with Google.
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: null,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      return await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      // Log the error for debugging
      print('Google Sign-In Error: $e');
      if (e.toString().contains('serverClientId must be provided')) {
        print('\n!!! ACTION REQUIRED !!!');
        print('You are missing the Web OAuth Client ID configuration.');
        print(
          'Please see lib/services/auth_service.dart lines 58-62 for instructions.',
        );
        print(
          'You need to either update google-services.json or set serverClientId manually.\n',
        );
      }
      throw Exception('Google Sign-In failed: $e');
    }
  }

  // Helper to handle Firebase Auth exceptions
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
        return 'Wrong password provided for that user.';
      case 'email-already-in-use':
        return 'The account already exists for that email.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'account-exists-with-different-credential':
        return 'An account already exists with the same email address but different sign-in credentials. Sign in using a provider associated with this email address.';
      case 'ERROR_ABORTED_BY_USER':
        return 'Sign in aborted by user.';
      default:
        return 'An error occurred. Please try again.';
    }
  }
}
