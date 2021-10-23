// import 'package:CrimeBuzz/Home/location.dart';
// import 'package:CrimeBuzz/Home/report.dart';
// import 'package:CrimeBuzz/main.dart';
import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:CrimeBuzz/internal/reporter.dart';
// import 'package:CrimeBuzz/internal/FirebaseManager.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
// import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:intl/intl.dart';

// import 'dart:async';
// import 'dart:typed_data';
// import 'package:flutter/services.dart';

// import 'package:CrimeBuzz/Home/location.dart';

class Alerts extends StatefulWidget {
  final String userEmail;
  Alerts({Key key, @required this.userEmail}) : super(key: key);

  @override
  _AlertsState createState() => _AlertsState();
}

class _AlertsState extends State<Alerts> {
  String userEmail = '';

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
          "Alerts",
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
    if (reports.state == 1 && reports.rEmail != widget.userEmail) {
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
                          radius: 40,
                          child: Icon(
                            Icons.notification_important,
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
                    Text(
                      '$time',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
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
  }
}
