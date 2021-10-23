import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'signup.dart';
import 'adminNav.dart';
import 'userNav.dart';
import 'Home/home.dart';
import 'forgotpassword.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:CrimeBuzz/Home/location.dart';
import 'package:transparent_image/transparent_image.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(MyApp());
}

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   Firebase.initializeApp();

//   SharedPreferences preferences = await SharedPreferences.getInstance();
//   var email = preferences.getString('email');
//   runApp(MaterialApp(
//     home: email == null ? MyApp() : HomePage(),
//   ));
// }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Custom Theme',
      theme: ThemeData(
        fontFamily: 'Montserrat',
        brightness: Brightness.light,
        primaryColor: Colors.red[600],
        accentColor: Colors.red[500],
      ),
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        '/myHome': (BuildContext context) => MyHomePage(),
        '/signup': (BuildContext context) => SignupPage(),
        '/home': (BuildContext context) => HomePage(),
        '/fpass': (BuildContext context) => FPPage(),
        '/locsearch': (BuildContext context) => SearchLocation(),
      },
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Image myImage;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 150),
    );
    _animationController.forward();
    myImage = Image.asset("assets/bg8.jpg");
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(myImage.image, context);
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
            child: FadeInImage(
              //height: 1000,
              placeholder: MemoryImage(kTransparentImage),
              image: AssetImage('assets/bg8.jpg'),
            ),

            // decoration: BoxDecoration(
            //   image: DecorationImage(
            //     image: AssetImage('assets/bg7.jpg'),
            //     fit: BoxFit.cover,
            //   ),
            // ),
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
                        'Crime',
                        style: TextStyle(
                            fontSize: 80.0,
                            fontWeight: FontWeight.w700,
                            color: Colors.white),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(20.0, 135.0, 0.0, 0.0),
                      child: Text(
                        'Buzz',
                        style: TextStyle(
                            fontSize: 80.0,
                            fontWeight: FontWeight.w700,
                            color: Colors.white),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(243.0, 135.0, 0.0, 0.0),
                      child: Text(
                        '.',
                        style: TextStyle(
                            fontSize: 80.0,
                            fontWeight: FontWeight.w700,
                            color: Colors.red[500]),
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
                padding: EdgeInsets.only(top: 380.0, right: 35.0, left: 35.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    //SizedBox(height: 40.0),
                    SizedBox(
                      height: 70.0,
                      width: 360.0,
                      child: RaisedButton(
                          padding: EdgeInsets.fromLTRB(95, 18, 20, 20),
                          color: Colors.red[600],
                          elevation: 7.0,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: Colors.red[600],
                            ),
                            borderRadius: BorderRadius.circular(35.0),
                          ),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                MdiIcons.accountCircle,
                                color: Colors.white,
                                size: 32,
                              ),
                              Text(
                                '\tUSER\t',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22.0,
                                  letterSpacing: 1.5,
                                ),
                              ),
                              // Icon(
                              //   MdiIcons.accountCircle,
                              //   color: Colors.white,
                              //   size: 32,
                              // ),
                            ],
                          ),
                          onPressed: () =>
                              {Navigator.of(context).push(_createRouteL())}),
                    ),
                    SizedBox(height: 25.0),
                    SizedBox(
                      height: 70.0,
                      width: 360.0,
                      child: RaisedButton(
                        padding: EdgeInsets.fromLTRB(95, 18, 20, 20),
                        color: Colors.purpleAccent[700],
                        elevation: 7.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(35.0),
                        ),
                        child: Row(
                          children: <Widget>[
                            Icon(
                              MdiIcons.pencil,
                              color: Colors.white,
                              size: 30,
                            ),
                            Text(
                              '\tADMIN\t',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 22.0,
                                letterSpacing: 1.5,
                              ),
                            ),
                            // Icon(
                            //   MdiIcons.pencil,
                            //   color: Colors.white,
                            //   size: 30,
                            // ),
                          ],
                        ),
                        splashColor: Colors.purpleAccent[700],
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
    pageBuilder: (context, animation, secondaryAnimation) => AdminNavPage(),
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
    pageBuilder: (context, animation, secondaryAnimation) => UserNavPage(),
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
