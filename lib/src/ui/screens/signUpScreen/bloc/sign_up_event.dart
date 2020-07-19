part of 'sign_up_bloc.dart';

@immutable
abstract class SignUpEvent {}

class EmailSignIn extends SignUpEvent {
  String email, password;

  EmailSignIn(this.email, this.password);
}

class GoogleSignIn extends SignUpEvent {}

