import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Welcome/welcome_screen.dart';
import 'constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //Size size = MediaQuery.of(context).size;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Wakalati Redal',
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        scaffoldBackgroundColor:
        Colors.white,
      ),
      home: AnimatedSplashScreen(
        splash: Image.asset(
          "assets/icons/logo_redal.png",
        ),
        nextScreen: WelcomeScreen(),
        splashTransition: SplashTransition.scaleTransition,
        duration: 1000,
      ),
    );
  }
}