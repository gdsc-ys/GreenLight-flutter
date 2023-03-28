import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_geocoder_alternative/flutter_geocoder_alternative.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart';
import 'package:green_light/models/user.dart';
import 'package:green_light/screens/home/redlightview.dart';
import 'package:green_light/screens/home/rlcertificationview.dart';
import 'package:green_light/screens/shared/loading.dart';
import 'package:green_light/services/distance.dart';
import 'package:green_light/services/permission.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';


// This map file uses google map api.
// And we added some additional functions.
// Such as current user location, setting markers of firestore and camera shotting.
// This file also reqeust to a location permission be granted
class MapView extends StatefulWidget {
  const MapView({required this.showMarkers, super.key});

  final Future<Set<Marker>>? showMarkers;
  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {

  var db = FirebaseFirestore.instance;

  Location location = Location();

  late GoogleMapController googleMapController;
  LocationData? currentLocation;
  final List<Marker> _markers = [];
  String _mapStyle = "";

  GL_User? user;
  DocumentReference<Map<String, dynamic>>? userRef;
  BitmapDescriptor userIcon = BitmapDescriptor.defaultMarker;
  int? reporting;
  String? userName;

  File? _image;
  final picker = ImagePicker();

  Future<void> _getCurrentLocation() async {
    location.onLocationChanged.listen(
      (newLoc) {
        setState(() {
          currentLocation = newLoc;
          _markers.add(
            Marker(
              markerId: const MarkerId("currentLocation"),
              icon: userIcon,
              position: LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
            )
          );
          googleMapController.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                zoom: 18.0,
                target: LatLng(
                  newLoc.latitude!,
                  newLoc.longitude!
                )
              ),
            )
          );
        });
      }
    );
  }

  void _onMapCreated(GoogleMapController controller) async {
    googleMapController = controller;
    googleMapController.setMapStyle(_mapStyle);
    _getCurrentLocation();
    _getUserLocation(context);
    _loadMarkers();
    _subscribeToMarkers();

    widget.showMarkers?.then((value) {
      setState(() {
        _markers.add(
          Marker(
            markerId: const MarkerId("currentLocation"),
            icon: userIcon,
            position: LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
          )
        );
      });
    });
  }

  void userIconSet() async {
    await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(), 
      "assets/images/user_location.png").then(
        (icon) {
          setState(() {
            userIcon = icon;
          });
        }
      );
  }

  void _getUserInfo() {
    db.collection("users").where("uid", isEqualTo: user!.uid).get().then((QuerySnapshot<Map<String, dynamic>> value) {
      setState(() {
        userRef = value.docs[0].reference;
        reporting = value.docs[0].data()['reporting'];
        userName = value.docs[0].data()['nickname'];
      });
    });
  }
  
  Future _getImageFromCamera(ImageSource imageSource) async {
    final image = await picker.pickImage(source: imageSource);

    var param = false;

    setState(() {
      if (image != null){
        _image = File(image.path);

        param = true;
      }
    });

    if (param){
      var address = await _getAddress();
      // ignore: use_build_context_synchronously
      List<String>? redlightTitleDescription = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => RedLightView(address: address,))
        );

      if (redlightTitleDescription != null){
        final path = 'red_lights/${user!.uid}_${DateTime.now().millisecondsSinceEpoch}';

        final storageRef = FirebaseStorage.instance.ref().child(path);
        try {
          await storageRef.putFile(_image!);

          final imageURL = await storageRef.getDownloadURL();

          await userRef!.update({"reporting": reporting! + 1});

          final dataOfGreenLight = {
            "lat": currentLocation!.latitude,
            "lng": currentLocation!.longitude,
            "title": redlightTitleDescription[0],
            "message": redlightTitleDescription[1],
            "imageURL": imageURL,
            "visit": 0,
            "imagePath": path,
            "address": address,
          };
          final dataOfCommunityEvent = {
            "date": Timestamp.now().toDate(),
            "type": 1,
            "nickname": userName,
          };
          await db.collection("greenlights").add(dataOfGreenLight);
          await db.collection("community_events").add(dataOfCommunityEvent);
          
        } catch (e) {
          debugPrint("file is not uploaded");
          debugPrint(e.toString());
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();

    userIconSet();

    user = Provider.of<GL_User?>(context, listen: false);

    rootBundle.loadString("assets/style/map_style.txt").then((value) => {
      _mapStyle = value
    });

    location.getLocation().then(
      (location) {
        setState(() {
          currentLocation = location;
        });
      }
    );
    _getUserInfo();
  }


  // get an address of current location
  Future<String> _getAddress() async {
    var address = await Geocoder().getAddressFromLonLat(currentLocation!.longitude!, currentLocation!.latitude!);
    return address;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: currentLocation == null
            ? const Loading()
            : GoogleMap(
          myLocationEnabled: false,
          mapToolbarEnabled: false,
          zoomControlsEnabled: false,
          myLocationButtonEnabled: false,
          rotateGesturesEnabled: false,
          tiltGesturesEnabled: false,
          
          markers: Set.from(_markers),
          zoomGesturesEnabled: false,
          initialCameraPosition: CameraPosition(
            target: LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
            zoom: 18.0,
          ),
          onMapCreated: _onMapCreated,
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: 'cameraBtn',
          backgroundColor: const Color(0xff5DC86C),
          child: const Icon(Icons.add),
          onPressed: () async {
            _getImageFromCamera(ImageSource.camera);
          },
        ),
      ),
    );
  }

  void _loadMarkers() async {
    final markersSnapshot = await FirebaseFirestore.instance
        .collection('greenlights')
        .get();

    BitmapDescriptor redLight= await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(),
      "assets/images/redspot.png"
    );
    BitmapDescriptor greenLight= await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(),
      "assets/images/greenspot.png"
    );

    final markers = markersSnapshot.docs
        .map((doc) => Marker(
              markerId: MarkerId(doc.id),
              position: LatLng(doc['lat'], doc['lng']),
              icon: doc['visit'] == 2 ? greenLight: redLight,
              onTap: doc['visit'] == 2 || calculateDistance(doc['lat'], doc['lng'], currentLocation!.latitude, currentLocation!.longitude) >= 0.05 ? () {
                debugPrint(calculateDistance(doc['lat'], doc['lng'], currentLocation!.latitude, currentLocation!.longitude).toString());
              } : () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RLCertificationView(markerID: doc.id,)),
                );
              },
            ))
        .toList();

    setState(() {
      _markers.addAll(markers);
    });
  }

  void _subscribeToMarkers() async {

    BitmapDescriptor redLight= await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(),
      "assets/images/redspot.png"
    );
    BitmapDescriptor greenLight= await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(),
      "assets/images/greenspot.png"
    );
    FirebaseFirestore.instance
        .collection('greenlights')
        .snapshots()
        .listen((event) {
      final markers = event.docs
          .map((doc) => Marker(
              markerId: MarkerId(doc.id),
              position: LatLng(doc['lat'], doc['lng']),
              icon: doc['visit'] == 2 ? greenLight: redLight,
              onTap: doc['visit'] == 2 || calculateDistance(doc['lat'], doc['lng'], currentLocation!.latitude, currentLocation!.longitude) >= 0.05 ? () {
                debugPrint(calculateDistance(doc['lat'], doc['lng'], currentLocation!.latitude, currentLocation!.longitude).toString());
              } : () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RLCertificationView(markerID: doc.id,)),
                );
              },
            ))
          .toList();

      setState(() {
        _markers.addAll(markers);
      });
    });
  }
  Future<void> _getUserLocation(BuildContext context) async {
    PermissionUtils.requestPermission(Permission.location, context,
      isOpenSettings: true, permissionGrant: () async {
        debugPrint("already granted");
      },
      permissionDenied: () {
        Fluttertoast.showToast(
          msg: 'Please grant the required permission from settings to access this feature.',
          backgroundColor: Colors.grey,
        );
    });
  }
}
