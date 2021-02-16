import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:hedoragram/pages/Home.dart';

class SignIn extends StatefulWidget {
  SignIn({Key key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController _email = new TextEditingController();
  final TextEditingController _password = new TextEditingController();
  final GlobalKey<FormState> _formkey = new GlobalKey<FormState>();

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

  signinwithemail(String email, String password) async {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    _changeBlackVisible();
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Home(),
          ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          body: Stack(
            children: [
              Stack(
                alignment: Alignment.topLeft,
                children: [
                  ListView(
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.only(top: 60.0, left: 10.0, right: 10.0),
                        child: Text("Sign In"),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(top: 20.0, left: 15.0, right: 15.0),
                        child: Form(
                          child: ListView(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 20.0, right: 15.0, left: 15.0),
                                child: TextFormField(
                                  controller: _email,
                                  decoration: InputDecoration(
                                      labelText: "Email",
                                      hintText: "email@example.com",
                                      border: OutlineInputBorder()),
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
                                padding: EdgeInsets.only(
                                    top: 20.0, right: 15.0, left: 15.0),
                                child: TextFormField(
                                  controller: _password,
                                  decoration: InputDecoration(
                                      labelText: "password",
                                      border: OutlineInputBorder()),
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
                                    onPressed: () => signinwithemail(
                                        _email.text, _password.text),
                                    child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 12.0),
                                      child: Text("Sign In"),
                                    )),
                              ),
                              Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Text("or"),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 20.0, horizontal: 15.0),
                                child: SignInButton(Buttons.Facebook,
                                    onPressed: null),
                              ),
                              Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Text("or"),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 20.0, horizontal: 15.0),
                                child:
                                    SignInButton(Buttons.Google, onPressed: () {
                                  SystemChannels.textInput
                                      .invokeMethod('TextInput.hide');
                                  _changeBlackVisible();
                                  googleSignIn.signIn().then((value) {});
                                }),
                              ),
                            ],
                          ),
                          autovalidate: true,
                          key: _formkey,
                        ),
                      ),
                    ],
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
        onWillPop: onBackPress);
  }
}
