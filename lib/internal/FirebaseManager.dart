import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:CrimeBuzz/internal/reporter.dart';
import 'package:CrimeBuzz/internal/admin.dart';
// import 'package:geocoder/geocoder.dart';
// import 'package:geolocator/geolocator.dart';

class FirebaseManager {
  static final _auth = FirebaseAuth.instance;
  static final _firestore = FirebaseFirestore.instance;
  User loggedInUser;

  static Future<bool> signupReporter(Reporter reporter) async {
    String email = reporter.email;
    String password = reporter.password;
    String name = reporter.name;
    String number = reporter.number;

    bool authentic = false;
    //register using auth, and add in firestore
    try {
      final newReporter = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (newReporter != null) {
        authentic = true;
      }
    } catch (e) {
      print(e);
    }

    if (authentic) {
      try {
        final docRef = await _firestore.collection('Reporters').add({
          'email': email,
          'name': name,
          'password': password,
          'number': number,
        });

        if (docRef != null) {
          print('added to table');
          return true;
        }
      } catch (e) {
        print(e.toString());
      }
    }

    return false;
  }

  static Future<bool> signupAdmin(Admins admin) async {
    String email = admin.email;
    String password = admin.password;
    String name = admin.name;
    String number = admin.number;

    bool authentic = false;
    //register using auth, and add in firestore
    try {
      final newAdmin = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (newAdmin != null) {
        authentic = true;
      }
    } catch (e) {
      print(e);
    }

    if (authentic) {
      try {
        final docRef = await _firestore.collection('Admins').add({
          'email': email,
          'name': name,
          'password': password,
          'number': number,
        });

        if (docRef != null) {
          print('added to table');
          return true;
        }
      } catch (e) {
        print(e.toString());
      }
    }

    return false;
  }

  static Future<bool> validUserLogin(String email, String password) async {
    String emaile = email;
    try {
      final user = await _auth.signInWithEmailAndPassword(
          email: emaile, password: password);
      if (user != null) {
        return true;
      }
    } catch (e) {
      print(e);
    }

    return false;
  }

  static Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        //print(loggedInUser.email);
      }
    } catch (e) {
      print('couldnt get current user');
    }
  }

  Future<QuerySnapshot> getReporterName(
      String reporterEmail) async //gets email address returns name
  {
    return await _firestore
        .collection('Reporters')
        .where('email', isEqualTo: reporterEmail)
        .get();
  }

  Future<QuerySnapshot> getAdminName(
      String reporterEmail) async //gets email address returns name
  {
    return await _firestore
        .collection('Admins')
        .where('email', isEqualTo: reporterEmail)
        .get();
  }

  Future<QuerySnapshot> getOngoingReportsForUser(String reporterEmail) async {
    print("99999999999999999999999999");
    return await _firestore
        .collection('reportsubmit')
        .where('email', isEqualTo: reporterEmail)
        .where('state', isEqualTo: 1)
        //.orderBy('timeStamp', descending: false)
        .get();
  }

  Future<QuerySnapshot> getPastReportsForUser(String reporterEmail) async {
    print("99999999999999999999999999");
    return await _firestore
        .collection('reportsubmit')
        .where('email', isEqualTo: reporterEmail)
        .where('state', isEqualTo: 3)
        //.orderBy('timeStamp', descending: false)
        .get();
  }

  Future<QuerySnapshot> getPastReportsForAdmin(String aEmail) async {
    print("99999999999999999999999999");
    return await _firestore
        .collection('reportsubmit')
        .where('aEmail', isEqualTo: aEmail)
        .where('state', isEqualTo: 3)
        //.orderBy('timeStamp', descending: false)
        .get();
  }

  Future<QuerySnapshot> getAlertsForUser(String userEmail) async {
    return await _firestore
        .collection('reportsubmit')
        .where('state', isEqualTo: 1)
        .get();
  }

  static Future<bool> SubmitReport(
      String email,
      String name,
      String type,
      String address,
      String notes,
      double lat,
      double long,
      String other) async {
    try {
      final docRef = await _firestore.collection('reportsubmit').add({
        'aEmail': '',
        'aName': '',
        'email': email,
        'name': name,
        'type': type,
        'address': address,
        'notes': notes,
        'latitude': lat,
        'longitude': long,
        'state': 1,
        'other': other,
        'timeStamp': DateTime.now(),
      });

      if (docRef != null) {
        print('added to table');
        return true;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  // static Future<bool> AdminSubmitReport(
  //   String aEmail,
  //   String rEmail,
  //   String name,
  //   String type,
  //   String address,
  //   String notes,
  // ) async {
  //   try {
  //     final docRef = await _firestore.collection('adminReportHist').add({
  //       'aEmail': aEmail,
  //       'rEmail': rEmail,
  //       'name': name,
  //       'type': type,
  //       'address': address,
  //       'notes': notes,
  //       'state': 3,
  //       'timeStamp': DateTime.now(),
  //     });

  //     if (docRef != null) {
  //       print('added to table');
  //       return true;
  //     }
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }

  static Future<bool> CancelReport(String email, Reports report) async {
    try {
      var state = await _firestore
          .collection('reportsubmit')
          .where('email', isEqualTo: email)
          .where('address', isEqualTo: report.address)
          .where('type', isEqualTo: report.type)
          .where('timeStamp', isEqualTo: report.timeStamp)
          .get();

      if (state.docs.length == 0) {
        return false;
      }

      String docID = '';
      for (var s in state.docs) {
        docID = s.id;
      }

      await FirebaseFirestore.instance
          .collection('reportsubmit')
          .doc(docID)
          .update({'state': 3});
    } catch (e) {
      print(e.toString());
    }
    return true;
  }

  // ignore: non_constant_identifier_names
  static Future<bool> FinishReport(
      String aEmail, String aName, String rEmail, Reports report) async {
    try {
      var state = await _firestore
          .collection('reportsubmit')
          .where('email', isEqualTo: rEmail)
          .where('name', isEqualTo: report.name)
          .where('address', isEqualTo: report.address)
          .where('type', isEqualTo: report.type)
          .where('timeStamp', isEqualTo: report.timeStamp)
          .get();

      if (state.docs.length == 0) {
        return false;
      }

      String docID = '';
      for (var s in state.docs) {
        docID = s.id;
      }

      await FirebaseFirestore.instance
          .collection('reportsubmit')
          .doc(docID)
          .update({
        'aEmail': aEmail,
        'aName': aName,
        'state': 3,
      });
    } catch (e) {
      print(e.toString());
    }
    return true;
  }

  static Future<bool> DeleteReport(String email, Reports report) async {
    try {
      var state = await _firestore
          .collection('reportsubmit')
          .where('email', isEqualTo: email)
          .where('address', isEqualTo: report.address)
          .where('type', isEqualTo: report.type)
          .where('timeStamp', isEqualTo: report.timeStamp)
          .get();

      if (state.docs.length == 0) {
        return false;
      }

      String docID = '';
      for (var s in state.docs) {
        docID = s.id;
      }

      await FirebaseFirestore.instance
          .collection('reportsubmit')
          .doc(docID)
          .delete();
    } catch (e) {
      print(e.toString());
    }
    return true;
  }
}
