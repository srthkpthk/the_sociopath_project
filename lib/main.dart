import 'package:flutter/material.dart';
import 'package:the_sociopath_project/src/ui/screens/authSection/forgot_password_screen.dart';
import 'package:the_sociopath_project/src/ui/screens/authSection/sign_in_screen.dart';
import 'package:the_sociopath_project/src/ui/screens/authSection/sign_up_screen.dart';
import 'package:the_sociopath_project/src/ui/screens/homeScreen/home_screen.dart';
import 'package:the_sociopath_project/src/ui/screens/splashScreen/splash_screen.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Sociopath Project',
      debugShowCheckedModeBanner: false,
      initialRoute: '/splashScreen',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      routes: {
        '/splashScreen': (context) => SplashScreen(),
        '/signUpScreen': (context) => SignUpScreen(),
        '/homeScreen': (context) => HomeScreen(),
        '/signInScreen': (context) => SignInScreen(),
        '/forgotPasswordScreen': (context) => ForgotPasswordScreen(),
      },
    );
  }
}
