import 'package:flutter/material.dart';
import 'package:wakalati_redal/Authentication/authentication.dart';
import './components/body.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Authentication.initializeFirebase(context: context);
    return Scaffold(
      body: Body(),
    );
  }
}
