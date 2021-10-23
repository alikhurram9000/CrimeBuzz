import 'package:CrimeBuzz/Home/home.dart';
import 'package:CrimeBuzz/Home/location.dart';
import 'package:CrimeBuzz/main.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:CrimeBuzz/internal/reporter.dart';
import 'package:CrimeBuzz/internal/FirebaseManager.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart' as geol;
import 'package:geocoder/geocoder.dart';
import 'package:CrimeBuzz/Home/location.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class Report extends StatefulWidget {
  final String userEmail;
  final String name;
  final Address address;

  var pos;
  Report({Key key, @required this.address, this.userEmail, this.name, this.pos})
      : super(key: key);

  @override
  _ReportState createState() => _ReportState();
}

class _ReportState extends State<Report> {
  int option = 0;
  String type;
  String other;
  String notes;

  String cUName = '';

  bool loader = false;

  String address;
  double lat;
  double long;

  String email = '';

  void getUserEmail() async {
    //gets current user

    FirebaseManager firebaseM = FirebaseManager();
    await firebaseM.getCurrentUser();

    setState(() {
      email = firebaseM.loggedInUser.email;
    });
  }

  void getUserName() async {
    //gets current user

    FirebaseManager firebaseM = FirebaseManager();
    await firebaseM.getCurrentUser();

    String namee = await Reporter.getReporterName(email);

    setState(() {
      cUName = namee;
    });
  }

  @override
  void initState() {
    super.initState();
    getUserEmail();
    getUserName();

    address = widget.address.addressLine;
    lat = widget.pos.latitude;
    long = widget.pos.longitude;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: ModalProgressHUD(
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
                          height: 120,
                          decoration: BoxDecoration(
                            color: Colors.red[600],
                          ),
                          child: Center(
                            child: Text(
                              'Report.',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 40,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 15, right: 15, top: 10),
                        child: Column(
                          children: [
                            Container(
                              height: 305,
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey[400],
                                        blurRadius: 20.0,
                                        offset: Offset(0, 10))
                                  ]),
                              child: Column(
                                children: [
                                  Container(
                                    alignment: Alignment.topLeft,
                                    padding: EdgeInsets.only(left: 30, top: 10),
                                    child: Text(
                                      "Type of Crime",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 40,
                                    child: ListTile(
                                      title: const Text(
                                        'Theft',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      leading: Radio(
                                        activeColor: Colors.blue,
                                        value: 1,
                                        groupValue: option,
                                        onChanged: (value) {
                                          setState(() {
                                            option = value;
                                            type = "Theft";
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 40,
                                    child: ListTile(
                                      title: const Text(
                                        'Assault',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      leading: Radio(
                                        activeColor: Colors.blue,
                                        value: 2,
                                        groupValue: option,
                                        onChanged: (value) {
                                          setState(() {
                                            option = value;
                                            type = "Assault";
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 40,
                                    child: ListTile(
                                      title: const Text(
                                        'Abuse',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      leading: Radio(
                                        activeColor: Colors.blue,
                                        value: 3,
                                        groupValue: option,
                                        onChanged: (value) {
                                          setState(() {
                                            option = value;
                                            type = "Abuse";
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 40,
                                    child: ListTile(
                                      title: const Text(
                                        'Murder',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      leading: Radio(
                                        activeColor: Colors.blue,
                                        value: 4,
                                        groupValue: option,
                                        onChanged: (value) {
                                          setState(() {
                                            option = value;
                                            type = "Murder";
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 40,
                                    child: ListTile(
                                      title: const Text(
                                        'Other',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      leading: Radio(
                                        activeColor: Colors.blue,
                                        value: 5,
                                        groupValue: option,
                                        onChanged: (value) {
                                          setState(() {
                                            option = value;
                                            type = "Other";
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding:
                                        EdgeInsets.only(left: 30, right: 30),
                                    child: TextField(
                                      decoration: InputDecoration(
                                        hintText: '*If other, please specify.',
                                        //border: InputBorder.none,
                                        contentPadding: EdgeInsets.only(
                                            left: 5.0, top: 15.0),
                                      ),
                                      onChanged: (val) {
                                        setState(() {
                                          other = val;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: 380,
                        padding: EdgeInsets.only(top: 5),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey[400],
                                  blurRadius: 20.0,
                                  offset: Offset(0, 10))
                            ]),
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.topLeft,
                              padding: EdgeInsets.only(left: 30, top: 10),
                              child: Text(
                                "Location",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 80,
                              width: 335,
                              child: RaisedButton(
                                padding: EdgeInsets.only(
                                  left: 10,
                                  right: 10,
                                ),
                                elevation: 0,
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                  side: BorderSide(
                                    color: Colors.white,
                                  ),
                                ),
                                child: Row(
                                  children: <Widget>[
                                    Flexible(
                                      flex: 2,
                                      child: Text(
                                        "${widget.address?.addressLine ?? '-'}",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 13.0,
                                          letterSpacing: 1,
                                        ),
                                      ),
                                    ),
                                    // Icon(
                                    //   Icons.report,
                                    //   color: Colors.white,
                                    //   size: 24,
                                    // ),
                                  ],
                                ),
                                onPressed: () {},
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: 380,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey[400],
                                  blurRadius: 20.0,
                                  offset: Offset(0, 10))
                            ]),
                        child: Column(
                          children: <Widget>[
                            Container(
                              alignment: Alignment.topLeft,
                              padding: EdgeInsets.only(left: 30, top: 10),
                              child: Text(
                                "Additional Notes",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            Container(
                              width: 340,
                              margin: EdgeInsets.only(
                                  top: 12, bottom: 12, left: 12, right: 12),
                              height: 4 * 24.0,
                              child: TextField(
                                onChanged: (val) {
                                  setState(() {
                                    notes = val;
                                  });
                                },
                                onSubmitted: (val) {
                                  setState(() {
                                    notes = val;
                                  });
                                },
                                maxLines: 4,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Add notes",
                                  fillColor: Colors.grey[100],
                                  filled: true,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        height: 70.0,
                        width: 360.0,
                        child: RaisedButton(
                          padding: EdgeInsets.fromLTRB(110, 18, 20, 20),
                          color: Colors.red[600],
                          elevation: 7.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(35.0),
                          ),
                          child: Row(
                            children: <Widget>[
                              Text(
                                'SUBMIT\t',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22.0,
                                  letterSpacing: 1.5,
                                ),
                              ),
                              Icon(
                                Icons.library_add_check_rounded,
                                color: Colors.white,
                                size: 31,
                              )
                            ],
                          ),
                          splashColor: Colors.red[300],
                          onPressed: () async {
                            setState(() {
                              loader = true;
                            });
                            if ((option == 0) ||
                                (option == 5 && other == null)) {
                              Alert(
                                type: AlertType.warning,
                                context: context,
                                title: "Please Specify Type",
                                //desc: "Please Complete the Form.",
                                style: AlertStyle(
                                    animationDuration:
                                        Duration(milliseconds: 400)),
                                alertAnimation: FadeAlertAnimation,
                                buttons: [
                                  DialogButton(
                                    child: Text(
                                      'Okay',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ).show();
                            } else {
                              if (await FirebaseManager.SubmitReport(
                                  email,
                                  cUName,
                                  type,
                                  address,
                                  notes,
                                  lat,
                                  long,
                                  other)) {
                                await Alert(
                                  type: AlertType.success,
                                  context: context,
                                  title: "Report Submitted.",
                                  //desc: "Let's Get Started.",
                                  style: AlertStyle(
                                      animationDuration:
                                          Duration(milliseconds: 400)),
                                  alertAnimation: FadeAlertAnimation,
                                  buttons: [
                                    DialogButton(
                                      child: Text(
                                        'Go To Home',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17),
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                        Navigator.of(context)
                                            .push(_createRoute());
                                      },
                                    ),
                                  ],
                                ).show();
                              }
                            }
                            setState(() {
                              loader = false;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 460, left: 145),
                  child: Icon(
                    Icons.location_pin,
                    color: Colors.blue,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 587, left: 242),
                  child: Icon(
                    Icons.notes_sharp,
                    color: Colors.grey[700],
                    size: 28,
                  ),
                ),
              ],
            ),
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

Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => HomePage(),
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

// child: Text("${widget.address?.addressLine ?? '-'}"),
//child: Text("${widget.pos?.longitude ?? '-'}"),
