import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating_app/services/auth_services.dart';
import 'package:dating_app/utils/app_string.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final authServices = AuthService();
  AuthBloc() : super(AuthInitial()) {
    on<CheckLoginStatusEvent>((event, emit) async {
      User? user;
      try {
        await Future.delayed(Duration(seconds: 2), () {
          user = authServices.getCurrentUser();
        });

        if (user != null) {
          final docRef = FirebaseFirestore.instance
              .collection("user")
              .doc(user!.uid);
          final docSnap = await docRef.get();

          if (docSnap.exists) {
            log("User has account");
            final data = docSnap.data() as Map<String, dynamic>;

            if (data['isSetupProfile'] == true) {
              emit(AuthSuccessNavigateToHome());
            } else {
              emit(AuthSuccessNavigateToProfileSetup());
              //emit(AuthSuccessNavigateToHome());
            }
          } else {
            log("User has not account");

            //emit(AuthSuccessNavigateToProfileSetup());
            emit(AuthSuccessNavigateToHome());
          }
        } else {
          emit(AuthNoFountState());
        }
      } catch (e) {
        log("error $e");
      }
    });

    // Handler for sending OTP
    // on<SendOtpEvent>((event, emit) async {
    //   emit(AuthLoadingState());

    //   log(event.phoneNumber.length.toString());
    //   if (event.phoneNumber.length == 10) {
    //     // emit(AuthCodeSentSuccessState(phoneNumber: event.phoneNumber));
    //     authServices.sendOtp(
    //       phoneNumber: "91${event.phoneNumber}",
    //       onCodeSent: (verificationId, resendToken) {
    //         //add(_OtpSentEvent(verificationId: verificationId));
    //       },
    //       onVerificationFailed: (e) {
    //         log(e.toString());
    //       },
    //     );
    //   } else if (event.phoneNumber.isEmpty) {
    //     emit(InvalidNumberState(msg: AppStrings.enterNo));
    //   } else {
    //     emit(InvalidNumberState(msg: AppStrings.enterValidNo));
    //   }
    // });

    on<SendOtpEvent>((event, emit) async {
      emit(AuthLoadingState());

      try {
        if (event.phoneNumber.length == 10) {
          authServices.sendOtp(
            phoneNumber: "+91${event.phoneNumber}",
            onCodeSent: (verificationId, resendToken) {
              // When the code is sent, add a private event with the verificationId
              log(
                "verification $verificationId kslllllllllllllllllllllllllllllllllllllllllll",
              );
              //emit(AuthCodeSentSuccess(verificationId: verificationId,phoneNumber: event.phoneNumber));
              add(
                _OtpSentEvent(
                  verificationId: verificationId,
                  phoneNumber: event.phoneNumber,
                ),
              );
            },
            onVerificationFailed: (e) {
              log("filed to send otp $e");
              emit(AuthError(message:"Failed to send OTP"));
            },
          );
        } else if (event.phoneNumber.isEmpty) {
          emit(InvalidNumberState(msg: AppStrings.enterNo));
        } else {
          emit(InvalidNumberState(msg: AppStrings.enterValidNo));
        }
      } catch (e) {
        log("Something wrong while send OTP $e");
      }
    });

    on<_OtpSentEvent>((event, emit) {
      // When the private event is received, emit the success state
      emit(
        AuthCodeSentSuccess(
          verificationId: event.verificationId,
          phoneNumber: event.phoneNumber,
        ),
      );
    });

    on<VerifyOtpEvent>((event, emit) async {
      // Get the verificationId from the current state
      if (state is AuthCodeSentSuccess) {
        final verificationId = (state as AuthCodeSentSuccess).verificationId;
        // emit(AuthLoadingState());
        try {
          if (event.otp.isNotEmpty) {
            final credentiol = await authServices.verifyOtp(
              verificationId: verificationId,
              otp: event.otp,
            );
            final user = credentiol.user;
            if (user != null) {
              final docRef = FirebaseFirestore.instance
                  .collection("user")
                  .doc(user.uid);
              final docSnap = await docRef.get();

              if (docSnap.exists) {
                log("User has account");
                final data = docSnap.data() as Map<String, dynamic>;

                if (data['isSetupProfile'] == true) {
                  emit(AuthSuccessNavigateToHome());
                } else {
                  emit(AuthSuccessNavigateToProfileSetup());
                  //emit(AuthSuccessNavigateToHome());
                }
              } else {
                log("User has not account");
                await docRef.set({
                  "email": user.email,
                  "createdAt": FieldValue.serverTimestamp(),
                  "isSetupProfile": false,
                });
                emit(AuthSuccessNavigateToProfileSetup());
              }
            } else {
              emit(AuthNoFountState());
            }
          } else {
            emit(AuthError(message: "Please enter the otp"));
          }
        } on FirebaseAuthException catch (e) {
          emit(AuthError(message: e.message ?? "Invalid OTP"));
        }
      }
    });
    // on<VerifyOtpEvent>((event, emit) async {
    //   emit(AuthLoadingState());
    //   await Future.delayed(const Duration(seconds: 2));

    //   if (event.otp == "123456") {
    //     // Mock success
    //     emit(AuthVerifiedState());
    //   } else {
    //     // Mock failure
    //     emit(AuthErrorState(message: "Invalid OTP. Please try again."));
    //   }
    // });

    // Handler for resetting the flow
    on<ResetAuthEvent>((event, emit) {
      emit(AuthInitial());
    });

    on<GoogleSigninEvent>((event, emit) async {
      try {
        log("signing cservice called");
        final user = await authServices.signInWithGoogle();

        if (user != null) {
          final docRef = FirebaseFirestore.instance
              .collection("user")
              .doc(user.uid);
          final docSnap = await docRef.get();

          if (docSnap.exists) {
            log("User has account");
            final data = docSnap.data() as Map<String, dynamic>;

            if (data['isSetupProfile'] == true) {
              emit(AuthSuccessNavigateToHome());
            } else {
              emit(AuthSuccessNavigateToProfileSetup());
              //emit(AuthSuccessNavigateToHome());
            }
          } else {
            log("User has not account");
            await docRef.set({
              "email": user.email,
              "name": user.displayName,
              "createdAt": FieldValue.serverTimestamp(),
              "isSetupProfile": false,
            });
            emit(AuthSuccessNavigateToProfileSetup());
            // emit(AuthSuccessNavigateToHome());
          }
        } else {
          emit(AuthErrorState(message: "Login Failed"));
        }
      } catch (e) {
        emit(AuthErrorState(message: e.toString()));
      }
    });

    on<SignUpEvent>((event, emit) async {
      emit(AuthLoadingState());
      await Future.delayed(Duration(seconds: 2));
      try {
        final user = await authServices.createUserWithEmailAndPassword(
          event.email,
          event.password,
        );
        if (user != null) {
          final docRef = FirebaseFirestore.instance
              .collection("user")
              .doc(user.uid);
          final docSnap = await docRef.get();

          if (docSnap.exists) {
            log("User has account");
            final data = docSnap.data() as Map<String, dynamic>;

            if (data['isSetupProfile'] == true) {
              emit(AuthSuccessNavigateToHome());
            } else {
              emit(AuthSuccessNavigateToProfileSetup());
              //emit(AuthSuccessNavigateToHome());
            }
          } else {
            log("User has not account");
            await docRef.set({
              "email": user.email,
              "createdAt": FieldValue.serverTimestamp(),
              "isSetupProfile": false,
            });
            emit(AuthSuccessNavigateToProfileSetup());
            //emit(AuthSuccessNavigateToHome());
          }
        } else {
          emit(AuthErrorState(message: "SignUp Failed"));
        }
        //emit(AuthSuccessNavigateToHome());
      } on FirebaseAuthException catch (e) {
        log("Somthing wrong while Sign Up ${e.code}");
        emit(AuthErrorState(message: e.code));
      }
    });

    //Signin event
    on<SignInEvent>((event, emit) async {
      emit(AuthLoadingState());
      await Future.delayed(Duration(seconds: 2));
      try {
        final user = await authServices.signInUserWithEmailAndPassword(
          event.email,
          event.password,
        );
        if (user != null) {
          final docRef = FirebaseFirestore.instance
              .collection("user")
              .doc(user.uid);
          final docSnap = await docRef.get();

          if (docSnap.exists) {
            log("User has account");
            final data = docSnap.data() as Map<String, dynamic>;

            if (data['isSetupProfile'] == true) {
              emit(AuthSuccessNavigateToHome());
            } else {
              emit(AuthSuccessNavigateToProfileSetup());
              //emit(AuthSuccessNavigateToHome());
            }
          } else {
            log("User has not account");
            await docRef.set({
              "email": user.email,
              "name": user.displayName,
              "createdAt": FieldValue.serverTimestamp(),
              "isSetupProfile": false,
            });
            // emit(AuthSuccessNavigateToProfileSetup());
            emit(AuthSuccessNavigateToHome());
          }
        } else {
          emit(AuthErrorState(message: "Login Failed"));
        }
      } on FirebaseAuthException catch (e) {
        log("Somthing wrong while SignIn ${e.code}");
        emit(AuthErrorState(message: e.code));
      }
    });

    on<SignOutEvent>((event, emit) async {
      try {
        await authServices.signOut();
        emit(LogoutSuccessState());
      } catch (e) {
        log("Somthing wrong during signout $e");
        emit(AuthErrorState(message: e.toString()));
      }
    });
  }
}
