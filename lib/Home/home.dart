import 'package:CrimeBuzz/Home/alerts.dart';
import 'package:CrimeBuzz/Home/help.dart';
import 'package:CrimeBuzz/Home/history.dart';
import 'package:CrimeBuzz/Home/location.dart';
import 'package:CrimeBuzz/Home/ongoing.dart';
import 'package:CrimeBuzz/Home/report.dart';
import 'package:CrimeBuzz/main.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:CrimeBuzz/internal/reporter.dart';
import 'package:CrimeBuzz/internal/FirebaseManager.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart' as geol;
import 'package:geocoder/geocoder.dart';
// import 'package:CrimeBuzz/Home/location.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool loader = false;

  String cUser = '';
  String cUName = '';

  String _cUser;
  String _cUName;

  Reporter cRep;
  String initials;

  void getUserEmail() async {
    //gets current user

    FirebaseManager firebaseM = FirebaseManager();
    await firebaseM.getCurrentUser();

    setState(() {
      cUser = firebaseM.loggedInUser.email;
      _cUser = cUser;
    });
  }

  void getUserName() async {
    //gets current user

    FirebaseManager firebaseM = FirebaseManager();
    await firebaseM.getCurrentUser();

    String namee = await Reporter.getReporterName(cUser);

    setState(() {
      cUName = namee;
      _cUName = cUName;
      initials = cUName.substring(0, 1);
    });
  }

  StreamSubscription<Position> _streamSubscription;
  Position _position;
  Address _address;

  @override
  void initState() {
    super.initState();
    getUserEmail();
    getUserName();

    var locationOptions = LocationOptions(
        accuracy: geol.LocationAccuracy.high, distanceFilter: 10);

    _streamSubscription =
        Geolocator.getPositionStream().listen((Position position) {
      setState(() {
        //print(position);
        _position = position;
        initialLocation = CameraPosition(
          target: LatLng(_position.latitude, _position.longitude),
          zoom: 14.4746,
        );

        final coordinates =
            new Coordinates(position.latitude, position.longitude);
        convertCoordinatesToAddress(coordinates)
            .then((value) => _address = value);
      });
    });
  }

  StreamSubscription _locationSubscription;
  Location _locationTracker = Location();
  Marker marker;
  Circle circle;
  GoogleMapController _controller;

  static CameraPosition initialLocation = CameraPosition(
    target: LatLng(33.655734, 73.015852),
    zoom: 12,
  );

  Future<Uint8List> getMarker() async {
    ByteData byteData =
        await DefaultAssetBundle.of(context).load("assets/loc10.png");
    return byteData.buffer.asUint8List();
  }

  void updateMarkerAndCircle(LocationData newLocalData, Uint8List imageData) {
    LatLng latlng = LatLng(newLocalData.latitude, newLocalData.longitude);
    this.setState(() {
      marker = Marker(
          markerId: MarkerId("home"),
          position: latlng,
          rotation: 180.0,
          draggable: true,
          zIndex: 2,
          flat: true,
          //anchor: Offset(0.5, 0.5),
          icon: BitmapDescriptor.defaultMarker);
      //icon: BitmapDescriptor.fromBytes(imageData));
      // circle = Circle(
      //     circleId: CircleId("car"),
      //     radius: newLocalData.accuracy,
      //     zIndex: 1,
      //     strokeColor: Colors.greenAccent,
      //     center: latlng,
      //     fillColor: Colors.blue.withAlpha(70));
    });
  }

  void getCurrentLocation() async {
    try {
      Uint8List imageData = await getMarker();
      var location = await _locationTracker.getLocation();

      updateMarkerAndCircle(location, imageData);

      if (_locationSubscription != null) {
        _locationSubscription.cancel();
      }

      _locationSubscription = _locationTracker.onLocationChanged.listen(
        (newLocalData) {
          if (_controller != null) {
            _controller.animateCamera(CameraUpdate.newCameraPosition(
                new CameraPosition(
                    bearing: 180,
                    target:
                        LatLng(newLocalData.latitude, newLocalData.longitude),
                    tilt: 0,
                    zoom: 17.40)));
            updateMarkerAndCircle(newLocalData, imageData);
          }
        },
      );
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        print("Permission Denied");
      }
    }
  }

  @override
  void dispose() {
    if (_locationSubscription != null) {
      _locationSubscription.cancel();
    }
    super.dispose();
    _streamSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        title: Text(
          'Home',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      drawer: Drawer(
        elevation: 16.0,
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
                backgroundColor: Colors.blue,
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
            // ListTile(
            //   leading: Icon(
            //     Icons.account_circle,
            //     size: 30,
            //     //color: Colors.blue,
            //     color: Colors.grey[800],
            //   ),
            //   title: Text(
            //     'Account',
            //     style: TextStyle(
            //       fontSize: 17,
            //       fontWeight: FontWeight.w600,
            //     ),
            //   ),
            //   onTap: () => {},
            // ),
            ListTile(
              leading: Icon(
                Icons.cached,
                size: 30,
                //color: Colors.blue,
                color: Colors.grey[800],
              ),
              title: Text(
                'Ongoing',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onTap: () => {
                Navigator.of(context).push(_createRouteOngoing(cUser)),
              },
            ),
            ListTile(
              leading: Icon(
                Icons.history_rounded,
                size: 30,
                //color: Colors.blue,
                color: Colors.grey[800],
              ),
              title: Text(
                'History',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onTap: () => {
                Navigator.of(context).push(_createRouteHistory(cUser)),
              },
            ),
            ListTile(
              leading: Icon(
                Icons.notification_important_rounded,
                size: 30,
                //color: Colors.blue,
                color: Colors.grey[800],
              ),
              title: Text(
                'Alerts',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onTap: () => {
                Navigator.of(context).push(_createRouteAlerts(cUser)),
              },
            ),
            ListTile(
              leading: Icon(
                Icons.help_sharp,
                size: 30,
                //color: Colors.blue,
                color: Colors.grey[800],
              ),
              title: Text(
                'Help',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onTap: () => {
                Navigator.of(context).push(_createRouteHelp()),
              },
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

                // showDialog(
                //   context: context,
                //   builder: (BuildContext context) {
                //     return AlertDialog(
                //       elevation: 16,
                //       //title: Text('Are you sure you want to Logout?'),
                //       content: Text('Are you sure you want to Logout?'),
                //       actions: <Widget>[
                //         FlatButton(
                //           onPressed: () {
                //             Navigator.of(context).pop();
                //           },
                //           child: Text('No'),
                //         ),
                //         FlatButton(
                //           onPressed: () async {
                //             await FirebaseAuth.instance.signOut();
                //             Navigator.of(context).push(_createRouteS());
                //           },
                //           child: Text('Yes'),
                //         )
                //       ],
                //     );
                //   },
                // );
              },
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          Container(
            child: GoogleMap(
              myLocationButtonEnabled: true,
              padding: EdgeInsets.only(top: 20, right: 10),
              myLocationEnabled: true,
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
              zoomGesturesEnabled: true,
              rotateGesturesEnabled: true,
              mapType: MapType.normal,
              initialCameraPosition:
                  (initialLocation != null) ? initialLocation : [],
              markers: Set.of((marker != null) ? [marker] : []),
              circles: Set.of((circle != null) ? [circle] : []),
              onMapCreated: (GoogleMapController controller) {
                _controller = controller;
              },
            ),
          ),
          Container(
            child: Row(
              children: <Widget>[
                Padding(padding: EdgeInsets.only(left: 340, top: 105)),
                FloatingActionButton(
                    elevation: 10,
                    backgroundColor: Colors.blue,
                    child: Icon(Icons.location_searching_outlined),
                    onPressed: () {
                      getCurrentLocation();
                    }),
              ],
            ),
          ),
          Container(
            child: Center(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 605,
                  ),
                  SizedBox(
                    height: 50,
                    width: 375,
                    child: RaisedButton(
                      padding: EdgeInsets.only(
                        left: 32,
                        right: 10,
                      ),
                      elevation: 1,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        side: BorderSide(
                          color: Colors.black12,
                        ),
                      ),
                      child: Row(
                        children: <Widget>[
                          Flexible(
                            flex: 2,
                            child: Text(
                              "${_address?.addressLine ?? '-'}",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                                fontSize: 13.0,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                          // Icon(
                          //   Icons.report,
                          //   color: Colors.white,
                          //   size: 24,
                          // ),
                        ],
                      ),
                      onPressed: () {
                        Navigator.of(context).push(_createRouteSearch());
                        //Navigator.pushNamed(context, '/locsearch');
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 617, left: 24),
            child: Icon(
              Icons.location_pin,
              color: Colors.blue,
            ),
          ),
          Container(
            child: Column(
              children: <Widget>[
                Padding(padding: EdgeInsets.only(top: 670)),
                Center(
                  child: SizedBox(
                    height: 55,
                    width: 375,
                    child: RaisedButton(
                      padding: EdgeInsets.only(
                        left: 125,
                      ),
                      elevation: 7,
                      color: Colors.red[600],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                      child: Row(
                        children: <Widget>[
                          Text(
                            'REPORT\t',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 25.0,
                              letterSpacing: 1.5,
                            ),
                          ),
                          // Icon(
                          //   Icons.report,
                          //   color: Colors.white,
                          //   size: 24,
                          // ),
                        ],
                      ),
                      onPressed: () {
                        Navigator.of(context).push(_createRouteReport(
                            _address, _cUser, _cUName, _position));
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<Address> convertCoordinatesToAddress(Coordinates coordinates) async {
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    return addresses.first;
  }
}

//
Route _createRouteS() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => MyHomePage(),
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

Widget FadeAlertAnimation(BuildContext context, Animation<double> animation,
    Animation<double> secondaryAnimation, Widget child) {
  return Align(
    child: FadeTransition(
      opacity: animation,
      child: child,
    ),
  );
}

Route _createRouteSearch() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => SearchLocation(),
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

Route _createRouteReport(Address a1, String email, String name, Position p1) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => Report(
      address: a1,
      pos: p1,
    ),
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

Route _createRouteOngoing(String email) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        Ongoing(userEmail: email),
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

Route _createRouteHistory(String email) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        History(userEmail: email),
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

Route _createRouteAlerts(String email) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        Alerts(userEmail: email),
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

Route _createRouteHelp() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => Help(),
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
