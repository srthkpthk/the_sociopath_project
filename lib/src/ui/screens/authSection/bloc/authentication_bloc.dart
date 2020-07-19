import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';
import 'package:the_sociopath_project/src/helpers/auth_excpetionHelpers.dart';

part 'authentication_event.dart';

part 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc() : super(AuthenticationInitial());
  final _emailRegex = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is EmailSignUp) {
      yield AuthenticationLoading();
      if (event.email.isNotEmpty) {
        if (event.password.isNotEmpty && event.confirmPassword.isNotEmpty) {
          if (event.password == event.confirmPassword) {
            if (_emailRegex.hasMatch(event.email)) {
              if (event.password.length > 5) {
                try {
                  print(event.email);
                  print(event.password);
                  AuthResult _res =
                      await _auth.createUserWithEmailAndPassword(email: event.email, password: event.password);
                  if (_res != null) {
                    yield AuthenticationSuccessful();
                  } else {
                    yield AuthenticationFailed('Error From Server Side');
                  }
                } catch (e) {
                  yield AuthenticationFailed(
                      AuthExceptionHandler.generateExceptionMessage(AuthExceptionHandler.handleException(e)));
                }
              } else {
                yield AuthenticationFailed('Please check your password');
              }
            } else {
              yield AuthenticationFailed('Please Check your Email');
            }
          } else {
            yield AuthenticationFailed('Password and Confirm Password Don\'t Match');
          }
        } else {
          yield AuthenticationFailed('Password or Confirm Password is Empty');
        }
      } else {
        yield AuthenticationFailed('Email is Empty');
      }
    }
    if (event is AuthorizationGoogleSignIn) {
      yield AuthenticationLoading();
      FirebaseUser _user = await _handleSignIn();
      if (_user != null) {
        yield AuthenticationSuccessful();
      } else {
        yield AuthenticationFailed('Google Sign in Failed. It rarely happens but you are a proof it happened');
      }
    }
    if (event is EmailSignIn) {
      yield AuthenticationLoading();
      if (event.email.isNotEmpty) {
        if (event.password.isNotEmpty) {
          if (_emailRegex.hasMatch(event.email)) {
            if (event.password.length > 5) {
              try {
                AuthResult _res = await _auth.signInWithEmailAndPassword(email: event.email, password: event.password);
                if (_res != null) {
                    yield AuthenticationSuccessful();
                } else {
                  yield AuthenticationFailed('Server Side Error');
                }
              } catch (e) {
                yield AuthenticationFailed(
                    AuthExceptionHandler.generateExceptionMessage(AuthExceptionHandler.handleException(e)));
              }
            } else {
              yield AuthenticationFailed('Please check your password');
            }
          } else {
            yield AuthenticationFailed('Please Check your Email');
          }
        } else {
          yield AuthenticationFailed('Password is Empty');
        }
      } else {
        yield AuthenticationFailed('Email is Empty');
      }
    }
    if (event is ChangePassword) {
      yield AuthenticationLoading();
      if (event.email.isNotEmpty) {
        try {
          await _auth.sendPasswordResetEmail(email: event.email);
          yield AuthenticationSuccessful();
        } catch (e) {
          yield AuthenticationFailed('User does not Exists');
        }
      }
    }
  }

  Future<FirebaseUser> _handleSignIn() async {
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
    print("signed in " + user.displayName);
    return user;
  }
}
