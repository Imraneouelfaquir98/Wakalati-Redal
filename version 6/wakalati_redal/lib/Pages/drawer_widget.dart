import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wakalati_redal/Authentication/authentication.dart';
import 'package:wakalati_redal/Pages/UserProfile/user_profile.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wakalati_redal/constants.dart';

class DrawerWidget extends StatelessWidget {

  User user;

  DrawerWidget({
    Key key,
    this.user
  }) : super(key: key);

  String phone, whatsapp, email, facebook, instagram, website;

  void setContacts(){
    FirebaseFirestore.instance
        .collection("contacts").get().then(
            (QuerySnapshot snapshot) {
          phone     = snapshot.docs.first.data()["phone"];
          whatsapp  = snapshot.docs.first.data()["whatsapp"];
          email     = snapshot.docs.first.data()["email"];
          facebook  = snapshot.docs.first.data()["facebook"];
          instagram = snapshot.docs.first.data()["instagram"];
          website   = snapshot.docs.first.data()["website"];
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    setContacts();
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              children: <Widget>[
                SizedBox(height: size.height*0.02,),
                Image.asset(
                  "assets/images/background_image.png",
                  width: size.width*0.27,
                ),
                SizedBox(height: size.height*0.01,),
                Container(
                  height: 20,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      FutureBuilder(
                        future: FirebaseFirestore.instance.collection('users').doc(user.uid).get(),
                        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot){
                          if (snapshot.hasData) {
                            Map<String, dynamic> data = snapshot.data.data();
                            return Text(
                              "${data['name']} ",
                              style: TextStyle(color: kPrimaryColor,fontSize: 15),
                            );
                          }
                          else if (snapshot.hasError)
                            return Text(
                              "error",
                              style: TextStyle(fontSize: 15,color: kPrimaryColor,),
                            );
                          else
                            return SizedBox(
                              child: LinearProgressIndicator(),
                              width: 140,
                              height: 5,
                            );
                        },
                      ),
                      Text(
                        " | Wakalati Redal",
                        style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: 14,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.account_circle,
              color: kPrimaryColor,
              size: size.width*0.07,
            ),
            title: Text('Mon Profile'),
            onTap: (){
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => UserProfile(user: user)));
            },
          ),
          Divider(color: Color(0xFFD9D9D9), height: 0,),
          ListTile(
            title: Text(
              'WAKALATI Redal',
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 15.5
              ),
            ),
          ),
          ListTile(
            leading: Tab(
              icon: Image.asset("assets/icons/logo_redal.png", width: size.width*0.09,),
            ),
            title: Text('A propos WAKALATI Redal'),
          ),
          ListTile(
            leading: Icon(
              Icons.eco,
              color: kPrimaryColor,
              size: size.width*0.07,
            ),
            title: Text('Nos services'),
          ),
          Divider(color: Color(0xFFD9D9D9), height: 0,),
          ListTile(
            title: Text(
              'CONTACTEZ NOUS',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 15.5,
              ),
            ),
          ),
          ListTile(
            leading: Tab(
              icon: Image.asset("assets/icons/whatsapp.png", width: size.width*0.08,),
            ),
            title: Text('Whatsapp'),
            onTap: ()async {
              String message = "Dear admin, i am from Wakalati Redal.\n";
              String url = "whatsapp://send?phone=$whatsapp&text=$message";
              await canLaunch(url)?launch(url):print("error");
            },
          ),
          ListTile(
            leading: Icon(
              Icons.email,
              color: kPrimaryColor,
              size: size.width*0.07,
            ),
            title: Text('E-mail'),
            onTap: ()async {
              String url = "mailto:$email?subject=Wakalati Redal&body=Hello every one";
              await canLaunch(url)?launch(url):print("error");
            },
          ),
          ListTile(
            leading: Icon(
              Icons.message,
              color: kPrimaryColor,
              size: size.width*0.07,
            ),
            title: Text('Message'),
            onTap: ()async {
              String url = "sms:$phone";
              await canLaunch(url)?launch(url):print("error");
            },
          ),
          ListTile(
            leading: Icon(
              Icons.call,
              color: kPrimaryColor,
              size: size.width*0.07,
            ),
            title: Text('Appelez nous'),
            onTap: ()async {
              String url = "tel:$phone";
              await canLaunch(url)?launch(url):print("error");
            },
          ),
          Divider(color: Color(0xFFD9D9D9), height: 0,),
          ListTile(
            title: Text(
              'SUIVEZ NOUS',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 15.5,
              ),
            ),
          ),
          ListTile(
            leading: Image.asset("assets/icons/facebook_blue.png", width: size.width*0.072,),
            title: Text('Facebook'),
            onTap: ()async {
              await canLaunch(facebook)?launch(facebook):print("error");
            },
          ),
          ListTile(
            leading: Image.asset("assets/icons/instagram.png", width: size.width*0.072,),
            title: Text('Instagram'),
            onTap: ()async {
              await canLaunch(instagram)?launch(instagram):print("error");
            },
          ),
          ListTile(
            leading: Icon(
              Icons.web,
              color: kPrimaryColor,
              size: size.width*0.07,
            ),
            title: Text('Notre site web'),
            onTap: ()async {
              await canLaunch(website)?launch(website):print("error");
            },
          ),
          Divider(color: Color(0xFFD9D9D9), height: 0,),
          ListTile(
            title: Text(
              'AUTRE',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 15.5,
              ),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.settings,
              color: kPrimaryColor,
              size: size.width*0.07,
            ),
            title: Text('Setting'),
          ),
          ListTile(
            leading: Icon(
              Icons.logout,
              color: kPrimaryColor,
              size: size.width*0.07,
            ),
            title: Text('Log Out'),
            onTap: (){
              Authentication.signOut(context: context);
              //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => WelcomeScreen()));
            },
          ),
        ],
      ),
    );
  }
}