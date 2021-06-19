import 'package:flutter/material.dart';
import 'package:wakalati_redal/Authentication/authentication.dart';
import 'package:wakalati_redal/Pages/user_home.dart';
import 'package:wakalati_redal/SignUp/signup_screen.dart';
import 'package:wakalati_redal/SignUp/signup_service_database.dart';
import '../constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget{
  LoginScreen({Key key}): super(key: key);
  @override
  _LoginScreen createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen>{

  bool _isHidden = true;
  final FirebaseAuth auth = FirebaseAuth.instance;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController pwdController   = TextEditingController();

  SingUpDataBase userInformations;

  @override
  Widget build(BuildContext context){
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        color: Colors.white,
        width: double.infinity,
        height: size.height,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: size.height*0.04,),
                  Text(
                    "LOGIN",
                    style: TextStyle(fontWeight: FontWeight.bold, color: kPrimaryColor, fontSize: 18),
                  ),
                  //SizedBox(height: size.height*0.03,),
                  Image.asset(
                    'assets/icons/logo_redal.png',
                    height: size.height * 0.37,
                    width: size.width*0.7,
                  ),
                  buildTextField(
                      "Email",
                      Icons.email
                  ),
                  Container(
                    width: size.width*0.8,
                    height: size.height*0.06,
                    margin: EdgeInsets.symmetric(vertical: 10),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    decoration: BoxDecoration(
                        color: Color.fromARGB(30,15,15,1),
                        borderRadius: BorderRadius.circular(29)
                    ),
                    child: buildPasswordField(),
                  ),
                  Container(
                    width: size.width*0.8,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        GestureDetector(
                          onTap: (){
                            //Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
                          },
                          child: Text(
                            "Forgotten Password?",
                            style: TextStyle(
                              color: kPrimaryColor,
                              //fontWeight: FontWeight.bold
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    // get:^3.15.0
                    margin: EdgeInsets.symmetric(vertical: 10),
                    width: size.width * 0.8,
                    height: size.height*0.058,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(29),
                      child: FlatButton(
                        padding: EdgeInsets.symmetric(vertical: 17, horizontal: 40),
                        color: kPrimaryColor,
                        onPressed: () async {
                          User user = await Authentication.signInWithEmailAndPassword(context: context, email: emailController.text, password: pwdController.text);
                          if (user != null) {
                            print(user.toString());
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => UserHome(
                                  user: user,
                                ),
                              ),
                            );
                          }
                        },
                        child: Text(
                          "LOGIN",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: size.width*0.8,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          "Don't have an account?  ",
                          style: TextStyle(color: kPrimaryColor),
                        ),
                        GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>SignUpScreen()));
                          },
                          child: Text(
                            "SIGN UP",
                            style: TextStyle(
                              color: kPrimaryColor,
                              // fontWeight: FontWeight.bold
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: size.height * 0.02),
                    width: size.width * 0.8,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            child: Divider(
                              color: kPrimaryColor,
                              height: 1.5,
                            )
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            "OR",
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Expanded(
                            child: Divider(
                              color: kPrimaryColor,
                              height: 1.5,
                            )
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: size.height * 0.02),
                    width: size.width * 0.8,
                    height: size.width * 0.15,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SocialIcon(
                          press: (){
                            print("Hello");
                          },
                          pathIcon: "assets/icons/facebook.png",
                        ),
                        SocialIcon(
                          press: (){
                            print("Hello");
                          },
                          pathIcon: "assets/icons/twitter.png",
                        ),
                        SocialIcon(
                          press: () async {
                            User user = await Authentication.signInWithGoogle(context: context);
                            if (user != null) {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => UserHome(
                                    user: user,
                                  ),
                                ),
                              );
                            }
                          },
                          pathIcon: "assets/icons/google-plus.png",
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildTextField(String text, IconData icon){//, TextInputType textInputType
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width*0.8,
      height: size.height*0.06,
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: BoxDecoration(
          color: Color.fromARGB(30,15,15,1),
          borderRadius: BorderRadius.circular(29)
      ),
      child: TextFormField(
        //onChanged: ,
        controller: emailController,
        decoration: InputDecoration(
            hintText: text,
            icon: Icon(icon, color: kPrimaryColor,),
            border: InputBorder.none
        ),
      ),
    );
  }

  Widget buildPasswordField(){
    Size size = MediaQuery.of(context).size;
    return TextFormField(
      controller: pwdController,
      obscureText: _isHidden,
      decoration: InputDecoration(
          hintText: "Password",
          icon: Icon(
            Icons.lock,
            color: kPrimaryColor,
          ),
          border: InputBorder.none,
          suffixIcon: IconButton(
            key: UniqueKey(),
            icon: Icon(
              _isHidden ? Icons.visibility_off: Icons.visibility,
              color: kPrimaryColor,
            ),
            onPressed: (){
              setState(() {
                _isHidden = !_isHidden;
              });
            },
          )
      ),
    );
  }

  Widget buildButtonContainer(){
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      width: size.width * 0.8,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(29),
        child: FlatButton(
          padding: EdgeInsets.symmetric(vertical: 17, horizontal: 40),
          color: kPrimaryColor,
          onPressed: (){},
          child: Text(
            "Sign Up",
            style: TextStyle(color: Colors.white ),
          ),
        ),
      ),
    );
  }
}