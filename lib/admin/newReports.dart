import 'package:flutter/material.dart';
import 'package:CrimeBuzz/internal/reporter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
// import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:intl/intl.dart';
import 'package:CrimeBuzz/internal/FirebaseManager.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:CrimeBuzz/Home/report.dart';
import 'package:CrimeBuzz/admin/adminHome.dart';

// import 'dart:async';
// import 'dart:typed_data';
// import 'package:flutter/services.dart';

// import 'package:CrimeBuzz/Home/location.dart';

class NewReports extends StatefulWidget {
  final String adminEmail;
  final String adminName;

  NewReports({Key key, @required this.adminEmail, this.adminName})
      : super(key: key);

  @override
  _NewReportsState createState() => _NewReportsState();
}

class _NewReportsState extends State<NewReports> {
  String userEmail = '';

  String adminEmail = '';

  int noOfReports = 0;
  List<Reports> listOfReports = [];

  void fillReportsList() async {
    print("==============================================================");

    var tempListOfReports = await Reports.getListOfAlerts(userEmail);

    setState(() {
      listOfReports = tempListOfReports;
      listOfReports.sort((a, b) => b.timeStamp.compareTo(a.timeStamp));
      noOfReports = listOfReports.length;
    });
  }

  String cUName = '';
  String adminName = '';

  void getUserEmail() async {
    //gets current user

    FirebaseManager firebaseM = FirebaseManager();
    await firebaseM.getCurrentUser();

    setState(() {
      adminEmail = firebaseM.loggedInUser.email;
    });
  }

  void getUserName() async {
    //gets current user

    FirebaseManager firebaseM = FirebaseManager();
    await firebaseM.getCurrentUser();

    String namee = await Reporter.getReporterName(adminEmail);

    setState(() {
      adminName = namee;
    });
  }

  @override
  void initState() {
    super.initState();
    // getUserEmail();
    fillReportsList();

    print('NUMBER OF REPORTS: $noOfReports');
  }

  bool loader = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.greenAccent[700],
        title: Text(
          "New Reports",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
      ),
      body: ModalProgressHUD(
        inAsyncCall: loader,
        opacity: 0.3,
        progressIndicator: CircularProgressIndicator(
          strokeWidth: 6,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.purpleAccent[700]),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            Container(
              margin: EdgeInsets.only(left: 30),
              alignment: Alignment.topLeft,
              child: Text(
                'Last 24 Hours',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: showReports(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget showReports(BuildContext context) {
    setState(() {
      loader = false;
    });
    if (noOfReports == 0) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Opacity(
              opacity: 0.5,
              child: Icon(
                Icons.block_rounded,
                color: Colors.grey,
                size: 200,
              ),
            ),
            Text('No Current Alerts',
                style: TextStyle(
                  fontSize: 20,
                  color: Color.fromRGBO(128, 128, 128, 0.5),
                  fontWeight: FontWeight.bold,
                )),
          ],
        ),
      );
    }
    return Container(
      child: ListView.builder(
        itemCount: listOfReports.length,
        itemBuilder: (context, index) =>
            itemBuilder(context, listOfReports[index]),
      ),
    );
  }

  Widget itemBuilder(BuildContext context, Reports reports) {
    if (reports.state == 1) {
      int diff = DateTime.now().difference(reports.timeStamp).inDays;
      var time = DateFormat.Hm().format(reports.timeStamp);

      print("+++++++++++++");
      print(diff);
      if (diff <= 1) {
        return Align(
          child: InkWell(
            onTap: () {},
            child: Container(
              margin: EdgeInsets.only(top: 15, bottom: 15),
              width: 350,
              height: 166,
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 30,
                          child: Icon(
                            Icons.notification_important,
                            size: 60,
                            color: Colors.amberAccent[400],
                          )),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              reports.type,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold),
                            ),
                            Flexible(
                              flex: 2,
                              child: Text(
                                reports.address,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              reports.name,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          '$time',
                          style: TextStyle(
                            color: Colors.purpleAccent[700],
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.check_circle,
                            color: Colors.greenAccent[700],
                            size: 36,
                          ),
                          onPressed: () {
                            Alert(
                              //type: AlertType.warning,
                              image: Image.network(
                                "https://img.icons8.com/fluent/240/000000/checked.png",
                                width: 80,
                              ),
                              context: context,
                              title: "Finish Report?",
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
                                    Navigator.pop(context);
                                    setState(() {
                                      loader = true;
                                    });

                                    if (await FirebaseManager.FinishReport(
                                        widget.adminEmail,
                                        widget.adminName,
                                        reports.rEmail,
                                        reports)) {
                                      Alert(
                                        type: AlertType.success,
                                        context: context,
                                        title: "Report Finished",
                                        style: AlertStyle(
                                            animationDuration:
                                                Duration(milliseconds: 400)),
                                        alertAnimation: FadeAlertAnimation,
                                        buttons: [
                                          DialogButton(
                                            color: Colors.purpleAccent[700],
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
                                      setState(() {
                                        loader = false;
                                      });
                                    }

                                    setState(() {
                                      loader = false;
                                    });
                                  },
                                ),
                              ],
                            ).show();
                          },
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
  }
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
