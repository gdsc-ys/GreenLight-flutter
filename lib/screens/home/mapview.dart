import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geocoder/geocoder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:green_light/models/user.dart';
import 'package:green_light/screens/home/redlightview.dart';
import 'package:green_light/services/location.dart';
import 'package:green_light/services/permission.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;


class MapView extends StatefulWidget {
  const MapView({required this.showMarkers, super.key});

  final Future<Set<Marker>>? showMarkers;
  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {

  Set<Marker> _showMarkers = {};

  late GoogleMapController _mapController;

  var db = FirebaseFirestore.instance;

  LocationData? currentLocation;

  String _mapStyle = "";

  final LatLng _center = const LatLng(45.521563, -122.677433);

  GL_User? user;

  void _onMapCreated(GoogleMapController controller) async {
    _mapController = controller;
    _mapController.setMapStyle(_mapStyle);
  }


  @override
  void initState() {
    super.initState();

    widget.showMarkers?.then((value) {
      setState(() {
        _showMarkers = value;
      });
    });

    SchedulerBinding.instance.addPostFrameCallback((_) {
      rootBundle.loadString("assets/style/map_style.txt").then((value) => {
        _mapStyle = value
      });
      _getUserLocation(context);
    });
  }

  Future<void> _getUserLocation(BuildContext context) async {
    PermissionUtils.requestPermission(Permission.location, context,
      isOpenSettings: true, permissionGrant: () async {
        print("already granted");
        await LocationService().fetchCurrentLocation(context, updatePosition: updateCameraPosition);
      },
      permissionDenied: () {
        Fluttertoast.showToast(
          msg: 'Please grant the required permission from settings to access this feature.',
          backgroundColor: Colors.grey,
        );
    });
  }

  void updateCameraPosition(CameraPosition cameraPosition) {
    _mapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  File? _image;
  final picker = ImagePicker();

  Future<void> getCurrentLocation() async {
    Location location = Location();

    location.getLocation().then(
      (location) {
        setState(() {
          currentLocation = location;
        });
      }
    );
  }

    // 사진 찍었을 때 현재 위치 주소를 한글로 돌려줌
  // ※ 추가해야할 것: firebase에 마커의 형태로 red light 보이도록
  Future<String> _getAddress() async {
    final location = new Coordinates(currentLocation!.latitude, currentLocation!.longitude);
    var address = await Geocoder.local.findAddressesFromCoordinates(location);
    var first = address.first;

    var _baseUrl = 'https://translation.googleapis.com/language/translate/v2';

    var translateKey = "AIzaSyCOFoK0d47ESiNBgJPlnwMv-y65W1XvFOo";

    var to = 'ko';

    var result_cloud_google = first.addressLine;

    // 번역 API

    var response = await http.post(
      Uri.parse('${_baseUrl}?target=${to}&key=${translateKey}&q=${first.addressLine}'),
    );

    if (response.statusCode == 200) {
      var dataJson = jsonDecode(response.body);
      result_cloud_google = dataJson['data']['translations'][0]['translatedText'];
    }

    return result_cloud_google!;

  }

  Future getImage(ImageSource imageSource) async {
    await getCurrentLocation();
    final image = await picker.pickImage(source: imageSource);

    var param = false;

    setState(() {
      if (image != null){
        _image = File(image.path); // 가져온 이미지를 _image에 저장

        param = true;
      }
    });

    if (param){

      var address = await _getAddress();
      List<String> redlightTitleDescription = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => RedLightView(address: address,))
        );

      final path = 'red_lights/${user!.uid}_${DateTime.now().millisecondsSinceEpoch}';

      final storageRef = FirebaseStorage.instance.ref().child(path);
      try {
        await storageRef.putFile(_image!);

        final imageURL = await storageRef.getDownloadURL();

        final data = {
          "lat": currentLocation!.latitude,
          "lng": currentLocation!.longitude,
          "title": redlightTitleDescription[0],
          "message": redlightTitleDescription[1],
          "imageURL": imageURL,
          "visit": 0,
        };
        
        db.collection("greenlights").add(data);
        
      } catch (e) {
        debugPrint("file is not uploaded");
        debugPrint(e.toString());
      }

    }
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: GoogleMap(
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          mapToolbarEnabled: false,
          markers: _showMarkers,
          onMapCreated: _onMapCreated,
          zoomGesturesEnabled: false,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 18.0,
          ),
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: 'cameraBtn',
          backgroundColor: const Color(0xff5DC86C),
          child: const Icon(Icons.add),
          onPressed: () async {

            getImage(ImageSource.camera);

            user = Provider.of<GL_User?>(context, listen: false);


            // final redLightRef = storageRef.child("red_lights/${user.uid}_${DateTime.now().millisecondsSinceEpoch}.jpg");

            // final cameras = await availableCameras();

            // final firstCamera = cameras.first;

            // debugPrint(firstCamera.name);
            // debugPrint(firstCamera.toString());

            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => const CameraView(),
            //   ),
            // );
          },
          // onPressed: () async {
          //   await availableCameras().then((value) => Navigator.push(context,
          //       MaterialPageRoute(builder: (_) => CameraPage(cameras: value))));
          // },
        ),
      ),
    );
  }
}