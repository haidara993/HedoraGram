import 'package:flutter/material.dart';
import 'package:hedoragram/pages/SignIn.dart';
import 'package:hedoragram/pages/Sign_up.dart';

class WelcomeScreen extends StatefulWidget {
  WelcomeScreen({Key key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 50.0),
            child: Text(
              "HedoraGram",
              style: TextStyle(
                fontFamily: "Signatra",
                color: Colors.orange,
                fontSize: 90.0,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 100.0, right: 15, left: 15),
            child: RaisedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SignUp(),
                ),
              ),
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Text(
                "Sign Up",
                style: TextStyle(color: Colors.orange),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 100.0, right: 15, left: 15),
            child: RaisedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SignIn(),
                ),
              ),
              color: Colors.orange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Text("Sign In"),
            ),
          ),
        ],
      ),
    );
  }
}
