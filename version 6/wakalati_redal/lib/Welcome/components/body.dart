import 'package:flutter/material.dart';
import 'package:wakalati_redal/Authentication/authentication.dart';
import 'package:wakalati_redal/Login/login_screen.dart';
import 'package:wakalati_redal/SignUp/signup_screen.dart';
import 'package:wakalati_redal/Welcome/components/background.dart';
import 'package:wakalati_redal/Welcome/components/rounded_button.dart';
import 'package:wakalati_redal/constants.dart';


class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
        child: SingleChildScrollView(
            child: FutureBuilder(
              future: Authentication.initializeFirebase(context: context),
              builder: (context, snapshot){
                if (snapshot.hasError) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Error initializing"),
                        content: Text("Error initializing"),
                        elevation: 24.0,
                      );
                    },
                  );
                } else if (snapshot.connectionState == ConnectionState.done) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Bienvenue a",
                        style: TextStyle(fontWeight: FontWeight.bold, color: kPrimaryColor, fontSize: 18),
                      ),
                      Text(
                        "à Wakalati Redal",
                        style: TextStyle(fontWeight: FontWeight.bold, color: kPrimaryColor, fontSize: 18),
                      ),
                      Image.asset(
                        'assets/icons/logo_redal.png',
                        height: size.height * 0.45,
                        width: size.width*0.7,
                      ),
                      RoundedButton(
                          text:"LOGIN",
                          press:(){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
                          }
                      ),
                      RoundedButton(
                          text:"SIGN UP",
                          color: kPrimaryLightColor,
                          textColor: Colors.white,
                          press:(){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>SignUpScreen()));
                          }
                      ),
                    ],
                  );
                }
                else if (snapshot.connectionState == ConnectionState.waiting || snapshot.connectionState == ConnectionState.none) {
                  return Container(
                    width: size.width*0.4,
                    height: size.width*0.4,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                      strokeWidth: 10,
                    ),
                  );
                }
                return Container(
                  width: size.width*0.4,
                  height: size.width*0.4,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                    strokeWidth: 10,
                  ),
                );
              },
            )
        )
    );
  }
}

