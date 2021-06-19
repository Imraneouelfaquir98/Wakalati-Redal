import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';


class PersonalInformation extends StatelessWidget {
  const PersonalInformation({
    Key key,
    @required this.size, @required this.user,@required this.name, @required this.phone, @required this.email, @required this.address,
  }) : super(key: key);

  final User user;
  final Size size;
  final String name;
  final String phone;
  final String email;
  final String address;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width,
      height: size.width*0.5,
      alignment: Alignment.center,
      padding: EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 20, top: 15),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.person,
                      color: kPrimaryColor,
                      size: 30,
                    ),
                    SizedBox(width: 20,),
                    Container(
                      height: 25,
                      width: size.width*0.58,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: <Widget>[
                          Text(
                              name,
                              style: TextStyle(color: Colors.grey[500], fontSize: 16)
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 20, top: 15),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.phone,
                      color: kPrimaryColor,
                      size: 30,
                    ),
                    SizedBox(width: 20,),
                    Container(
                      height: 25,
                      width: size.width*0.58,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: <Widget>[
                          Text(
                              phone,
                              style: TextStyle(color: Colors.grey[500], fontSize: 16)
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 20, top: 15),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.email,
                      color: kPrimaryColor,
                      size: 28,
                    ),
                    SizedBox(width: 20,),
                    Container(
                      height: 25,
                      width: size.width*0.7,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: <Widget>[
                          Text(
                              email,
                              style: TextStyle(color: Colors.grey[500], fontSize: 16)
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 20, top: 15),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.location_on,
                      color: kPrimaryColor,
                      size: 30,
                    ),
                    SizedBox(width: 20,),
                    Container(
                      height: 25,
                      width: size.width*0.58,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: <Widget>[
                          Text(
                              address,
                              style: TextStyle(color: Colors.grey[500], fontSize: 16)
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
