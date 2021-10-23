import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:CrimeBuzz/admin/adminSignup.dart';
import 'package:CrimeBuzz/admin/adminLogin.dart';

// import 'Home/home.dart';
// import 'forgotpassword.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:CrimeBuzz/Home/location.dart';
// import 'package:transparent_image/transparent_image.dart';

class AdminNavPage extends StatefulWidget {
  @override
  _AdminNavPageState createState() => _AdminNavPageState();
}

class _AdminNavPageState extends State<AdminNavPage>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 150),
    );
    _animationController.forward();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, //or set color with: Color(0xFF0000FF)
    ));
    return Scaffold(
      backgroundColor: Colors.black12,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          //myImage,
          Container(
            foregroundDecoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/adminbg10.jpg'),
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Stack(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(20.0, 60.0, 0.0, 0.0),
                      child: Text(
                        'Admin',
                        style: TextStyle(
                            fontSize: 80.0,
                            fontWeight: FontWeight.w700,
                            color: Colors.white),
                      ),
                    ),
                    // Container(
                    //   padding: EdgeInsets.fromLTRB(20.0, 135.0, 0.0, 0.0),
                    //   child: Text(
                    //     'Page',
                    //     style: TextStyle(
                    //         fontSize: 80.0,
                    //         fontWeight: FontWeight.w700,
                    //         color: Colors.white),
                    //   ),
                    // ),
                    Container(
                      padding: EdgeInsets.fromLTRB(326.0, 60.0, 0.0, 0.0),
                      child: Text(
                        '.',
                        style: TextStyle(
                            fontSize: 80.0,
                            fontWeight: FontWeight.w700,
                            color: Colors.greenAccent[700]),
                      ),
                    ),
                  ],
                ),
              ),
              // SizedBox(
              //   height: 320,
              //   child: Center(
              //     child: Image(
              //       image: AssetImage('assets/cbl1.png'),
              //     ),
              //   ),
              // ),
              Container(
                padding: EdgeInsets.only(top: 450.0, right: 35.0, left: 35.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    //SizedBox(height: 40.0),
                    SizedBox(
                      height: 70.0,
                      width: 360.0,
                      child: RaisedButton(
                          padding: EdgeInsets.fromLTRB(105, 18, 20, 20),
                          color: Colors.white,
                          elevation: 7.0,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: Colors.white,
                            ),
                            borderRadius: BorderRadius.circular(35.0),
                          ),
                          child: Row(
                            children: <Widget>[
                              Text(
                                'LOGIN\t',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.purpleAccent[700],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22.0,
                                  letterSpacing: 1.5,
                                ),
                              ),
                              Icon(
                                MdiIcons.loginVariant,
                                color: Colors.purpleAccent[700],
                                size: 32,
                              )
                            ],
                          ),
                          splashColor: Colors.grey[200],
                          onPressed: () =>
                              {Navigator.of(context).push(_createRouteL())}),
                    ),
                    SizedBox(height: 25.0),
                    SizedBox(
                      height: 70.0,
                      width: 360.0,
                      child: RaisedButton(
                        padding: EdgeInsets.fromLTRB(105, 18, 20, 20),
                        color: Colors.greenAccent[700],
                        elevation: 7.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(35.0),
                        ),
                        child: Row(
                          children: <Widget>[
                            Text(
                              'SIGNUP\t',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 22.0,
                                letterSpacing: 1.5,
                              ),
                            ),
                            Icon(
                              MdiIcons.send,
                              color: Colors.white,
                              size: 30,
                            )
                          ],
                        ),
                        splashColor: Colors.greenAccent,
                        onPressed: () => {
                          //Navigator.pushNamed(context, '/signup'),
                          Navigator.of(context).push(_createRouteS())
                        },
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

Route _createRouteS() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => AdminSignupPage(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(0.0, 1.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

Route _createRouteL() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => AdminLoginPage(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(0.0, 1.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );

      // return FadeTransition(
      //   opacity: animation,
      //   child: child,
      // );
    },
  );
}
