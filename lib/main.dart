import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'dart:async';
import 'package:kandy/notification/notification.dart';
import 'package:kandy/page/BANGLA.dart';
import 'package:kandy/page/BOLLYWOOD.dart';
import 'package:kandy/page/ENGLISH.dart';
import 'package:kandy/login/services/authentication.dart';
import 'package:kandy/page/HINDI_DUBBED.dart';
import 'package:kandy/page/SOUTH.dart';
import 'package:simple_connection_checker/simple_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'drawcopy.dart';
import 'homescreen/home.dart';
import 'homescreen/splashscreen.dart';
import 'login/pages/root_page.dart';
import 'login/services/authentication.dart';

// void main() => runApp(Akdom1st());
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(Akdom1st());
}

class Akdom1st extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    SystemChrome.setEnabledSystemUIOverlays([]);

    return Shortcuts(
      // needed for AndroidTV to be able to select
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.select): const ActivateIntent(),
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(),
        // routes: <String, WidgetBuilder>{
        //   // '/MyHomePage': (BuildContext context) => MyHomePage(),
        //   '/RootPage': (BuildContext context) =>
        //       new RootPage(auth: new Auth()),
        // }),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.userId, this.logoutCallback, this.title})
      : super(key: key);

  final String? title;
  // final BaseAuth? auth;
  final VoidCallback? logoutCallback;
  final String? userId;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _message = '';
  StreamSubscription? subscription;
  SimpleConnectionChecker _simpleConnectionChecker = SimpleConnectionChecker()
    ..setLookUpAddress('pub.dev');

  // signOut() async {
  //   try {
  //     await widget.auth!.signOut();
  //     widget.logoutCallback!();
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  int _currentIndex = 0;
  PageController? _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    subscription =
        _simpleConnectionChecker.onConnectionChange.listen((connected) {
      setState(() {
        _message = connected ? 'Connected' : 'Not connected';
      });
    });
  }

  @override
  void dispose() {
    _pageController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) async {
            bool _isConnected =
                await SimpleConnectionChecker.isConnectedToInternet();
            setState(() => _currentIndex = index);
          },
          children: <Widget>[
            ///////////////////////////////////////////////////////////////////////
            BANGLA(),
            // Homepage(),
            // HINDI_DUBBED(),
            // ENGLISH(),
            // BOLLYWOOD(),
            // SOUTH(),
            // BANGLA(),

            Scaffold(
                backgroundColor: Colors.black,
                body: Stack(children: <Widget>[
                  Center(
                      child: FlatButton.icon(
                          onPressed: null,
                          color: Colors.transparent,
                          // onPressed: signOut,
                          icon: Icon(
                            Icons.power_settings_new,
                            color: Colors.redAccent[700],
                          ),
                          label: Text(
                            'Logout',
                            style:
                                TextStyle(color: Colors.white, fontSize: 25.0),
                          ))),
                  Center(
                      child: Padding(
                          padding: const EdgeInsets.only(top: 250),
                          child: FloatingActionButton.extended(
                            icon: Icon(Icons.arrow_back, color: Colors.white),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            label: Text(
                              'back',
                              style: TextStyle(fontSize: 20),
                            ),
                            backgroundColor: Colors.redAccent[700],
                          )))
                ])),
            // Notificationss(),
          ],
        ),
      ),
    );
  }
}
