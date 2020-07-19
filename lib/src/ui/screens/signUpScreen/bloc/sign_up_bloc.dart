import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:the_sociopath_project/src/data/repository/firebase_repository.dart';

part 'sign_up_event.dart';

part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc() : super(SignUpInitial());
  final _repo = FirebaseRepository();
  final _emailRegex = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  final _passwordRegex = RegExp(r"^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[*.!@$%^&(){}[]:;<>,.?/~_+-=|\]).{8,32}$");

  @override
  void onTransition(Transition<SignUpEvent, SignUpState> transition) {
    print(transition.currentState);
    super.onTransition(transition);
  }

  @override
  Stream<SignUpState> mapEventToState(
    SignUpEvent event,
  ) async* {
    if (event is EmailSignIn) {
      yield SignInLoading();
      if (_emailRegex.hasMatch(event.email) && _passwordRegex.hasMatch(event.password)) {
        AuthResult _res = await _repo.emailAndPasswordRegister(event.email, event.password);
        if (_res != null) {
          yield SignInSuccessful();
        } else {
          yield SignInError('Error From Server Side');
        }
      } else {
        yield SignInError('Please Double Check the Email and Password');
      }
    }
  }
}
