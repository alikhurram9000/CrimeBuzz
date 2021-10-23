import "package:CrimeBuzz/internal/FirebaseManager.dart";

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

class Reporter {
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

  static Future<String> getReporterName(String email) async {
    String name;
    final reps = await FirebaseManager().getReporterName(email);
    for (var rep in reps.docs) {
      print('In reporter.getReporterName() for $email');
      name = rep.data()['name'];
      return name;
    }

    return null;
  }
}

class Reports {
  String aEmail;
  String aName;
  String rEmail;
  String name;
  String address;
  String type;
  String notes;
  var timeStamp;
  int state;

  Reports() {
    aEmail = '';
    aName = '';
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
    aName = report.data()['aName'];
    rEmail = report.data()['email'];
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

  static Future<List<Reports>> getListOfReports(String userEmail) async {
    print("+++++++++++++++++++++++++++++++++");
    List<Reports> listOfReports = [];
    final reports = await FirebaseManager().getOngoingReportsForUser(userEmail);

    for (var report in reports.docs) {
      print(report.data());
      Reports tempReports = new Reports();
      tempReports.setReportValues(report);
      tempReports.display();
      listOfReports.add(tempReports);
    }

    if (listOfReports.isEmpty) {
      print('Empty List Of reports is Empty in ++++++');
    }
    return listOfReports;
  }

  static Future<List<Reports>> getListOfPastReports(String userEmail) async {
    print("+++++++++++++++++++++++++++++++++");
    List<Reports> listOfReports = [];
    final reports = await FirebaseManager().getPastReportsForUser(userEmail);

    for (var report in reports.docs) {
      print(report.data());
      Reports tempReports = new Reports();
      tempReports.setReportValues(report);
      tempReports.display();
      listOfReports.add(tempReports);
    }

    if (listOfReports.isEmpty) {
      print('Empty List Of reports is Empty in ++++++');
    }
    return listOfReports;
  }

  static Future<List<Reports>> getListOfPastReportsAdmin(String aEmail) async {
    print("+++++++++++++++++++++++++++++++++");
    List<Reports> listOfReports = [];
    final reports = await FirebaseManager().getPastReportsForAdmin(aEmail);

    for (var report in reports.docs) {
      print(report.data());
      Reports tempReports = new Reports();
      tempReports.setReportValues(report);
      tempReports.display();
      listOfReports.add(tempReports);
    }

    if (listOfReports.isEmpty) {
      print('Empty List Of reports is Empty in ++++++');
    }
    return listOfReports;
  }

  static Future<List<Reports>> getListOfAlerts(String userEmail) async {
    print("+++++++++++++++++++++++++++++++++");
    List<Reports> listOfReports = [];
    final reports = await FirebaseManager().getAlertsForUser(userEmail);

    for (var report in reports.docs) {
      print(report.data());
      Reports tempReports = new Reports();
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
