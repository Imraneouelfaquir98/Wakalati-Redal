import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wakalati_redal/Pages/accueil_payement.dart';
import 'package:wakalati_redal/Pages/directions_model.dart';
import 'package:wakalati_redal/constants.dart';
import 'package:wakalati_redal/Pages/agents.dart';

import 'drawer_widget.dart';

class AgentScreen extends StatefulWidget {
  final int num;
  final Position position;
  final User user;
  final Marker origin;
  final Marker destination;
  final Directions info;

  const AgentScreen({
    Key key,
    this.num,
    this.user,
    this.origin,
    this.destination,
    this.info,
    this.position
  }) : super(key: key);
  @override
  _AgentScreenState createState() => _AgentScreenState();
}

class _AgentScreenState extends State<AgentScreen> {

  GoogleMapController _googleMapController;

  //CameraUpdate.newLatLngBounds(widget.info.bounds, 100.0);
  void dispose(){
    _googleMapController.dispose();
    super.dispose();
  }

  String multiply_time(int nbr, List time){
    time = time.map((e) => e * nbr).toList();
    for(int i = 0; i<2; i++){
      int v = (time[2-i]/60).toInt();
      time[2-i] = time[2-i]%60;
      time[1-i] += v;
    }
    return (time[0])>0?'${time[0]}h ${time[1]}m ${time[2]}s':'${time[1]}m ${time[2]}s';
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      drawer: DrawerWidget(user: widget.user,),
      appBar: AppBar(
        title: Text(agents[widget.num].title, style: TextStyle(color: kPrimaryColor, fontSize: 18),),
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
        actions: [
          Container(
            width: 40,
            child: TextButton(
              onPressed: ()=> _googleMapController.animateCamera(
                  CameraUpdate.newCameraPosition(
                      CameraPosition(
                          target: widget.origin.position,
                          zoom: 12,
                          tilt: 50.0
                      )
                  )
              ),
              child: Icon(
                Icons.location_on,
                color: Colors.blue,
                size: 30,
              ),
            ),
          ),
          Container(
            width: 50,
            child: TextButton(
              onPressed: ()=> _googleMapController.animateCamera(
                  CameraUpdate.newCameraPosition(
                      CameraPosition(
                          target: widget.destination.position,
                          zoom: 12,
                          tilt: 50.0
                      )
                  )
              ),
              child: Icon(
                Icons.location_on,
                color: Colors.red,
                size: 30,
              ),

            ),
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            width: size.width,
            height: size.height*0.65,
            alignment: Alignment.center,
            color: Colors.grey[500],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: size.width,
                  height: size.height*0.65,
                  decoration: new BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    shape: BoxShape.rectangle,
                    color: Colors.white,
                  ),
                  child: GoogleMap(
                    zoomControlsEnabled: false,
                    initialCameraPosition: CameraPosition(
                        target: LatLng(
                            (widget.origin.position.latitude + widget.destination.position.latitude)/2,
                            (widget.origin.position.longitude + widget.destination.position.longitude)/2
                        ),
                        zoom: 8,
                    ),
                    onMapCreated: (controller) => _googleMapController = controller,
                    markers: {
                      if(widget.origin != null) widget.origin,
                      if(widget.destination != null) widget.destination
                    },
                    polylines: {
                      Polyline(
                        polylineId: PolylineId('overview_polyline'),
                        color: Colors.red,
                        width: 5,
                        points: widget.info.polylinePoints
                            .map((e) => LatLng(e.latitude, e.longitude))
                            .toList(),
                      ),
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 5,),
          Container(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.time_to_leave,
                      color: Colors.blue,
                    ),
                    Text('  ${agents[widget.num].distance} km', style: TextStyle(color: Colors.grey[700]),),
                    SizedBox(width: 10,),
                    Icon(
                      Icons.timer,
                      color: Colors.blue,
                    ),
                    Text('  ${agents[widget.num].timer}', style: TextStyle(color: Colors.grey[700]),),
                    SizedBox(width: 10,),
                    Image.asset("assets/icons/waiting_line.png", width: 20,),
                    FutureBuilder(
                      future: FirebaseFirestore.instance.collection('agencies').doc(agents[widget.num].id).get(),
                        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot){
                          if (snapshot.hasData) {
                            Map<String, dynamic> data = snapshot.data.data();
                            return Text('  ${data['customers_waiting']}  ', style: TextStyle(color: Colors.grey[700]),);
                          }
                          else if (snapshot.hasError)
                            return Text("error", style: TextStyle(color: Colors.grey[700]),);
                          else
                            return Text('          ', style: TextStyle(backgroundColor: Colors.grey[700]),);
                        }
                    )
                  ],
                ),
                SizedBox(height: 10,),
                Container(
                  alignment: Alignment.topLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('  Temps d\'attente estimé :', style: TextStyle(color: Colors.grey[700], fontSize: 16),),
                    ],
                  ),
                ),
                FutureBuilder(
                  future: FirebaseFirestore.instance.collection('agencies').doc(agents[widget.num].id).get(),
                  builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot){
                    if (snapshot.hasData) {
                      Map<String, dynamic> data = snapshot.data.data();//est estimé pour le paiement.
                      return Container(
                        child: Row(
                          children: [
                            SizedBox(width: 90,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Accueil', style: TextStyle(color: Colors.grey[700], fontSize: 16,),),SizedBox(height: 3,),
                                Text('Paiement', style: TextStyle(color: Colors.grey[700], fontSize: 16),),
                              ],
                            ),
                            SizedBox(width: 10,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(':  ${multiply_time(data['customers_waiting'], data['home_wait'])}', style: TextStyle(color: Colors.grey[700], fontSize: 16, fontWeight: FontWeight.bold),),SizedBox(height: 3,),
                                Text(':  ${multiply_time(data['customers_waiting'], data['payment_wait'])}', style: TextStyle(color: Colors.grey[700], fontSize: 16, fontWeight: FontWeight.bold),),
                              ],
                            ),SizedBox(width: 10,),
                          ],
                        ),
                      );
                    }
                    else if (snapshot.hasError)
                      return Text( "error",  style: TextStyle(color: Colors.grey[700]), );
                    else
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            child: CircularProgressIndicator(),
                            width: 20,
                            height: 20,
                          ),
                          SizedBox(
                            child: CircularProgressIndicator(),
                            width: 20,
                            height: 20,
                          ),
                        ],
                      );
                  },
                )
              ],
            )
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            width: size.width * 0.8,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(29),
              child: FlatButton(
                padding: EdgeInsets.symmetric(vertical: 17, horizontal: 40),
                color: kPrimaryColor,
                onPressed: () {
                  Navigator
                      .of(context)
                      .pushReplacement(
                      MaterialPageRoute( builder: (context) => AccueilPayement(user: widget.user, num: widget.num,)));
                },
                child: Text(
                  "Obtenir un ticket",
                  style: TextStyle(color: Colors.white , fontSize: 15),
                ),
              ),
            ),
          )
        ],
      )
    );
  }
}
