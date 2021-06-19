import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:wakalati_redal/Authentication/authentication.dart';
import 'package:wakalati_redal/Login/login_screen.dart';
import 'package:wakalati_redal/Pages/user_home.dart';
import 'package:wakalati_redal/constants.dart';
import '../constants.dart';
import 'signup_service_database.dart';

class SignUpScreen extends StatefulWidget{
  SignUpScreen({Key key}): super(key: key);
  @override
  _SignUpScreen createState() => _SignUpScreen();
}

class _SignUpScreen extends State<SignUpScreen>{

  bool _isHidden1 = true;
  bool _isHidden2 = true;

  SingUpDataBase userInformations;

  final TextEditingController emailController   = TextEditingController();
  final TextEditingController pwdController1    = TextEditingController();
  final TextEditingController pwdController2    = TextEditingController();
  final TextEditingController nameController    = TextEditingController();
  final TextEditingController phoneController   = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  final FirebaseAuth auth = FirebaseAuth.instance;

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
                    "SIGN UP",
                    style: TextStyle(fontWeight: FontWeight.bold, color: kPrimaryColor),
                  ),
                  //SizedBox(height: size.height*0.03,),
                  Image.asset(
                    'assets/icons/logo_redal.png',
                    height: size.height * 0.34,
                    width: size.width*0.7,
                  ),
                  buildTextField(
                      "Name",
                      Icons.person,
                      TextInputType.text,
                      nameController
                  ),
                  buildTextField(
                      "Phone",
                      Icons.phone,
                      TextInputType.number,
                      phoneController
                  ),
                  buildTextField(
                      "Address",
                      Icons.location_on,
                      TextInputType.text,
                      addressController
                  ),

                  buildTextField(
                      "Email",
                      Icons.email,
                      TextInputType.text,
                      emailController
                  ),
                  buildPasswordField("Password", pwdController1, 1),
                  buildPasswordField("Confirm password", pwdController2, 2),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    width: size.width * 0.8,
                    height: size.height*0.055,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(29),
                      child: FlatButton(
                        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 40),
                        color: kPrimaryColor,
                        onPressed: () async {
                          if(pwdController1.text == pwdController2.text){
                            User user = await Authentication.createUserWithEmailAndPassword(
                                context: context,
                                email: emailController.text,
                                password: pwdController1.text,
                                name: nameController.text,
                                phone: phoneController.text,
                                address: addressController.text
                            );
                            if (user != null) {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => UserHome(
                                    user: user,
                                  ),
                                ),
                              );
                            }
                          }
                          else{
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Les mots de passe ne correspondent pas. Réessayez."),
                                  elevation: 24.0,
                                );
                              },
                            );
                          }
                        },
                        child: Text(
                          "SIGN UP",
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
                          "Do you have an account?  ",
                          style: TextStyle(color: kPrimaryColor),
                        ),
                        GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
                          },
                          child: Text(
                            "LOGIN",
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
                              color: Color(0xFFD9D9D9),
                              height: 1.5,
                            )
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            "OR",
                            style: TextStyle(
                              color: kPrimaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Expanded(
                            child: Divider(
                              color: Color(0xFFD9D9D9),
                              height: 1.5,
                            )
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: size.height * 0.002),
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

  Widget buildTextField(String text, IconData icon, TextInputType textInputType, TextEditingController controller){
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width*0.8,
      height: size.height*0.055,
      margin: EdgeInsets.symmetric(vertical: 7),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      decoration: BoxDecoration(
          color: Color.fromARGB(30,15,15,1),
          borderRadius: BorderRadius.circular(29)
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: textInputType,
        decoration: InputDecoration(
            hintText: text,
            icon: Icon(icon, color: kPrimaryColor,),
            border: InputBorder.none
        ),
      ),
    );
  }

  Widget buildPasswordField(String text, TextEditingController controller, int index){
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width*0.8,
      height: size.height*0.055,
      margin: EdgeInsets.symmetric(vertical: 7),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      decoration: BoxDecoration(
          color: Color.fromARGB(30,15,15,1),
          borderRadius: BorderRadius.circular(29)
      ),
      child: TextFormField(
        obscureText: (index == 1)?_isHidden1:_isHidden2,
        decoration: InputDecoration(
            hintText: text,
            icon: Icon(
              Icons.lock,
              color: kPrimaryColor,
            ),
            border: InputBorder.none,
            suffixIcon: IconButton(
              key: UniqueKey(),
              icon: visibilityIcon(index),
              onPressed: (){
                setState(() {
                  if(index == 1)
                    _isHidden1 = !_isHidden1;
                  else
                    _isHidden2 = !_isHidden2;
                });
              },
            )
        ),
        controller: controller,
      ),
    );
  }

  Icon visibilityIcon(int index) {
    if(index == 1){
      return Icon(
        _isHidden1 ? Icons.visibility_off: Icons.visibility,
        color: kPrimaryColor,
      );
    }
    else{
      return Icon(
        _isHidden2 ? Icons.visibility_off: Icons.visibility,
        color: kPrimaryColor,
      );
    }
  }

}

class SocialIcon extends StatelessWidget {
  final Function press;
  final String pathIcon;
  const SocialIcon({
    Key key,
    this.press,
    this.pathIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        press();
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Color.fromARGB(15,15,15,1),
          border: Border.all(
            width: 2,
            color: Color.fromARGB(15,15,15,1),
          ),
          shape: BoxShape.circle,
        ),
        child: Image.asset(
          pathIcon,
          height: 40,
          width: 40,
        ),
      ),
    );
  }
}