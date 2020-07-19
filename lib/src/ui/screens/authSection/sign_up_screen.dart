import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gifimage/flutter_gifimage.dart';

import '../../../../res.dart';
import 'bloc/authentication_bloc.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> with TickerProviderStateMixin {
  TextEditingController _emailController = TextEditingController();

  TextEditingController _passwordController = TextEditingController();

  TextEditingController _confirmPasswordController = TextEditingController();

  AuthenticationBloc _signUpBloc;

  GifController _gifController;
  AnimationController controller;

  @override
  void initState() {
    _signUpBloc = AuthenticationBloc();
    controller = AnimationController(vsync: this);
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
              if (state is AuthenticationLoading) {
                _gifController.value = 0;
                _gifController.repeat(min: 0, max: 23, period: Duration(milliseconds: 1000));
              }
              if (state is AuthenticationFailed) {
                _gifController.value = 23;
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text(
                    state.error,
                  ),
                ));
              }
              if (state is AuthenticationSuccessful) {
                _gifController.dispose();
                Navigator.pushReplacementNamed(context, '/homeScreen');
              }
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 100,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 25),
                      child: GifImage(
                        image: AssetImage(Res.loading_animation),
                        controller: _gifController,
                        height: 170,
                        width: 170,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    _entryField('Enter Email', controller: _emailController),
                    _entryField('Enter Password', isEmail: false, controller: _passwordController),
                    _entryField('Confirm Password', isEmail: false, controller: _confirmPasswordController),
                    Divider(
                      height: 20,
                      thickness: 3,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      child: FlatButton(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          color: Color.fromRGBO(140, 82, 255, 1),
                          onPressed: () {
//                            FirebaseAuth.instance.createUserWithEmailAndPassword(
//                                email: _emailController.text, password: _passwordController.text);
                            _signUpBloc.add(EmailSignUp(
                                _emailController.text, _passwordController.text, _confirmPasswordController.text));
                          },
                          child: Text(
                            'Become a Sociopath',
                            style: TextStyle(color: Colors.white),
                          )),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      child: FlatButton(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          onPressed: () => _signUpBloc.add(AuthorizationGoogleSignIn()),
                          child: Text(
                            'Become a Sociopath via Google',
                          )),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Already a Sociopath ? ',
                    ),
                    FlatButton(
                      onPressed: () => Navigator.pushReplacementNamed(context, '/signInScreen'),
                      child: Text(
                        'Log In',
                        style: TextStyle(color: Color.fromRGBO(140, 82, 255, 1)),
                      ),
                    )
                  ],
                )
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
          color: Theme.of(context).brightness == Brightness.light ? Colors.grey.shade400 : Colors.grey.shade900,
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
