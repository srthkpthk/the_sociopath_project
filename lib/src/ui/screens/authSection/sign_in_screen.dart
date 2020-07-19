import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gifimage/flutter_gifimage.dart';
import 'package:the_sociopath_project/src/ui/screens/authSection/bloc/authentication_bloc.dart';

import '../../../../res.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> with TickerProviderStateMixin {
  TextEditingController _emailController = TextEditingController();

  TextEditingController _passwordController = TextEditingController();

  AuthenticationBloc _bloc;

  GifController _gifController;

  @override
  void initState() {
    _bloc = AuthenticationBloc();
    _gifController = GifController(vsync: this);
    _gifController.value = 23;
    super.initState();
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Center(
          child: BlocListener(
            bloc: _bloc,
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
                        )),
                    SizedBox(
                      height: 30,
                    ),
                    _entryField('Enter Email', controller: _emailController),
                    _entryField('Enter Password', isEmail: false, controller: _passwordController),
                    Align(
                      alignment: Alignment.centerRight,
                      child: FlatButton(
                          onPressed: () => Navigator.pushNamed(context, '/forgotPasswordScreen'),
                          child: Text(
                            'Forgot Password? it\'s ok',
                          )),
                    ),
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
                          onPressed: () => _bloc.add(EmailSignIn(_emailController.text, _passwordController.text)),
                          child: Text(
                            'Enter The Sociopath ',
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
                          onPressed: () => _bloc.add(AuthorizationGoogleSignIn()),
                          child: Text(
                            'Enter The Sociopath via Google',
                          )),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Not a Sociopath ? It\'s weird',
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
