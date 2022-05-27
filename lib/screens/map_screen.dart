import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:navigatio/utils/colors.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:rxdart/rxdart.dart';

import '../providers/user_provider.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Completer<GoogleMapController> _controller = Completer();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Geoflutterfire geo = Geoflutterfire();
  Location location = new Location();
  Set<Marker> _markers = Set<Marker>();
  BehaviorSubject<double> radius = BehaviorSubject<double>.seeded(100.0);
  late Stream<dynamic> query;
  late StreamSubscription subscription;

  void _animateToUser() async {
    LocationData pos = await location.getLocation();
    print(pos.latitude);
    print(pos.longitude);
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(pos.latitude!, pos.longitude!),
      zoom: 11.0,
    )));
    print(_controller);
  }

  void _updateMarker(List<DocumentSnapshot> documentList) async {
    var pos = await location.getLocation();
    double? lat = pos.latitude;
    double? lng = pos.longitude;

    // Make a referece to firestore
    var ref = firestore.collection('locations');
    GeoFirePoint center = geo.point(latitude: lat!, longitude: lng!);

    _markers.clear();
    documentList.forEach((DocumentSnapshot document) {
      GeoPoint geopoint = document.get(['position'])['geopoint'];
      double? distance =
          center.kmDistance(lat: geopoint.latitude, lng: geopoint.longitude);

      setState(() {
        _markers.add(Marker(
            markerId: MarkerId(document.id),
            position: LatLng(document.get(['position'])['geopoint'].latitude,
                document.get(['position'])['geopoint'].longitude),
            icon: BitmapDescriptor.defaultMarker,
            infoWindow: InfoWindow(
                title:
                    'Magic Marker distance is $distance km from query center')));
      });
    });
  }

  _startQuery() async {
    // Get users location
    var pos = await location.getLocation();
    double? lat = pos.latitude;
    double? lng = pos.longitude;

    // Make a referece to firestore
    var ref = firestore.collection('locations');
    GeoFirePoint center = geo.point(latitude: lat!, longitude: lng!);
    // subscribe to query
    subscription = radius.switchMap((rad) {
      print(rad);
      return geo.collection(collectionRef: ref).within(
            center: center,
            radius: rad,
            field: 'position',
            strictMode: true,
          );
    }).listen(_updateMarker);
  }

  _updateQuery(value) async {
    print(value);
    final zoomMap = {
      100.0: 12.0,
      200.0: 10.0,
      300.0: 7.0,
      400.0: 6.0,
      500.0: 5.0
    };
    final zoom = zoomMap[value];
    final GoogleMapController controller = await _controller.future;
    controller.moveCamera(CameraUpdate.zoomTo(zoom!));

    setState(() {
      radius.add(value);
    });
  }

  @override
  dispose() {
    subscription.cancel();
    super.dispose();
  }

  Future<DocumentReference> _addGeoPoint() async {
    LocationData pos = await location.getLocation();
    GeoFirePoint point =
        geo.point(latitude: pos.latitude!, longitude: pos.longitude!);
    return firestore
        .collection('locations')
        .add({'position': point.data, 'name': "User"});
  }

  void initState() {
    _animateToUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Stack(children: [
        GoogleMap(
          markers: _markers,
          initialCameraPosition: CameraPosition(
            target: LatLng(21.1458, 79.2882),
            zoom: 11.0,
          ),
          myLocationEnabled: true,
          compassEnabled: true,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
            _startQuery();
          },
        ),
        Positioned(
            bottom: 50,
            right: 10,
            child: FlatButton(
                child: Icon(Icons.pin_drop),
                color: blueColor,
                onPressed: () {
                  _addGeoPoint();
                })),
        Positioned(
            bottom: 50,
            left: 10,
            child: Material(
                child: Slider(
              min: 100.0,
              max: 500.0,
              divisions: 4,
              value: radius.value,
              label: 'Radius ${radius.value}km',
              activeColor: Colors.green,
              inactiveColor: Colors.green.withOpacity(0.2),
              onChanged: _updateQuery,
            )))
      ]),
    );
  }
}
