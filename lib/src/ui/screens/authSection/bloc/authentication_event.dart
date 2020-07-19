part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationEvent {}

class EmailSignUp extends AuthenticationEvent {
  String email, password, confirmPassword;

  EmailSignUp(this.email, this.password, this.confirmPassword);
}

class ChangePassword extends AuthenticationEvent {
  String email;

  ChangePassword(this.email);
}

class EmailSignIn extends AuthenticationEvent {
  String email, password;

  EmailSignIn(this.email, this.password);
}

class AuthorizationGoogleSignIn extends AuthenticationEvent {}
