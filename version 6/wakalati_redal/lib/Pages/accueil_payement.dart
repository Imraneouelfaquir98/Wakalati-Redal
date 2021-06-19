import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wakalati_redal/Pages/agents.dart';
import 'package:wakalati_redal/Pages/payment.dart';
import 'package:wakalati_redal/Welcome/components/rounded_button.dart';
import 'dart:math';
import '../constants.dart';
import 'drawer_widget.dart';

class AccueilPayement extends StatefulWidget {

  final User user;
  final int num;

  const AccueilPayement({
    Key key,
    this.user,
    this.num,
}) : super(key: key);

  @override
  _AccueilPayementState createState() => _AccueilPayementState();
}

class _AccueilPayementState extends State<AccueilPayement> {

  String multiply_time(int nbr, List time){
    time = time.map((e) => e * nbr).toList();
    for(int i = 0; i<2; i++){
      int v = (time[2-i]/60).toInt();
      time[2-i] = time[2-i]%60;
      time[1-i] += v;
    }
    return '${time[0]}h ${time[1]}m ${time[2]}s';
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey[200],
      drawer: DrawerWidget(user: widget.user,),
      appBar: AppBar(
        title: Text(agents[widget.num].title, style: TextStyle(color: kPrimaryColor),),
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
          IconButton(
            icon: Icon(
              Icons.notifications,
              color: kPrimaryColor,
              size: size.width*0.08,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 10,),
          Container(
            child: Column(
              children: [
                Text("Bienvenue à ", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold, fontSize: 22),),
                Text(agents[widget.num].title, style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold, fontSize: 22),),
              ],
            )
          ),
          Container(
            padding: EdgeInsets.all(10.0),
            alignment: Alignment.center,
            //height: size.height*0.5,
            child: Image.asset('assets/images/image_agence.png'),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(10),
            ),
            width: size.width*0.9,
            child: Column(
              children: [
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: 10,),
                    Icon( Icons.time_to_leave,  color: Colors.blue, size: 30,),
                    SizedBox(width: 10,),
                    Text('  ${agents[widget.num].distance} km', style: TextStyle(color: Colors.grey[700], fontSize: 16),),
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: 10,),
                    Icon( Icons.timer, color: Colors.blue, size: 30,),
                    SizedBox(width: 10,),
                    Text('  ${agents[widget.num].timer}', style: TextStyle(color: Colors.grey[700], fontSize: 16),),
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: 14,),
                    Image.asset("assets/icons/waiting_line.png", width: 28,),
                    SizedBox(width: 10,),
                    FutureBuilder(
                        future: FirebaseFirestore.instance.collection('agencies').doc(agents[widget.num].id).get(),
                        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot){
                          if (snapshot.hasData) {
                            Map<String, dynamic> data = snapshot.data.data();
                            return Text('  ${data['customers_waiting']} personnes attendent', style: TextStyle(color: Colors.grey[700], fontSize: 16),);
                          }
                          else if (snapshot.hasError)
                            return Text("error", style: TextStyle(color: Colors.grey[700], fontSize: 16),);
                          else
                            return SizedBox(
                              child: LinearProgressIndicator(),
                              width: 150,
                              height: 10,
                            );
                        }
                    )
                  ],
                ),
                SizedBox(height: 20,),
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
                        padding: EdgeInsets.all(10),
                        child: Row(
                          children: [
                            SizedBox(width: 90,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Accueil', style: TextStyle(color: Colors.grey[700], fontSize: 16,),),SizedBox(height: 7,),
                                Text('Paiement', style: TextStyle(color: Colors.grey[700], fontSize: 16),),
                              ],
                            ),
                            SizedBox(width: 10,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(':  ${multiply_time(data['customers_waiting'], data['home_wait'])}', style: TextStyle(color: Colors.grey[700], fontSize: 16, fontWeight: FontWeight.bold),),SizedBox(height: 7,),
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
                            child: LinearProgressIndicator(),
                            width: 150,
                            height: 15,
                          ),
                          SizedBox(
                            child: LinearProgressIndicator(),
                            width: 150,
                            height: 15,
                          )
                        ],
                      );
                  },
                )
              ],
            ),
          ),
          SizedBox(height: 10,),
          Container(
            width: size.width,
            alignment: Alignment.topLeft,
            padding: EdgeInsets.only(left: 40, top: 10),
            child: Text(
              "Prenez le ticket",
              style: TextStyle(color: kPrimaryColor, fontSize: 16),
            ),
          ),
          RoundedButton(
            text: "Accueil",
            press: (){
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: Colors.grey[100],
                    title: Text(
                      "Ticket Digitale",
                      style: TextStyle(color: kPrimaryColor, fontSize: 16),
                    ),
                    content: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)
                      ),
                      width: size.width,
                      height: size.height*0.45,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              SizedBox(width: 10,),
                              Icon( Icons.person, color: Colors.blue, size: 30,),
                              SizedBox(width: 10,),
                              FutureBuilder(
                                  future: FirebaseFirestore.instance.collection('users').doc(widget.user.uid).get(),
                                  builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot){
                                    if(snapshot.hasData){
                                      Map<String, dynamic> data = snapshot.data.data();
                                      return Text('${data['name']} ', style: TextStyle(color: Colors.grey[700], fontSize: 15),);
                                    }
                                    else if (snapshot.hasError)
                                      return Text("error", style: TextStyle(color: Colors.grey[700], fontSize: 16),);
                                    else
                                      return SizedBox(
                                        child: LinearProgressIndicator(),
                                        width: 150,
                                        height: 10,
                                      );
                                  }
                              )
                            ],
                          ),
                          SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(width: 10,),
                              Icon( Icons.timer, color: Colors.blue, size: 30,),
                              SizedBox(width: 10,),
                              FutureBuilder(
                                future: FirebaseFirestore.instance.collection('agencies').doc(agents[widget.num].id).get(),
                                builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot){
                                  if (snapshot.hasData) {
                                    Map<String, dynamic> data = snapshot.data.data();//est estimé pour le paiement.
                                    return Text(
                                      ' Attente estimée à ${multiply_time(data['customers_waiting'], data['home_wait'])}',
                                      style: TextStyle(color: Colors.grey[700], fontSize: 15),
                                    );
                                  }
                                  else if (snapshot.hasError)
                                    return Text( "error",  style: TextStyle(color: Colors.grey[700]), );
                                  else
                                    return SizedBox(
                                      child: LinearProgressIndicator(),
                                      width: 150,
                                      height: 15,
                                    );
                                },
                              )
                            ],
                          ),
                          SizedBox(height: 10,),
                          Row(
                            children: [
                              SizedBox(width: 15,),
                              Icon( Icons.confirmation_num, color: Colors.blue, size: 25,),
                              SizedBox(width: 10,),
                              Text(' Numéro de ticket   ', style: TextStyle(color: Colors.grey[700], fontSize: 15),),
                              Text('${new Random().nextInt(30)+2}', style: TextStyle(color: Colors.grey[700], fontSize: 20, fontWeight: FontWeight.bold),),
                            ],
                          ),
                          SizedBox(height: 10,),
                          Row(
                            children: [
                              SizedBox(width: 14,),
                              Image.asset("assets/icons/waiting_line.png", width: 25,),
                              SizedBox(width: 10,),
                              FutureBuilder(
                                  future: FirebaseFirestore.instance.collection('agencies').doc(agents[widget.num].id).get(),
                                  builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot){
                                    if (snapshot.hasData) {
                                      Map<String, dynamic> data = snapshot.data.data();
                                      return Text('  ${data['customers_waiting']} personnes attendent', style: TextStyle(color: Colors.grey[700], fontSize: 16),);
                                    }
                                    else if (snapshot.hasError)
                                      return Text("error", style: TextStyle(color: Colors.grey[700], fontSize: 16),);
                                    else
                                      return SizedBox(
                                        child: LinearProgressIndicator(),
                                        width: 150,
                                        height: 10,
                                      );
                                  }
                              )
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 20, left: size.width*0.12),
                            width: size.width*0.55,
                            child: Image.asset('assets/images/qr_code.png'),
                          ),
                        ],
                      )
                    ),
                    actions: [
                      FlatButton(
                          color: kPrimaryColor,
                          onPressed: (){
                            Navigator.pop(context);
                          },
                          child: Text("Abandonner", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14,),)
                      ),
                    ],
                  );
                },
              );
            },
            textColor: Colors.white,
            color: kPrimaryColor,
          ),
          RoundedButton(
            text: "Paiement",
            press: ()=>Navigator
                .of(context)
                .pushReplacement(MaterialPageRoute(builder: (context) => Payment(user: widget.user, num: widget.num,))),
            textColor: Colors.white,
            color: kPrimaryColor,
          )
        ],
      ),
    );
  }
}
