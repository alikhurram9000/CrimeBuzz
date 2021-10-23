// import 'package:CrimeBuzz/Home/location.dart';
import 'package:CrimeBuzz/Home/report.dart';
// import 'package:CrimeBuzz/main.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:CrimeBuzz/internal/reporter.dart';
import 'package:CrimeBuzz/internal/FirebaseManager.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'dart:async';
import 'dart:typed_data';
// import 'package:flutter/services.dart';

// import 'package:CrimeBuzz/Home/location.dart';

class Ongoing extends StatefulWidget {
  final String userEmail;
  Ongoing({Key key, @required this.userEmail}) : super(key: key);

  @override
  _OngoingState createState() => _OngoingState();
}

class _OngoingState extends State<Ongoing> {
  String userEmail = '';

  int noOfReports = 0;
  List<Reports> listOfReports = [];

  void fillReportsList() async {
    print("==============================================================");

    var tempListOfReports = await Reports.getListOfReports(userEmail);

    setState(() {
      listOfReports = tempListOfReports;
      listOfReports.sort((a, b) => b.timeStamp.compareTo(a.timeStamp));
      noOfReports = listOfReports.length;
    });
  }

  @override
  void initState() {
    super.initState();
    //getUserEmail();
    userEmail = widget.userEmail;
    fillReportsList();
    print('EMAIL:');
    print(userEmail);
    print('NUMBER OF REPORTS: $noOfReports');
  }

  bool loader = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Ongoing",
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
          valueColor: AlwaysStoppedAnimation<Color>(Colors.red[700]),
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
                'Reports',
                style: TextStyle(
                  fontSize: 32,
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
            Text('No Ongoing Reports',
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
                        radius: 40,
                        child: Icon(
                          Icons.report,
                          size: 80,
                          color: Colors.blue[400],
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
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.cancel_rounded,
                      color: Colors.red,
                      size: 36,
                    ),
                    onPressed: () {
                      Alert(
                        //type: AlertType.warning,
                        image: Image.network(
                          "https://img.icons8.com/color/480/000000/cancel--v1.png",
                          width: 80,
                        ),
                        context: context,
                        title: "Do You Want To Cancel This Report?",
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
                            color: Colors.red,
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
                            color: Colors.blue,
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
                              if (await FirebaseManager.CancelReport(
                                  userEmail, reports)) {
                                Alert(
                                  type: AlertType.success,
                                  context: context,
                                  title: "Report Cancelled",
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
                                setState(() {
                                  loader = false;
                                });
                              }
                            },
                          ),
                        ],
                      ).show();
                    },
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
