import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gifimage/flutter_gifimage.dart';
import 'package:social_signin_buttons/social_signin_buttons.dart';

import '../../../../res.dart';
import 'bloc/sign_up_bloc.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> with TickerProviderStateMixin {
  TextEditingController _emailController = TextEditingController();

  TextEditingController _passwordController = TextEditingController();

  TextEditingController _confirmPasswordController = TextEditingController();

  SignUpBloc _signUpBloc;

  GifController _gifController;

  @override
  void initState() {
    _signUpBloc = SignUpBloc();
    _gifController = GifController(vsync: this);
    _gifController.value = 23;
    super.initState();
  }

  @override
  void dispose() {
    _signUpBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Center(
          child: BlocListener(
            bloc: _signUpBloc,
            listener: (BuildContext context, state) {
              if (state is SignInLoading) {
                _gifController.value = 0;
                _gifController.repeat(min: 0, max: 23, period: Duration(milliseconds: 1000));
              }
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                    padding: const EdgeInsets.only(left: 25),
                    child: GifImage(
                      image: AssetImage(Res.loading_animation),
                      controller: _gifController,
                      height: 170,
                      width: 170,
                    )),
                SizedBox(
                  height: 30,
                ),
                _entryField('Enter Email', controller: _emailController),
                _entryField('Enter Password', isEmail: false, controller: _passwordController),
                _entryField('Confirm Password', isEmail: false, controller: _confirmPasswordController),
                Divider(
                  height: 40,
                ),
                FlatButton(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    color: Colors.grey.shade300,
                    onPressed: () => _signUpBloc.add(EmailSignIn(_emailController.text, _passwordController.text)),
                    child: Text('Become a Sociopath')),
                SizedBox(
                  height: 30,
                ),
                SignInButton(Buttons.Google, onPressed: () => _signUpBloc.add(GoogleSignIn()))
              ],
            ),
          ),
        ),
      ),
    );
  }

  _entryField(String hint, {TextEditingController controller, bool isEmail = true}) => Container(
        margin: EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(20),
        ),
        child: TextField(
          controller: controller,
          keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
          style: TextStyle(
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.normal,
          ),
          obscureText: !isEmail,
          decoration: InputDecoration(
            hintText: hint,
            border: InputBorder.none,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(20.0),
              ),
              borderSide: BorderSide(color: Colors.blue),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          ),
        ),
      );
}
