part of 'sign_up_bloc.dart';

@immutable
abstract class SignUpState {}

class SignUpInitial extends SignUpState {}

class SignInSuccessful extends SignUpState {}

class SignInLoading extends SignUpState {}

class SignInError extends SignUpState {
  String error;

  SignInError(this.error);
}
