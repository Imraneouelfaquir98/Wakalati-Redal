import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:wakalati_redal/Pages/user_home.dart';
import 'package:wakalati_redal/SignUp/signup_service_database.dart';
import 'package:wakalati_redal/Welcome/welcome_screen.dart';

class Authentication {

  CollectionReference users = FirebaseFirestore.instance.collection('users');

  static Future<FirebaseApp> initializeFirebase({
    @required BuildContext context,
  }) async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    User user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => UserHome(
            user: user,
          ),
        ),
      );
    }
    return firebaseApp;
  }

  static Future<bool> checkUser(String id) async{
    bool result = false;
    await FirebaseFirestore.instance.collection('users')
        .doc(id)
        .get()
        .then(
            (DocumentSnapshot snapshot) {
          if(snapshot.exists){
            result = true;
          }
        }
    );
    return result;
  }

  static Future<User> signInWithGoogle({@required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    UserCredential userCredential;

    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        userCredential = await auth.signInWithCredential(credential);
        await checkUser(userCredential.user.uid).then((bool result) {
          if(result != true){
            SingUpDataBase userInformations = SingUpDataBase(uid:userCredential.user.uid);
            userInformations.addUser(
                (userCredential.user.displayName != null)?userCredential.user.displayName:"Not found",
                (userCredential.user.phoneNumber != null)?userCredential.user.phoneNumber:"",
                ""
            );
          }
        });

      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text('The account already exists with a different credential.'),
            ),
          );
        } else if (e.code == 'invalid-credential') {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text('Error occurred while accessing credentials. Try again.'),
            ),
          );
        }
        print(e.code);
      } catch (e) {
        print(e.code);
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text('Error occurred using Google Sign-In. Try again.'),
          ),
        );
      }
    }
    return userCredential.user;
  }

  static Future<User> signInWithEmailAndPassword({
    @required BuildContext context,
    @required String email,
    @required String password,
  }) async {

    FirebaseAuth auth = FirebaseAuth.instance;
    UserCredential userCredential;

    try{
      userCredential = await auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(e.code),
            elevation: 24.0,
          );
        },
      );
      print(e.code);
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(e.toString()),
            elevation: 24.0,
          );
        },
      );
    }
    return userCredential.user;
  }

  static Future<User> createUserWithEmailAndPassword({
    @required BuildContext context,
    @required String email,
    @required String password,
    @required String name,
    @required String phone,
    @required String address,
  }) async {

    FirebaseAuth auth = FirebaseAuth.instance;
    UserCredential userCredential;

    try{
      userCredential = await auth.createUserWithEmailAndPassword(email: email, password: password);
      SingUpDataBase userInformations = SingUpDataBase(uid:userCredential.user.uid);
      userInformations.addUser(name, phone, address);
    } on FirebaseAuthException catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(e.code),
            elevation: 24.0,
          );
        },
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(e.toString()),
            elevation: 24.0,
          );
        },
      );
    }
    print(userCredential.user);
    return userCredential.user;
  }

  static SnackBar customSnackBar({@required String content}) {
    return SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        content,
        style: TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
      ),
    );
  }

  static Future<void> signOut({@required BuildContext context}) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    try {
      await googleSignIn.signOut();
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => WelcomeScreen()));
    } catch (e) {
      print(e.toString());
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('Error signing out. Try again.'),
        ),
      );
    }
  }
}