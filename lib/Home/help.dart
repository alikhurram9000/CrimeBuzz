// import 'package:CrimeBuzz/Home/home.dart';
// import 'package:CrimeBuzz/Home/location.dart';
// import 'package:CrimeBuzz/main.dart';
import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:CrimeBuzz/internal/reporter.dart';
import 'package:CrimeBuzz/internal/FirebaseManager.dart';
// import 'package:rflutter_alert/rflutter_alert.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart';
// import 'dart:async';
// import 'dart:typed_data';
// import 'package:flutter/services.dart';
// import 'package:geolocator/geolocator.dart' as geol;
// import 'package:geocoder/geocoder.dart';
// import 'package:CrimeBuzz/Home/location.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:url_launcher/url_launcher.dart';

class Help extends StatefulWidget {
  @override
  _HelpState createState() => _HelpState();
}

class _HelpState extends State<Help> {
  bool loader = false;

  String email = '';

  void getUserEmail() async {
    //gets current user

    FirebaseManager firebaseM = FirebaseManager();
    await firebaseM.getCurrentUser();

    setState(() {
      email = firebaseM.loggedInUser.email;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserEmail();
  }

  _launchURL(command) async {
    if (await canLaunch(command)) {
      await launch(command);
    } else {
      throw 'Could not launch $command';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: loader,
        opacity: 0.3,
        progressIndicator: CircularProgressIndicator(
          strokeWidth: 6,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.red[700]),
        ),
        child: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              Container(
                child: Column(
                  children: <Widget>[
                    ClipPath(
                      clipper: MyClipper(),
                      child: Container(
                        padding: EdgeInsets.fromLTRB(20.0, 25.0, 0.0, 0.0),
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.red[600],
                        ),
                        child: Center(
                          child: Text(
                            'Help.',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 50,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 15, bottom: 15),
                      width: 360,
                      height: 660,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              offset: Offset(0, 0),
                              blurRadius: 5,
                              spreadRadius: 0,
                            )
                          ]),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          //mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "In Case Of Emergencies",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Row(
                              children: [
                                //Padding(padding: EdgeInsets.all(5)),
                                Text(
                                  "Call ",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 21,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Icon(
                                  Icons.call_rounded,
                                  color: Colors.blue,
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Padding(
                                    padding:
                                        EdgeInsets.only(left: 40, top: 40)),
                                InkWell(
                                  child: Text(
                                    "1) 15 - Police",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Color.fromRGBO(26, 222, 117, 1),
                                      fontWeight: FontWeight.w600,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                  onTap: () {
                                    _launchURL('tel:15');
                                  },
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Padding(
                                    padding:
                                        EdgeInsets.only(left: 40, top: 40)),
                                InkWell(
                                  child: Text(
                                    "2) 1122 - Rescue",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Color.fromRGBO(26, 222, 117, 1),
                                      fontWeight: FontWeight.w600,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                  onTap: () {
                                    _launchURL('tel:1122');
                                  },
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                //Padding(padding: EdgeInsets.all(5)),
                                Text(
                                  "OR ",
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Row(
                              children: [
                                //Padding(padding: EdgeInsets.all(5)),
                                Text(
                                  "Visit ",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 21,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Icon(
                                  Icons.web_rounded,
                                  color: Colors.blue,
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Padding(
                                    padding:
                                        EdgeInsets.only(left: 40, top: 40)),
                                InkWell(
                                  child: Text(
                                    "1) punjabpolice.gov.pk",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Color.fromRGBO(26, 222, 117, 1),
                                      fontWeight: FontWeight.w600,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                  onTap: () {
                                    _launchURL('http://punjabpolice.gov.pk');
                                  },
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Padding(
                                    padding:
                                        EdgeInsets.only(left: 40, top: 40)),
                                InkWell(
                                  child: Text(
                                    "2) sindhpolice.gov.pk",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Color.fromRGBO(26, 222, 117, 1),
                                      fontWeight: FontWeight.w600,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                  onTap: () {
                                    _launchURL(
                                        'https://www.sindhpolice.gov.pk');
                                  },
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Padding(
                                    padding:
                                        EdgeInsets.only(left: 40, top: 40)),
                                InkWell(
                                  child: Text(
                                    "3) islamabadpolice.gov.pk",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Color.fromRGBO(26, 222, 117, 1),
                                      fontWeight: FontWeight.w600,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                  onTap: () {
                                    _launchURL(
                                        'https://islamabadpolice.gov.pk/ipwe/');
                                  },
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Padding(
                                    padding:
                                        EdgeInsets.only(left: 40, top: 40)),
                                InkWell(
                                  child: Text(
                                    "4) kppolice.gov.pk",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Color.fromRGBO(26, 222, 117, 1),
                                      fontWeight: FontWeight.w600,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                  onTap: () {
                                    _launchURL('http://kppolice.gov.pk');
                                  },
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Padding(
                                    padding:
                                        EdgeInsets.only(left: 40, top: 40)),
                                InkWell(
                                  child: Text(
                                    "5) balochistanpolice.gov.pk",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Color.fromRGBO(26, 222, 117, 1),
                                      fontWeight: FontWeight.w600,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                  onTap: () {
                                    _launchURL(
                                        'hhttps://balochistanpolice.gov.pk');
                                  },
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 110,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                //Padding(padding: EdgeInsets.all(5)),
                                Text(
                                  "Stay Safe ",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 40,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Icon(
                                  Icons.stop_circle,
                                  color: Colors.blue,
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();
    path.lineTo(0, size.height - 50);
    var controlPoint = Offset(25, size.height);
    var endPoint = Offset(size.width / 4, size.height);
    path.quadraticBezierTo(
        controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

Widget FadeAlertAnimation(BuildContext context, Animation<double> animation,
    Animation<double> secondaryAnimation, Widget child) {
  return Align(
    child: FadeTransition(
      opacity: animation,
      child: child,
    ),
  );
}
