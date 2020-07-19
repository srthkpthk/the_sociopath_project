import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gifimage/flutter_gifimage.dart';

import '../../../../res.dart';
import 'bloc/authentication_bloc.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> with TickerProviderStateMixin {
  TextEditingController _emailController = TextEditingController();

  AuthenticationBloc _signUpBloc;

  GifController _gifController;

  @override
  void initState() {
    _signUpBloc = AuthenticationBloc();
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
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text('A Password resetting link has been sent to your email ', style: TextStyle()),
                ));
                Future.delayed(Duration(seconds: 2), () => Navigator.pushReplacementNamed(context, '/signInScreen'));
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
                        )),
                    SizedBox(
                      height: 30,
                    ),
                    _entryField('Enter Email', controller: _emailController),
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
                          onPressed: () => _signUpBloc.add(ChangePassword(_emailController.text)),
                          child: Text(
                            'Change Sociopath\'s Mind Password',
                            style: TextStyle(color: Colors.white),
                          )),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
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
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'Not a Sociopath ? Weird ',
                        ),
                        FlatButton(
                          onPressed: () => Navigator.pushReplacementNamed(context, '/signUpScreen'),
                          child: Text(
                            'Become one',
                            style: TextStyle(color: Color.fromRGBO(140, 82, 255, 1)),
                          ),
                        )
                      ],
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
