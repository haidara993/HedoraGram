import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hedoragram/models/User.dart' as MyUser;
import 'package:hedoragram/pages/home.dart';

class SignUp extends StatefulWidget {
  SignUp({Key key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _fullname = new TextEditingController();
  final TextEditingController _email = new TextEditingController();
  final TextEditingController _password = new TextEditingController();
  GlobalKey<FormState> _formkey = new GlobalKey<FormState>();

  bool _blackVisible = false;
  VoidCallback onBackPress;

  @override
  void initState() {
    super.initState();
    onBackPress = () {
      Navigator.of(context).pop();
    };
  }

  void _changeBlackVisible() {
    setState(() {
      _blackVisible = !_blackVisible;
    });
  }

  Future<String> signupwithemail(String email, String password) async {
    User user = (await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password))
        .user;

    return user.uid;
  }

  signup() async {
    final form = _formkey.currentState;
    if (form.validate()) {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      _changeBlackVisible();
      signupwithemail(_email.text, _password.text).then((uid) async {
        await usersRef.doc(uid).get().then((value) async {
          if (!value.exists) {
            usersRef.doc(uid).set({
              "id": uid,
              "username": _fullname.text,
              "photoUrl": '',
              "email": _email.text,
              "displayName": _fullname.text,
              "bio": "",
              "timestamp": DateTime.now()
            });
            await usersRef.doc(uid).get().then((value) {
              currentUser = MyUser.User.fromDocument(value);
            });
          } else {
            await usersRef.doc(uid).get().then((value) {
              currentUser = MyUser.User.fromDocument(value);
            });
          }
        }).then((value) => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Home(),
              ),
            ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onBackPress,
      child: Scaffold(
        body: Stack(
          children: [
            Stack(
              alignment: Alignment.topLeft,
              children: [
                Form(
                  key: _formkey,
                  autovalidate: true,
                  child: ListView(
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.only(top: 70.0, right: 10.0, left: 10.0),
                        child: Text(
                          "Create new account",
                          softWrap: true,
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(top: 20.0, right: 15.0, left: 15.0),
                        child: TextFormField(
                          validator: (value) {
                            if (value.trim().length < 3 || value.isEmpty) {
                              return "usernae is too short";
                            } else if (value.trim().length > 10) {
                              return "Username is too long";
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "User Name",
                              hintText: "must be at least 3 characters"),
                          controller: _fullname,
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(top: 10.0, right: 15.0, left: 15.0),
                        child: TextFormField(
                          controller: _email,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Email",
                              hintText: "email@example.com"),
                          validator: (value) {
                            Pattern pattern =
                                r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                            RegExp regex = new RegExp(pattern);
                            if (regex.hasMatch(value)) {
                              return null;
                            } else {
                              return " enter correct email";
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(top: 10.0, right: 15.0, left: 15.0),
                        child: TextFormField(
                          controller: _password,
                          obscureText: true,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Password"),
                          validator: (value) {
                            if (value.trim().length < 6) {
                              return "password is too short";
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 25.0,
                          horizontal: 40.0,
                        ),
                        child: FlatButton(
                            onPressed: signup,
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 12.0),
                              child: Text("Sign Up"),
                            )),
                      ),
                    ],
                  ),
                )
              ],
            ),
            Offstage(
              offstage: !_blackVisible,
              child: GestureDetector(
                onTap: () {},
                child: AnimatedOpacity(
                  opacity: _blackVisible ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 400),
                  curve: Curves.ease,
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    color: Colors.black54,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
