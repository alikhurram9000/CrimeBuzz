import 'package:CrimeBuzz/forgotpassword.dart';
import 'package:CrimeBuzz/admin/adminSignup.dart';
import 'package:CrimeBuzz/admin/adminHome.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'package:CrimeBuzz/internal/FirebaseManager.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class AdminLoginPage extends StatefulWidget {
  @override
  _AdminLoginPageState createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  bool _togglePassword;

  @override
  void initState() {
    _togglePassword = false;
  }

  bool loader = false;
  final _formKey = GlobalKey<FormState>();

  String email;
  String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      //resizeToAvoidBottomPadding: false,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: ModalProgressHUD(
          inAsyncCall: loader,
          opacity: 0.3,
          progressIndicator: CircularProgressIndicator(
            strokeWidth: 6,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.greenAccent[700]),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ClipPath(
                  clipper: MyClipper(),
                  child: Container(
                    padding: EdgeInsets.fromLTRB(20.0, 40.0, 0.0, 0.0),
                    height: 240,
                    decoration: BoxDecoration(
                      color: Colors.greenAccent[700],
                    ),
                    child: Center(
                      child: Text(
                        'Admin\nLogin.',
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
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(left: 15),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(18),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey[400],
                                      blurRadius: 20.0,
                                      offset: Offset(0, 10))
                                ]),
                            child: Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom:
                                          BorderSide(color: Colors.grey[100]),
                                    ),
                                  ),
                                  height: 65,
                                  child: TextFormField(
                                    validator: (val) {
                                      if (val.isEmpty) {
                                        return "Please enter your Email.";
                                      }
                                    },
                                    onSaved: (val) {
                                      email = val;
                                    },
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                      errorStyle: TextStyle(height: 0),
                                      border: InputBorder.none,
                                      labelText: 'EMAIL',
                                      labelStyle: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                      hintText: 'johndoe@example.com',
                                      hintStyle:
                                          TextStyle(color: Colors.grey[500]),
                                    ),
                                  ),
                                ),

                                //SizedBox(height: 20.0),
                                Container(
                                  height: 65,
                                  child: TextFormField(
                                    validator: (val) {
                                      if (val.isEmpty) {
                                        return "Please enter your Password.";
                                      }
                                    },
                                    onSaved: (val) {
                                      password = val;
                                    },
                                    decoration: InputDecoration(
                                      errorStyle: TextStyle(height: 0),
                                      border: InputBorder.none,
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _togglePassword
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          color: Colors.black87,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _togglePassword = !_togglePassword;
                                          });
                                        },
                                      ),
                                      labelText: 'PASSWORD',
                                      labelStyle: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    obscureText: !_togglePassword,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          //SizedBox(height: 5.0),
                          Container(
                            alignment: Alignment(1.0, 0.0),
                            padding: EdgeInsets.only(top: 25.0, left: 20.0),
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).push(_createRouteF());
                              },
                              child: Text(
                                'Forgot Password',
                                style: TextStyle(
                                  color: Colors.greenAccent[700],
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 60.0),
                          // Container(
                          SizedBox(
                            height: 60.0,
                            width: 280.0,
                            child: RaisedButton(
                              padding: EdgeInsets.fromLTRB(90, 18, 20, 20),
                              color: Colors.greenAccent[700],
                              elevation: 7.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    'LOGIN\t',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                  Icon(
                                    MdiIcons.loginVariant,
                                    color: Colors.white,
                                    size: 26,
                                  )
                                ],
                              ),
                              splashColor: Colors.greenAccent[700],
                              onPressed: () async {
                                final form = _formKey.currentState;
                                if (form.validate()) {
                                  form.save();
                                  setState(() {
                                    loader = true;
                                  });

                                  if (await FirebaseManager.validUserLogin(
                                      email, password)) {
                                    // SharedPreferences prefs =
                                    //     await SharedPreferences.getInstance();
                                    // prefs.setString('email', email);
                                    Navigator.of(context).push(_createRoute());
                                  } else {
                                    Alert(
                                      type: AlertType.warning,
                                      context: context,
                                      title: "Inavlid Credentials.",
                                      desc: "Please Try Again.",
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
                                  }
                                  setState(() {
                                    loader = false;
                                  });
                                }
                              },
                            ),
                          ),
                          // height: 60.0,
                          // child: Material(
                          //   borderRadius: BorderRadius.circular(35.0),
                          //   shadowColor: Colors.redAccent,
                          //   color: Colors.red[600],
                          //   elevation: 7.0,
                          //   child: GestureDetector(
                          //     onTap: () {},
                          //     child: Center(
                          //       child: Text(
                          //         'LOGIN',
                          //         style: TextStyle(
                          //             color: Colors.white,
                          //             fontWeight: FontWeight.bold,
                          //             fontSize: 18,
                          //             letterSpacing: 1.5),
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 200.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'New to CrimeBuzz?',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(width: 5.0),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(_createRouteS());
                      },
                      child: Text(
                        'SignUp',
                        style: TextStyle(
                          color: Colors.greenAccent[700],
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
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
    pageBuilder: (context, animation, secondaryAnimation) => AdminHomePage(),
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

Route _createRouteF() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => FPPage(),
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
