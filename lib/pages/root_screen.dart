import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hedoragram/models/User.dart' as MyUser;
import 'package:hedoragram/pages/home.dart';
import 'package:hedoragram/pages/welcome_screen.dart';

class RootScreen extends StatefulWidget {
  RootScreen({Key key}) : super(key: key);

  @override
  _RootScreenState createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  getuser(User user) async {
    DocumentSnapshot doc = await usersRef.doc(user.uid).get();
    currentUser = MyUser.User.fromDocument(doc);
  }

  @override
  Widget build(BuildContext context) {
    return new StreamBuilder<User>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            color: Colors.white,
            child: Text(
              "HedoraGram",
              style: TextStyle(
                fontFamily: "Signatra",
                color: Colors.orange,
                fontSize: 90.0,
              ),
            ),
          );
        } else {
          if (snapshot.hasData) {
            getuser(snapshot.data);
            return Home();
          } else {
            return WelcomeScreen();
          }
        }
      },
    );
  }
}
