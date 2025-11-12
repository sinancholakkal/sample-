import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;
  final GoogleSignIn signIn = GoogleSignIn.instance;

  String? uidOfUser;

  User? getCurrentUser() {
    final User? user = FirebaseAuth.instance.currentUser;
    return user;
  }

  //cheking login status
  // User? checkLoginStatus() {
  //   // return (_auth.currentUser == null) ? false : true;
  //   return getCurrentUser();
  // }

  Future<User?> signInWithGoogle() async {
    try {
      await signIn.initialize(
        serverClientId:
            "731954711783-o7tuesse592kjojgsvr609i9oo0f49lt.apps.googleusercontent.com",
      );
      final account = await signIn.authenticate();
      if (account == null) {
        return null;
      }
      final auth = account.authentication;
      final credential = GoogleAuthProvider.credential(idToken: auth.idToken);
      final userCredential = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );
      final user = userCredential.user;
      return user;
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        throw "Sign-in cancelled by user";
      } else {
        throw "Login field";
      }
    } catch (e) {
      throw "Unexpected error $e";
    }
    // try {
    //   final googleUser = await GoogleSignIn().signIn();
    //   final googleAuth = await googleUser?.authentication;
    //   final cred = GoogleAuthProvider.credential(
    //       idToken: googleAuth?.idToken, accessToken: googleAuth?.accessToken);
    //   log("succsess=============");
    //   return await _auth.signInWithCredential(cred);
    // } catch (e) {
    //   log(e.toString());
    // }
    // return null;
  }

  //create user (sign up)
  Future<User?> createUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    uidOfUser = cred.user!.uid;
    log(getCurrentUser()!.uid);
    return cred.user;
  }

  //create user (Sign In)
  Future<User?> signInUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return cred.user;
  }

  //signOut
  Future<void> signOut() async {
    log("Signout called");
    // log(getCurrentUser()?.uid);
    if (getCurrentUser()?.uid != null) {
      await _auth.signOut();
    }
  }

  //forgot---
  Future<String?> forgotPassword(String email) async {
    log("forgot function called");
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'invalid-email') {
        return 'The email address is not valid.';
      } else {
        return 'An unexpected error occurred. Please try again.';
      }
    } catch (e) {
      return 'An unknown error occurred.';
    }
  }


  Future<void> sendOtp({
    required String phoneNumber,
    required Function(String verificationId, int? resendToken) onCodeSent,
    required Function(FirebaseAuthException e) onVerificationFailed,
  }) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber, // Must be in E.164 format (e.g., +919876543210)
        verificationCompleted: (PhoneAuthCredential credential) {
          // This is for auto-retrieval on Android.
          // You can automatically sign the user in here.
          log("Verification completed automatically.");
        },
        verificationFailed: onVerificationFailed,
        codeSent: onCodeSent,
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      log("Error sending OTP: $e");
      rethrow;
    }
  }

  /// Verifies the OTP and signs the user in.
  ///
  /// Returns a `UserCredential` on success.
  Future<UserCredential> verifyOtp({
    required String verificationId,
    required String otp,
  }) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );
      return await _auth.signInWithCredential(credential);
    } catch (e) {
      log("Error verifying OTP: $e");
      rethrow;
    }
  }
}
