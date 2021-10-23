import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:CrimeBuzz/internal/admin.dart';
import 'package:CrimeBuzz/internal/FirebaseManager.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:CrimeBuzz/admin/adminLogin.dart';

class AdminSignupPage extends StatefulWidget {
  @override
  _AdminSignupPageState createState() => _AdminSignupPageState();
}

class _AdminSignupPageState extends State<AdminSignupPage> {
  final _auth = FirebaseAuth.instance;

  bool loader = false;

  bool _togglePassword;
  bool _togglePassword1;

  @override
  void initState() {
    _togglePassword = false;
    _togglePassword1 = false;
  }

  // CollectionReference users = FirebaseFirestore.instance.collection('users');

  // String name;
  // String email;
  // String number;
  String password;
  String confirmpass;

  String key = "admin123";

  final _formKey = GlobalKey<FormState>();
  final _admin = Admins();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
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
                    height: 215,
                    decoration: BoxDecoration(
                      color: Colors.greenAccent[700],
                    ),
                    child: Center(
                      child: Text(
                        'Admin\nSignUp.',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 50,
                        ),
                      ),
                    ),
                  ),
                ),
                //
                //
                Container(
                  padding: EdgeInsets.only(top: 40.0, right: 35.0, left: 35.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(left: 15),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey[400],
                                    blurRadius: 20.0,
                                    offset: Offset(0, 10))
                              ]),
                          child: Column(
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(color: Colors.grey[100]),
                                  ),
                                ),
                                height: 72,
                                child: TextFormField(
                                  autofocus: false,
                                  validator: (val) {
                                    if (val.isEmpty) {
                                      return "Please enter your Name.";
                                    }
                                    //return "";
                                  },
                                  onSaved: (val) {
                                    setState(() {
                                      _admin.name = val;
                                    });
                                  },
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    labelText: 'NAME',
                                    labelStyle: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                    hintText: 'John Doe',
                                    hintStyle:
                                        TextStyle(color: Colors.grey[500]),
                                  ),
                                ),
                              ),

                              Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(color: Colors.grey[100]),
                                  ),
                                ),
                                height: 72,
                                child: TextFormField(
                                  onSaved: (val) {
                                    setState(() {
                                      _admin.email = val;
                                    });
                                  },
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    labelText: 'ADMIN KEY',
                                    labelStyle: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  validator: (val) {
                                    if (val.isEmpty) {
                                      return "Please enter a Key.";
                                    }

                                    if (val != key) {
                                      return "Please enter a valid Key.";
                                    }
                                    //return "";
                                  },
                                  //onSaved: (val) => setState(() => _user.email = val),
                                ),
                              ),

                              //SizedBox(height: 5.0),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(color: Colors.grey[100]),
                                  ),
                                ),
                                height: 72,
                                child: TextFormField(
                                  onSaved: (val) {
                                    setState(() {
                                      _admin.email = val;
                                    });
                                  },
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
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
                                  validator: (val) {
                                    if (val.isEmpty) {
                                      return "Please enter your Email.";
                                    }
                                    //return "";
                                  },
                                  //onSaved: (val) => setState(() => _user.email = val),
                                ),
                              ),
                              //SizedBox(height: 5.0),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(color: Colors.grey[100]),
                                  ),
                                ),
                                height: 72,
                                child: TextFormField(
                                  validator: (val) {
                                    if (val.isEmpty) {
                                      return "Please enter your Phone Number.";
                                    }
                                    if (val.length < 11) {
                                      return "Please enter a valid Phone Number.";
                                    }
                                    //return "";
                                  },
                                  onSaved: (val) {
                                    setState(() {
                                      _admin.number = val;
                                    });
                                  },
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    labelText: 'PHONE NUMBER',
                                    labelStyle: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                    hintText: '03XXXXXXXXX',
                                    hintStyle:
                                        TextStyle(color: Colors.grey[500]),
                                  ),
                                ),
                              ),
                              //SizedBox(height: 5.0),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(color: Colors.grey[100]),
                                  ),
                                ),
                                height: 72,
                                child: TextFormField(
                                  validator: (val) {
                                    if (val.isEmpty) {
                                      return "Please enter a Password.";
                                    }
                                    if (val.length < 8) {
                                      return "Password is too weak.";
                                    }
                                    if (val != confirmpass) {
                                      return "Passwords do not match.";
                                    }
                                    //return "";
                                  },
                                  onSaved: (val) {
                                    setState(() {
                                      _admin.password = val;
                                    });
                                  },
                                  onChanged: (val) {
                                    password = val;
                                  },
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        // Based on passwordVisible state choose the icon
                                        _togglePassword1
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: Colors.black87,
                                      ),
                                      onPressed: () {
                                        // Update the state i.e. toogle the state of passwordVisible variable
                                        setState(() {
                                          _togglePassword1 = !_togglePassword1;
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
                                  obscureText: !_togglePassword1,
                                ),
                              ),

                              //SizedBox(height: 5.0),
                              Container(
                                height: 72,
                                child: TextFormField(
                                  keyboardType: TextInputType.text,
                                  validator: (val) {
                                    if (val.isEmpty) {
                                      return "Please enter your Password again.";
                                    }
                                    if (val.length < 8) {
                                      return "Password is too weak.";
                                    }
                                    if (val != password) {
                                      return "Passwords do not match.";
                                    }
                                    //return "";
                                  },
                                  onChanged: (val) {
                                    confirmpass = val;
                                  },
                                  decoration: InputDecoration(
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
                                    labelText: 'CONFIRM PASSWORD',
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
                        SizedBox(height: 25.0),
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
                                  'DONE\t',
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
                            splashColor: Colors.purple[300],
                            onPressed: () async {
                              final form = _formKey.currentState;
                              if (form.validate()) {
                                form.save();
                                setState(() {
                                  loader = true;
                                });

                                if (await FirebaseManager.signupAdmin(_admin)) {
                                  await Alert(
                                    type: AlertType.success,
                                    context: context,
                                    title: "SignUp Complete.",
                                    desc: "Let's Get Started.",
                                    style: AlertStyle(
                                        animationDuration:
                                            Duration(milliseconds: 400)),
                                    alertAnimation: FadeAlertAnimation,
                                    buttons: [
                                      DialogButton(
                                        child: Text(
                                          'Proceed',
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
                                } else {
                                  Alert(
                                    type: AlertType.warning,
                                    context: context,
                                    title: "There Was a Problem.",
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
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 35.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Already have an account?',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(width: 5.0),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(_createRoute());
                      },
                      child: Text(
                        'Login',
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
    },
  );
}
