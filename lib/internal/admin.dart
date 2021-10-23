import "package:CrimeBuzz/internal/FirebaseManager.dart";

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Admins {
  String name = '';
  String number = '';
  String email = '';
  String password = '';

  save() {
    print(name);
    print(email);
    print(number);
    print(password);
  }

  static Future<String> getAdminName(String email) async {
    String name;
    final reps = await FirebaseManager().getAdminName(email);
    for (var rep in reps.docs) {
      print('In reporter.getReporterName() for $email');
      name = rep.data()['name'];
      return name;
    }

    return null;
  }
}

class AdminReports {
  String aEmail;
  String rEmail;
  String name;
  String address;
  String type;
  String notes;
  var timeStamp;
  int state;

  AdminReports() {
    aEmail = '';
    rEmail = '';
    name = '';
    address = '';
    type = '';
    notes = '';
    state = -1;
    timeStamp = null;
  }

  void setReportValues(var report) {
    aEmail = report.data()['aEmail'];
    rEmail = report.data()['rEmail'];
    name = report.data()['name'];
    address = report.data()['address'];
    type = report.data()['type'];
    notes = report.data()['notes'];
    state = report.data()['state'];
    timeStamp = report.data()['timeStamp'].toDate();
  }

  void display() {
    print('=======DISPLAYYYYYYYYYYYYYYY');
    print('$address');
    print('$type');
    print('$notes');
  }

  static Future<List<AdminReports>> getListOfReports(String userEmail) async {
    print("+++++++++++++++++++++++++++++++++");
    List<AdminReports> listOfReports = [];
    final reports = await FirebaseManager().getPastReportsForUser(userEmail);

    for (var report in reports.docs) {
      print(report.data());
      AdminReports tempReports = new AdminReports();
      tempReports.setReportValues(report);
      tempReports.display();
      listOfReports.add(tempReports);
    }

    if (listOfReports.isEmpty) {
      print('Empty List Of reports is Empty in ++++++');
    }
    return listOfReports;
  }
}
