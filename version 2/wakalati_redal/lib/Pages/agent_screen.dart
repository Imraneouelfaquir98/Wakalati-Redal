import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:wakalati_redal/constants.dart';

class AgentScreen extends StatefulWidget {
  final String nameAgent;
  final Position position;
  final User user;
  const AgentScreen({
    Key key,
    this.nameAgent,
    this.user,
    this.position
  }) : super(key: key);
  @override
  _AgentScreenState createState() => _AgentScreenState();
}

class _AgentScreenState extends State<AgentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.nameAgent, style: TextStyle(color: kPrimaryColor),),
        backgroundColor: Colors.white,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(
                Icons.arrow_back_outlined,
                color: kPrimaryColor,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
      ),
      body: Text(widget.nameAgent),
    );
  }
}
