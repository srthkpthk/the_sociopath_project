import 'package:flutter/material.dart';
import 'package:the_sociopath_project/src/ui/screens/homeScreen/home_screen.dart';
import 'package:the_sociopath_project/src/ui/screens/signUpScreen/sign_up_screen.dart';
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
      routes: {
        '/splashScreen': (context) => SplashScreen(),
        '/signUpScreen': (context) => SignUpScreen(),
        '/homeScreen': (context) => HomeScreen(),
      },
    );
  }
}
