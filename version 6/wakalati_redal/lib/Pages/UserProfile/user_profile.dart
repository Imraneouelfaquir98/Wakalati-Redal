import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:wakalati_redal/Pages/user_home.dart';
import 'package:wakalati_redal/constants.dart';
import 'components/personal_informations.dart';

class UserProfile extends StatefulWidget {

  final User user;

  const UserProfile({
    Key key,
    @required this.user
  }) : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color.fromARGB(1020, 245, 247, 246),
      appBar: buildAppBar(size),
      body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                Row(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(left: 10, bottom: 5),
                        child: Text(
                          "Information personelle",
                          style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 15,),
                        ),
                      ),
                    ]
                ),
                FutureBuilder(
                    future: FirebaseFirestore.instance.collection('users').doc(widget.user.uid).get(),
                    builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot){
                      if(snapshot.hasData){
                        Map<String, dynamic> data = snapshot.data.data();
                        return PersonalInformation(
                          size: size,
                          user: widget.user,
                          name: data['name'],
                          phone: data['phone'],
                          email: widget.user.email,
                          address: data['address'],
                        );
                      }
                      else if (snapshot.hasError) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const Icon(
                              Icons.error_outline,
                              color: Colors.red,
                              size: 60,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 16),
                              child: Text('Error: ${snapshot.error}'),
                            )
                          ],
                        );
                      }
                      else {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              child: CircularProgressIndicator(),
                              width: 100,
                              height: 100,
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 16),
                              child: Text('Wait Please'),
                            )
                          ],
                        );
                      }
                    }
                ),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 10, bottom: 5, top: 10),
                      child: Text(
                        "Mes actions",
                        style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    )
                  ],
                ),
                Container(
                  width: size.width,
                  height: size.width*0.5,
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(5.0),
                  child: Text("Mes actions", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 20,),),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                ),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 10, bottom: 5, top: 10),
                      child: Text(
                        "Historique de mes services",
                        style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ),
                  ],
                ),
                Container(
                  width: size.width,
                  height: size.width*0.5,
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(5.0),
                  child: Text("Historique de mes services", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 20,),),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          )
      ),
    );
  }

  AppBar buildAppBar(Size size) {
    return AppBar(
      backgroundColor: Colors.white,
      leading: Builder(
        builder: (BuildContext context) {
          return IconButton(
            icon: Icon(
              Icons.arrow_back_outlined,
              color: kPrimaryColor,
              size: size.width*0.08,
            ),
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => UserHome(user: widget.user)));
            },
            tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
          );
        },
      ),
      title: FutureBuilder(
        future: FirebaseFirestore.instance.collection('users').doc(widget.user.uid).get(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot){
          if (snapshot.hasData) {
            Map<String, dynamic> data = snapshot.data.data();
            return Text(
              "${data['name']} ",
              style: TextStyle(color: kPrimaryColor, fontSize: 15),
            );
          }
          else if (snapshot.hasError)
            return Text(
              "error",
              style: TextStyle(color: kPrimaryColor, fontSize: 15),
            );
          else
            return SizedBox(
              child: LinearProgressIndicator(),
              width: 140,
              height: 5,
            );
        },
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.notifications,
            color: kPrimaryColor,
            size: size.width*0.08,
          ),
        ),
      ],
    );
  }
}
