import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wakalati_redal/Pages/agents.dart';
import 'package:wakalati_redal/constants.dart';
import 'drawer_widget.dart';
import 'package:geolocator/geolocator.dart';

class UserHome extends StatefulWidget {

  final User user;

  const UserHome({
    Key key,
    @required this.user
  }) : super(key: key);

  @override
  _UserHomeState createState() => _UserHomeState();

}

class _UserHomeState extends State<UserHome> {//userCollection.doc(widget.auth.currentUser.uid).get()

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
                          onTap: ()=>print(agents[index].title),
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
}