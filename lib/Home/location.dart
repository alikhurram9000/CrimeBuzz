import 'dart:convert';

// import 'package:CrimeBuzz/main.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart';
import 'dart:async';
import 'dart:typed_data';
import 'package:geolocator/geolocator.dart' as geol;
import 'package:geocoder/geocoder.dart' as geoc;
import 'package:CrimeBuzz/Home/home.dart' as home;
import 'package:CrimeBuzz/Home/report.dart';
import 'dart:io';

class SearchLocation extends StatefulWidget {
  @override
  _SearchLocationState createState() => _SearchLocationState();
}

class _SearchLocationState extends State<SearchLocation> {
  GoogleMapController mapController;

  String searchAddr = '';
  Set<Marker> myMarker;

  geoc.Address _address;
  StreamSubscription<Position> _streamSubscription;
  var _position;

  @override
  void initState() {
    super.initState();
    myMarker = Set.from([]);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  bool check = false;

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
          'Search Location',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: GestureDetector(
        child: Stack(
          children: <Widget>[
            GoogleMap(
              myLocationButtonEnabled: true,
              zoomControlsEnabled: false,
              onTap: (pos) {
                Marker m = Marker(
                    markerId: MarkerId('1'),
                    icon: BitmapDescriptor.defaultMarker,
                    position: pos,
                    draggable: true,
                    onDragEnd: (pos) {
                      setState(() {
                        // Geolocator.getPositionStream()
                        //     .listen((Position position) {
                        //   setState(() {
                        //     _position = position;
                        //   });
                        //
                        // });
                        _position = pos;

                        final coord =
                            new geoc.Coordinates(pos.latitude, pos.longitude);
                        convertCoordinatesToAddress(coord)
                            .then((value) => _address = value);
                      });
                    });
                setState(
                  () {
                    myMarker.add(m);

                    // Geolocator.getPositionStream().listen((Position position) {
                    //   setState(() {
                    //     _position = position;
                    //   });
                    // });
                    _position = pos;

                    final coord =
                        new geoc.Coordinates(pos.latitude, pos.longitude);
                    convertCoordinatesToAddress(coord)
                        .then((value) => _address = value);
                    sleep(const Duration(milliseconds: 450));
                    print(pos);
                    print(_address.addressLine);
                    check = true;
                  },
                );
              },
              markers: myMarker,
              onMapCreated: (controller) {
                mapController = controller;
              },
              initialCameraPosition: CameraPosition(
                  target: LatLng(33.655734, 73.015852), zoom: 14.0),
            ),
            Positioned(
              top: 5.0,
              right: 15.0,
              left: 15.0,
              child: Container(
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey[400],
                        blurRadius: 25.0, // soften the shadow
                        spreadRadius: 5.0, //extend the shadow
                        offset: Offset(
                          15.0, // Move to right 10  horizontally
                          15.0, // Move to bottom 10 Vertically
                        ),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(40.0),
                    color: Colors.white),
                child: TextField(
                  decoration: InputDecoration(
                      hintText: 'Search',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
                      suffixIcon: IconButton(
                          icon: Icon(Icons.search),
                          onPressed: () {
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());
                            searchandNavigate();
                          },
                          iconSize: 30.0)),
                  onChanged: (val) {
                    searchAddr = val;
                  },
                ),
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
                          print("${_address?.addressLine ?? '-'}");
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
              height: double.infinity,
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
                          Navigator.of(context)
                              .push(_createRouteReport(_address, _position));
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> searchandNavigate() async {
    var loc = await geoc.Geocoder.local.findAddressesFromQuery(searchAddr);
    var first = loc.first;
    geoc.Coordinates gc = first.coordinates;
    print(first.coordinates);

    mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(gc.latitude, gc.longitude), zoom: 17.4)));
  }

  Future<geoc.Address> convertCoordinatesToAddress(
      geoc.Coordinates coordinates) async {
    var addresses =
        await geoc.Geocoder.local.findAddressesFromCoordinates(coordinates);
    return addresses.first;
  }
}

Route _createRouteReport(geoc.Address a1, var p1) {
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

// void onMapCreated(controller) {
//   setState(() {
//     mapController = controller;
//   });
// }
