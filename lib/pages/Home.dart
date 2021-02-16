import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hedoragram/models/User.dart';
import 'package:hedoragram/pages/ActivityFeed.dart';
import 'package:hedoragram/pages/Profile.dart';
import 'package:hedoragram/pages/Search.dart';
import 'package:hedoragram/pages/Timeline.dart';
import 'package:hedoragram/pages/Upload.dart';
import 'package:hedoragram/pages/create_acount.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();
final StorageReference storageRef = FirebaseStorage.instance.ref();
final usersRef = FirebaseFirestore.instance.collection("users");
final postsRef = FirebaseFirestore.instance.collection("posts");
final followersRef = FirebaseFirestore.instance.collection("followers");
final followingRef = FirebaseFirestore.instance.collection("following");
final commentsRef = FirebaseFirestore.instance.collection('comments');
final timelineRef = FirebaseFirestore.instance.collection('timeline');
final activityFeedRef = FirebaseFirestore.instance.collection('feed');

final DateTime timestamp = DateTime.now();
User currentUser;

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isAuth = false;
  PageController pageController;
  int pageIndex = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    googleSignIn.onCurrentUserChanged.listen((acount) {
      handleSignIn(acount);
    }).onError((err) {
      print('Error signing in: $err');
    });

    googleSignIn.signInSilently(suppressErrors: false).then((acount) {
      handleSignIn(acount);
    }).catchError((err) {
      print('Error signInSilently in: $err');
    });
  }

  createUserInFirestore() async {
    final GoogleSignInAccount user = googleSignIn.currentUser;
    await usersRef.doc(user.id).get().then((doc) async {
      if (!doc.exists) {
        String username;
        await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateAcount(),
            )).then((value) => username = value.toString());
        usersRef.doc(user.id).set({
          "id": user.id,
          "username": username,
          "photoUrl": user.photoUrl,
          "email": user.email,
          "displayName": user.displayName,
          "bio": "",
          "timestamp": timestamp
        });
        DocumentSnapshot doc = await usersRef.doc(user.id).get();
        currentUser = User.fromDocument(doc);
      } else {
        DocumentSnapshot doc = await usersRef.doc(user.id).get();
        currentUser = User.fromDocument(doc);
      }
      setState(() {
        isAuth = true;
      });
    });
  }

  handleSignIn(GoogleSignInAccount acount) async {
    if (acount != null) {
      await createUserInFirestore();
    } else {
      setState(() {
        isAuth = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  login() {
    googleSignIn.signIn();
  }

  logout() {
    googleSignIn.signOut();
  }

  onPageChanged(int pageIndex) {
    setState(() {
      this.pageIndex = pageIndex;
    });
  }

  onTap(int pageIndex) {
    pageController.animateToPage(
      pageIndex,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Scaffold buildUnAuthScreen() {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).accentColor,
                Theme.of(context).primaryColor
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "HedoraGram",
                style: TextStyle(
                  fontFamily: "Signatra",
                  color: Colors.white,
                  fontSize: 90.0,
                ),
              ),
              SignInButton(
                Buttons.Google,
                onPressed: login,
              )
            ],
          ),
        ),
      ),
    );
  }

  Scaffold buildAuthScreen() {
    return Scaffold(
      body: PageView(
        children: [
          Timeline(
            currentUser: currentUser,
          ),
          Search(),
          Upload(
            currentUser: currentUser,
          ),
          ActivityFeed(),
          Profile(
            profileId: currentUser.id,
          ),
        ],
        controller: pageController,
        onPageChanged: onPageChanged,
        // physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: pageIndex,
        onTap: onTap,
        activeColor: Theme.of(context).primaryColor,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.whatshot)),
          BottomNavigationBarItem(icon: Icon(Icons.search)),
          BottomNavigationBarItem(
              icon: Icon(
            Icons.photo_camera,
            size: 35.0,
          )),
          BottomNavigationBarItem(icon: Icon(Icons.notifications)),
          BottomNavigationBarItem(
              icon: currentUser.photoUrl != null
                  ? CircleAvatar(
                      maxRadius: 17.0,
                      backgroundImage:
                          CachedNetworkImageProvider(currentUser.photoUrl),
                    )
                  : Icon(Icons.person)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildAuthScreen();
  }
}
