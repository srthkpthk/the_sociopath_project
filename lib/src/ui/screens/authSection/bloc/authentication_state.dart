part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationState {}

class AuthenticationInitial extends AuthenticationState {}

class AuthenticationLoading extends AuthenticationState {}

class AuthenticationSuccessful extends AuthenticationState {}

class AuthenticationFailed extends AuthenticationState {
  String error;

  AuthenticationFailed(this.error);
}
