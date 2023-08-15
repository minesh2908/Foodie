import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../Auth/phoneVerify.dart';
import '../../config/colour.dart';

class CustomGoogleMap extends StatefulWidget {
  const CustomGoogleMap({super.key});

  @override
  State<CustomGoogleMap> createState() => _CustomGoogleMapState();
}

class _CustomGoogleMapState extends State<CustomGoogleMap> {
  Completer<GoogleMapController> _controller = Completer();
  String city='';
  String country='';
  String pincode='';
  String address='';
  static CameraPosition _kLake =
      CameraPosition(target: LatLng(26.2124, 78.1772), zoom: 10);
  String currentLocation = '';
  List<Marker> _marker = [];
  List<Marker> _list = [
    Marker(
        markerId: MarkerId('3'),
        position: LatLng(27.1751, 78.0421),
        infoWindow: InfoWindow(title: 'Taj Mahal'))
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _marker.addAll(_list);
  }

  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) {
      print(error.toString());
    });

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  final firestoreaddAddress = FirebaseFirestore.instance
      .collection('Users')
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .collection('address');

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          GoogleMap(
            zoomControlsEnabled: false,
            initialCameraPosition: _kLake,
            // myLocationButtonEnabled: false,
            myLocationEnabled: true,
            markers: Set<Marker>.of(_marker),
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
          Container(
            width: double.infinity,
            height: 150,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(
                  height: 20,
                  thickness: 2,
                  indent: 140,
                  endIndent: 140,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(12, 1, 12, 8),
                  child: Text(
                    currentLocation,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            print('object');
                            setState(() {
                                loading = true;
                              });
                            getUserCurrentLocation().then((value) async {
                              
                              print(
                                  '---------------------------------------------------');
                              print(value.latitude.toString() +
                                  ',' +
                                  value.longitude.toString());
                              _marker.add(Marker(
                                  markerId: MarkerId('1'),
                                  position:
                                      LatLng(value.latitude, value.longitude),
                                  infoWindow: InfoWindow(
                                      title: 'My Current Location')));
                              CameraPosition cameraPosition = CameraPosition(
                                  target:
                                      LatLng(value.latitude, value.longitude),
                                  zoom: 10);
                              final GoogleMapController controller =
                                  await _controller.future;
                              controller.animateCamera(
                                  CameraUpdate.newCameraPosition(
                                      cameraPosition));
                              

                              // List<Placemark> placemarks =
                              await placemarkFromCoordinates(
                                      value.latitude, value.longitude)
                                  .then((List<Placemark> placemarks) {
                                Placemark place = placemarks[0];
                                // print(placemarks[0].administrativeArea);
                                // print(placemarks[0].thoroughfare);
                                // print(placemarks[0].street);
                                currentLocation =
                                    "${placemarks[0].street}, ${placemarks[0].thoroughfare} ${placemarks[0].subLocality}, ${placemarks[0].locality}, ${placemarks[0].administrativeArea}, ${placemarks[0].country}, ${placemarks[0].postalCode}";
                                 address='${placemarks[0].street}, ${placemarks[0].thoroughfare} ${placemarks[0].subLocality}, ${placemarks[0].locality}';
                                 pincode='${placemarks[0].postalCode}';
                                 city='${placemarks[0].administrativeArea}';
                                 country='${placemarks[0].country}';
                               
                                print(currentLocation);
                                print(
                                    '-----------------------------------------------------');
                                    setState(() {
                                loading = false;
                              });
                                // print(place);
                              });
                              
                            });
                          },
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                                color: primaryColour,
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                                child: loading == true
                                    ? CircularProgressIndicator(color: Colors.white)
                                    : Text(
                                        'LOCATE ME',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black87),
                                      )),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PhoneVerify(city:city , country:country , pincode: pincode, address: address,)));
                          },
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                                color: Colors.black87,
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                                child: Text(
                              'CONTINUE',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: primaryColour),
                            )),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
