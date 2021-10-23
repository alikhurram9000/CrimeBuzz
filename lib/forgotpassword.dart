// import 'package:CrimeBuzz/Home/home.dart';
import 'package:CrimeBuzz/login.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:CrimeBuzz/internal/reporter.dart';
// import 'package:CrimeBuzz/internal/FirebaseManager.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class FPPage extends StatefulWidget {
  @override
  _FPPageState createState() => _FPPageState();
}

class _FPPageState extends State<FPPage> {
  bool loader = false;
  final _formKey = GlobalKey<FormState>();

  String email;
  String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      //resizeToAvoidBottomPadding: false,
      body: ModalProgressHUD(
        inAsyncCall: loader,
        opacity: 0.3,
        progressIndicator: CircularProgressIndicator(
          strokeWidth: 6,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.red[700]),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ClipPath(
                clipper: MyClipper(),
                child: Container(
                  padding: EdgeInsets.fromLTRB(20.0, 20.0, 0.0, 0.0),
                  height: 240,
                  decoration: BoxDecoration(
                    color: Colors.red[600],
                  ),
                  child: Center(
                    child: Text(
                      'Reset\nPassword.',
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
                padding: EdgeInsets.only(top: 60.0, right: 35.0, left: 35.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 80,
                        child: TextFormField(
                          validator: (val) {
                            if (val.isEmpty) {
                              return "Please enter an Email.";
                            }
                          },
                          onSaved: (val) {
                            email = val;
                          },
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'Please enter your Email ',
                            labelStyle: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            hintText: 'johndoe@example.com',
                            hintStyle: TextStyle(color: Colors.grey[500]),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                        height: 60.0,
                        width: 280.0,
                        child: RaisedButton(
                          padding: EdgeInsets.fromLTRB(90, 18, 20, 20),
                          color: Colors.red[600],
                          elevation: 7.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          child: Row(
                            children: <Widget>[
                              Text(
                                'SUBMIT\t',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                  letterSpacing: 1.5,
                                ),
                              ),
                              Icon(
                                MdiIcons.checkCircle,
                                color: Colors.white,
                                size: 26,
                              )
                            ],
                          ),
                          splashColor: Colors.red[300],
                          onPressed: () async {
                            final form = _formKey.currentState;
                            if (form.validate()) {
                              form.save();

                              setState(() {
                                loader = true;
                              });
                              await FirebaseAuth.instance
                                  .sendPasswordResetEmail(email: email)
                                  .then((value) => print('Check Email'));

                              Alert(
                                type: AlertType.info,
                                context: context,
                                title:
                                    "A password reset link has been sent to your Email.",
                                //desc: "Please Try Again.",
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
                                      Navigator.of(context)
                                          .push(_createRoute());
                                    },
                                  ),
                                ],
                              ).show();

                              setState(() {
                                loader = false;
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();
    path.lineTo(0, size.height - 70);
    var controlPoint = Offset(50, size.height);
    var endPoint = Offset(size.width / 2, size.height);
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
    pageBuilder: (context, animation, secondaryAnimation) => LoginPage(),
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
