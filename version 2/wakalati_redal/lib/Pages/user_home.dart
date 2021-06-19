import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:wakalati_redal/Pages/agents.dart';
import 'package:wakalati_redal/constants.dart';
import 'agent_screen.dart';
import 'drawer_widget.dart';
import 'package:requests/requests.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

class UserHome extends StatefulWidget {

  final User user;

  const UserHome({
    Key key,
    @required this.user
  }) : super(key: key);

  @override
  _UserHomeState createState() => _UserHomeState();

}

class _UserHomeState extends State<UserHome> {

  Future<DocumentSnapshot> userDocument;

  _UserHomeState() {
    userDocument = Future<DocumentSnapshot>.delayed(
      const Duration(seconds: 2),
          () => FirebaseFirestore.instance
          .collection("users").doc(widget.user.uid).get(),
    );
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Colors.white,
            leading: Builder(
              builder: (BuildContext context) {
                return IconButton(
                  icon: Icon(
                    Icons.menu,
                    color: kPrimaryColor,
                    size: size.width*0.08,
                  ),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
                );
              },
            ),
            pinned: true,
            snap: false,
            floating: false,
            expandedHeight: 180.0,
            flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  'Wakalati Redal',
                  style: TextStyle(color: kPrimaryColor, fontSize: 20),
                ),
                background: Container(
                  child: Image.asset("assets/images/background_image.png",),
                )
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
          ),
          SliverFixedExtentList(
            itemExtent: 180.0,
            delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                return Column(
                  children: <Widget>[
                    SizedBox(height: 15,),
                    Container(
                        width: size.width*0.95,
                        height: size.width*0.40,
                        alignment: Alignment.topLeft,
                        decoration: new BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          shape: BoxShape.rectangle,
                          color: Colors.white,
                        ),
                        //child: Text('   Impact', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 16),),
                        child: GestureDetector(
                          child: Column(
                            children: <Widget>[
                              Container(
                                height: 24,
                                alignment: Alignment.bottomLeft,
                                child: Text('    ${agents[index].title}', style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold, fontSize: 16),),
                              ),
                              Container(
                                width: size.width*0.55,
                                child: Image.asset(agents[index].image),
                              )
                            ],
                          ),
                          onTap: () async {
                            print(agents[index].title);

                            var position = _determinePosition().then((value) {
                              print("latitude : ${value.latitude}, longitude : ${value.longitude}");
                              Navigator.of(context)
                                  .push(
                                  MaterialPageRoute(
                                      builder: (context) => AgentScreen(
                                        user: widget.user,
                                        nameAgent : agents[index].title,
                                        position: value,
                                      )
                                  )
                              );
                            });
                            //34.5424967,-4.6398431
                            String url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=33.986288, -6.856819&radius=15000&type=${agents[index].title}&keyword=${agents[index].title}&key=$mapKey";
                            var res = await Requests.get(url);
                            //print(res.content());
                            Map<String, dynamic> dataset = jsonDecode(res.json());
                            print(dataset.toString());

                          },
                        )
                    ),
                  ],
                );
              },
              childCount: agents.length,
            ),
          ),
        ],
      ),
      drawer: DrawerWidget(user: widget.user,),
    );
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Les services de localisation sont désactivés. veuillez l\'activer.",
              style: TextStyle(color: kPrimaryColor,),
              textAlign: TextAlign.center,
            ),
            content: Container(
              child: Icon(
                Icons.location_on,
                color: Colors.red,
                size: 40,
              ),
            ),
            actions: [
              FlatButton(
                  color: kPrimaryColor,
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text("Ok", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16,),)
              ),
            ],
          );
        },
      );
      return Future.error('Les services de localisation sont désactivés. veuillez l\'activer.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permantly denied, we cannot request permissions.');
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return Future.error(
            'Location permissions are denied (actual value: $permission).');
      }
    }

    return await Geolocator.getCurrentPosition();
  }
}