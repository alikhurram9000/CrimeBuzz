import 'package:CrimeBuzz/admin/newReports.dart';
import 'package:CrimeBuzz/admin/adminHistory.dart';

import 'package:CrimeBuzz/internal/admin.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:CrimeBuzz/internal/FirebaseManager.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:CrimeBuzz/main.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';

class AdminHomePage extends StatefulWidget {
  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  String cUser = '';
  String cUName = '';
  Admins cRep;
  String initials;

  void getUserEmail() async {
    //gets current user

    FirebaseManager firebaseM = FirebaseManager();
    await firebaseM.getCurrentUser();

    setState(() {
      cUser = firebaseM.loggedInUser.email;
    });
  }

  void getUserName() async {
    //gets current user

    FirebaseManager firebaseM = FirebaseManager();
    await firebaseM.getCurrentUser();

    String namee = await Admins.getAdminName(cUser);

    setState(() {
      cUName = namee;
      initials = cUName.substring(0, 1);
    });
  }

  @override
  void initState() {
    super.initState();
    getUserEmail();
    getUserName();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.only(top: 1, left: 2),
          children: <Widget>[
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              accountName: Text(
                '$cUName',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black87,
                  fontWeight: FontWeight.w700,
                ),
              ),
              accountEmail: Text(
                '$cUser',
                style: TextStyle(
                  color: Colors.black87,
                ),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.purpleAccent[700],
                child: Text(
                  '$initials',
                  style: TextStyle(
                    fontSize: 40,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.logout,
                size: 30,
                //color: Colors.blue,
                color: Colors.grey[800],
              ),
              title: Text(
                'Logout',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onTap: () {
                Alert(
                  //type: AlertType.warning,
                  image: Image.network(
                    "https://img.icons8.com/metro/1024/000000/question-mark.png",
                    width: 60,
                  ),
                  context: context,
                  title: "Are you sure you want to Logout?",
                  //desc: "Please Try Again.",
                  style: AlertStyle(
                    titleStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    animationType: AnimationType.fromBottom,
                    animationDuration: Duration(milliseconds: 300),
                    alertAlignment: Alignment.bottomCenter,
                  ),
                  //alertAnimation: FadeAlertAnimation,
                  buttons: [
                    DialogButton(
                      radius: BorderRadius.circular(40.0),
                      color: Colors.purpleAccent[700],
                      child: Text(
                        'No',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 17),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    DialogButton(
                      radius: BorderRadius.circular(40.0),
                      color: Colors.greenAccent[700],
                      child: Text(
                        'Yes',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 17),
                      ),
                      onPressed: () async {
                        // SharedPreferences prefs =
                        //     await SharedPreferences.getInstance();
                        // prefs.remove('email');
                        await FirebaseAuth.instance.signOut();
                        Future.delayed(Duration(milliseconds: 400)).then((__) {
                          Navigator.of(context).push(_createRouteS());
                        });
                      },
                    ),
                  ],
                ).show();
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: <Widget>[
          Positioned(
            top: 310,
            left: -100,
            width: 700,
            height: 700,
            child: Container(
              //height: 1500,
              foregroundDecoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/footer1.png'),
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          ),
          Container(
            height: 250,
            decoration: BoxDecoration(
              image: DecorationImage(
                  alignment: Alignment.topCenter,
                  image: AssetImage('assets/top_header.png')),
            ),
          ),
          Positioned(
            left: 10,
            top: 22,
            child: IconButton(
              icon: Icon(MdiIcons.menu),
              iconSize: 28,
              color: Colors.white,
              onPressed: () => scaffoldKey.currentState.openDrawer(),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  Padding(padding: EdgeInsets.only(top: 5)),
                  Center(
                    child: Text(
                      'Admin\nHome.',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 50,
                      ),
                    ),
                  ),
                  Container(
                    height: 64,
                    margin: EdgeInsets.only(bottom: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          width: 16,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 0,
                  ),
                  Expanded(
                    child: GridView.count(
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      primary: false,
                      crossAxisCount: 2,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            Navigator.of(context)
                                .push(_createRouteAlerts(cUser, cUName));
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            elevation: 4,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SvgPicture.network(
                                  // 'https://www.flaticon.com/svg/static/icons/svg/2478/2478145.svg',
                                  'https://www.flaticon.com/svg/static/icons/svg/2478/2478147.svg',
                                  height: 128,
                                ),
                                Text(
                                  'New Reports',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context)
                                .push(_createRouteHistory(cUser));
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            elevation: 4,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SvgPicture.network(
                                  // 'https://www.flaticon.com/svg/static/icons/svg/538/538774.svg',
                                  'https://www.flaticon.com/svg/static/icons/svg/2972/2972431.svg',
                                  height: 128,
                                ),
                                Text(
                                  'History',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        // InkWell(
                        //   onTap: () {},
                        //   child: Card(
                        //     shape: RoundedRectangleBorder(
                        //         borderRadius: BorderRadius.circular(8)),
                        //     elevation: 4,
                        //     child: Column(
                        //       mainAxisAlignment: MainAxisAlignment.center,
                        //       children: <Widget>[
                        //         SvgPicture.network(
                        //           'https://www.flaticon.com/svg/static/icons/svg/1300/1300674.svg',
                        //           height: 128,
                        //         ),
                        //         Text(
                        //           'Logout',
                        //           style: TextStyle(
                        //             fontWeight: FontWeight.bold,
                        //             fontSize: 17,
                        //           ),
                        //         )
                        //       ],
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Route _createRouteS() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => MyHomePage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  Route _createRouteHistory(String email) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          AdminHistory(userEmail: email),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  Route _createRouteAlerts(String email, String name) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => NewReports(
        adminEmail: email,
        adminName: name,
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
