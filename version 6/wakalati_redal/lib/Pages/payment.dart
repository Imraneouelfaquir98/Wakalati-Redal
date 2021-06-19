import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wakalati_redal/Welcome/components/rounded_button.dart';

import '../constants.dart';
import 'agents.dart';
import 'drawer_widget.dart';

class Payment extends StatefulWidget {
  final User user;
  final int num;

  const Payment({Key key, this.user, this.num}) : super(key: key);

  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      drawer: DrawerWidget(user: widget.user,),
      appBar: AppBar(
        title: Text('Paiement', style: TextStyle(color: kPrimaryColor),),
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
          SizedBox(height: 20,),
          Container(
              child: Column(
                children: [
                  Text("Bienvenue à ", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold, fontSize: 22),),
                  Text(agents[widget.num].title, style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold, fontSize: 22),),
                ],
              )
          ),
          Container(
            padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0, top: 0),
            alignment: Alignment.center,
            height: size.height*0.35,
            child: Image.asset('assets/images/image_agence.png'),
          ),
          RoundedButton(
            text: "Payer en ligne",
            press: () async {
              await canLaunch('https://www.redalclient.ma/#/paiements')
                  ?launch('https://www.redalclient.ma/#/paiements')
                  :print("error");
            },
            textColor: Colors.white,
            color: kPrimaryColor,
          ),
          RoundedButton(
            text: "Payer dans l'espace JIWAR",
            press: (){ },
            textColor: Colors.white,
            color: kPrimaryColor,
          ),
          RoundedButton(
            text: "Prendre un ticket",
            press: ()=>print('Hello'),
            textColor: Colors.white,
            color: kPrimaryColor,
          ),
          RoundedButton(
            text: "Autre solution de paiement",
            press: () async {
              await canLaunch('https://www.redal.ma/fr/votre-agence-ligne/vos-services-distance/solutions-alternatives-paiement')
                  ?launch('https://www.redal.ma/fr/votre-agence-ligne/vos-services-distance/solutions-alternatives-paiement')
                  :print("error");
            },
            textColor: Colors.white,
            color: kPrimaryColor,
          )
        ],
      ),
    );
  }
}
