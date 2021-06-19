import 'package:cloud_firestore/cloud_firestore.dart';

class SingUpDataBase{

  final String uid;

  SingUpDataBase({this.uid});

  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<void> addUser(String name, String phone, String address) async {
    return await users.doc(uid).set({
      'name': name, // John Doe
      'phone': phone, // Stokes and Sons
      'address': address, // 42
      'isAdmin': false
    }).then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }
}