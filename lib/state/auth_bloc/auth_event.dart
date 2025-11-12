part of 'auth_bloc.dart';

abstract class AuthEvent {}

class SendOtpEvent extends AuthEvent {
  final String phoneNumber;
  SendOtpEvent({required this.phoneNumber});
}

class VerifyOtpEvent extends AuthEvent {
  final String otp;
  VerifyOtpEvent({required this.otp});
}

class _OtpSentEvent extends AuthEvent {
  final String verificationId;
   final String phoneNumber;
  _OtpSentEvent({required this.verificationId,required this.phoneNumber});
}

// Event to go back to the phone input screen
class ResetAuthEvent extends AuthEvent {}

class GoogleSigninEvent extends AuthEvent{}

class  SignUpEvent extends AuthEvent{
  final String email;
  final String password;
  SignUpEvent({required this.email,required this.password});
}

class SignInEvent extends AuthEvent{
  final String email;
  final String password;
  SignInEvent({required this.email,required this.password});
}
class CheckLoginStatusEvent extends AuthEvent{}

class SignOutEvent extends AuthEvent{}