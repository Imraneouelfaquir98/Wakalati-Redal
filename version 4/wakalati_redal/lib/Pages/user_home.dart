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
import 'package:pull_to_refresh/pull_to_refresh.dart';

String destinations;

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
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  _UserHomeState() {
    userDocument = Future<DocumentSnapshot>.delayed(
      const Duration(seconds: 2),
          () => FirebaseFirestore.instance
          .collection("users").doc(widget.user.uid).get(),
    );
    setDistance();
  }
  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    Size size = MediaQuery.of(context).size;
    destinations = '${agents[0].lat_long[0]},${agents[0].lat_long[1]}';
    for (int i=1; i<agents.length; i++){
      destinations += '|${agents[i].lat_long[0]},${agents[i].lat_long[1]}';
    }
    return Scaffold(
      backgroundColor: Colors.grey[200],
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
            itemExtent: 185.0,
            delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return Column(
                      children: <Widget>[
                        SizedBox(height: 15,),
                        Container(
                            width: size.width*0.95,
                            height: size.width*0.41,
                            alignment: Alignment.topLeft,
                            decoration: new BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                              shape: BoxShape.rectangle,
                              color: Colors.white,
                            ),
                            child: GestureDetector(
                              child: Row(
                                children: [
                                  Container(
                                    width: size.width*0.25,
                                    child: Image.asset(agents[Agent.order[index][0]].image),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      SizedBox(height: 10,),
                                      Container(
                                        height: 24,
                                        alignment: Alignment.bottomLeft,
                                        child: Text('${agents[Agent.order[index][0]].title}', style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold, fontSize: 16),),
                                      ),
                                      SizedBox(height: 5,),
                                      Container(
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.location_on,
                                              size: 22,
                                              color: kPrimaryColor,
                                            ),
                                            Container(
                                              height: 25,
                                              width: size.width*0.6,
                                              child: ListView(
                                                scrollDirection: Axis.horizontal,
                                                children: <Widget>[
                                                  Text(
                                                      '  ${agents[Agent.order[index][0]].address}',
                                                      style: TextStyle(color: Colors.grey[500], fontSize: 15)
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        )
                                      ),
                                      SizedBox(height: 8,),
                                      Container(
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.phone,
                                                size: 22,
                                                color: kPrimaryColor,
                                              ),
                                              Container(
                                                height: 25,
                                                width: size.width*0.6,
                                                child: ListView(
                                                  scrollDirection: Axis.horizontal,
                                                  children: <Widget>[
                                                    Text(
                                                        '  ${agents[Agent.order[index][0]].tele}',
                                                        style: TextStyle(color: Colors.grey[500], fontSize: 15)
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          )
                                      ),
                                      SizedBox(height: 8,),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.directions_car_rounded,
                                            size: 22,
                                            color: kPrimaryColor,
                                          ),
                                          Container(
                                              height: 25,
                                              width: size.width*0.6,
                                              child: Text(
                                                  '   ${agents[Agent.order[index][0]].distance} km',
                                                  style: TextStyle(color: Colors.grey[500], fontSize: 15)
                                              )
                                          )
                                        ],
                                      ),
                                      SizedBox(height: 8,),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.timer,
                                            size: 22,
                                            color: kPrimaryColor,
                                          ),
                                          Container(
                                              height: 25,
                                              width: size.width*0.6,
                                              child: Text(
                                                  '   ${agents[Agent.order[index][0]].timer} h',
                                                  style: TextStyle(color: Colors.grey[500], fontSize: 15)
                                              )
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              onTap: () async {
                                _determinePosition().then((value) {
                                  Navigator.of(context)
                                      .push(
                                      MaterialPageRoute(
                                          builder: (context) => AgentScreen(
                                            user: widget.user,
                                            nameAgent : agents[Agent.order[index][0]].title,
                                            position: value,
                                          )
                                      )
                                  );
                                });
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

  Future<void> setDistance() {
    _determinePosition().then((value) async {
      String destinations = '${agents[0].lat_long[0]},${agents[0].lat_long[1]}';
      for (int i=1; i<agents.length; i++){
        destinations += '|${agents[i].lat_long[0]},${agents[i].lat_long[1]}';
      }
      String url   = "https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=${value.latitude},${value.longitude}&destinations=$destinations&units=km&key=$mapKey";
      var res = await Requests.get(url);
      for (int i=0; i<agents.length; i++){
        String s = res.json()['rows'][0]['elements'][i]['distance']['text'];
        agents[i].distance = (double.parse(s.substring(0, s.length-3))*1.60934).toInt();
        Agent.order[i][1] = agents[i].distance;
        agents[i].timer = res.json()['rows'][0]['elements'][i]['duration']['text'];
        print('${agents[i].distance} : ${agents[i].timer}');
      }

      setState(() {
        Agent.order.sort((a, b) => a[1].compareTo(b[1]));
        print(Agent.order);
      });
    });
  }
}