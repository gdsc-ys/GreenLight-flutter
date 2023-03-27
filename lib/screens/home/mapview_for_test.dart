import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:green_light/models/user.dart';
import 'package:green_light/screens/home/redlightview.dart';
import 'package:green_light/screens/home/rlcertificationview.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

// 단순히 마커 표시하는 기능하고 마커 onTap기능만 있는 맵
class MapView extends StatefulWidget {
  const MapView({required this.showMarkers, super.key});

  final Future<Set<Marker>>? showMarkers;
  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {

  late GoogleMapController _mapController;
  List<Marker> _markers = [];

  var db = FirebaseFirestore.instance;

  DocumentReference<Map<String, dynamic>>? userRef;
  GL_User? user;
  File? _image;
  final picker = ImagePicker();
  int? reporting;
  
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      rootBundle.loadString("assets/style/map_style.txt").then((value) => {
        _mapStyle = value
      });
    });

    user = Provider.of<GL_User?>(context, listen: false);

    _getUserInfo();

    _loadMarkers();
    _subscribeToMarkers();
  }

  String _mapStyle = "";

  LatLng _center = LatLng(37.561563, 126.937433);

  void _onMapCreated(GoogleMapController controller) async {
    _mapController = controller;
    _mapController.setMapStyle(_mapStyle);
  }

  Future<String> _getAddress() async {
    final location = Coordinates(_center.latitude, _center.longitude);
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

  void _getUserInfo() {
    db.collection("users").where("uid", isEqualTo: user!.uid).get().then((QuerySnapshot<Map<String, dynamic>> value) {
      setState(() {
        userRef = value.docs[0].reference;
        reporting = value.docs[0].data()['reporting'];
      });
    });
  }

  void _loadMarkers() async {
    final markersSnapshot = await FirebaseFirestore.instance
        .collection('greenlights')
        .get();

    BitmapDescriptor redLight= await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(),
      "assets/images/redspot.png"
    );
    BitmapDescriptor greenLight= await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(),
      "assets/images/greenspot.png"
    );

    final markers = markersSnapshot.docs
        .map((doc) => Marker(
              markerId: MarkerId(doc.id),
              position: LatLng(doc['lat'], doc['lng']),
              icon: doc['visit'] == 2 ? greenLight: redLight,
              onTap: doc['visit'] == 2 ? () {} : () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RLCertificationView(markerID: doc.id,)),
                );
              },
            ))
        .toList();

    setState(() {
      _markers = markers;
    });
  }

  void _subscribeToMarkers() async {

    BitmapDescriptor redLight= await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(),
      "assets/images/redspot.png"
    );
    BitmapDescriptor greenLight= await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(),
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
                onTap: doc['visit'] == 2 ? () {} : () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RLCertificationView(markerID: doc.id,)),
                  );
                }
              ))
          .toList();

      setState(() {
        _markers = markers;
      });
    });
  }

    Future getImage(ImageSource imageSource) async {
    final image = await picker.pickImage(source: imageSource);
    // ignore: use_build_context_synchronously
    GL_User? user = Provider.of<GL_User?>(context, listen: false);
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

        debugPrint("0000000000000000");

        final imageURL = await storageRef.getDownloadURL();

        debugPrint(reporting.toString());
        debugPrint("1111111111111111");

        await userRef!.update({"reporting": reporting! + 1});

        debugPrint("22222222222222222222");

        final data = {
          "lat": _center.latitude,
          "lng": _center.longitude,
          "title": redlightTitleDescription[0],
          "message": redlightTitleDescription[1],
          "imageURL": imageURL,
          "visit": 0,
          "imagePath": path, 
        };

        debugPrint("333333333333333333");

        await db.collection("greenlights").add(data);

        debugPrint("444444444444444444");
        
      } catch (e) {
        debugPrint("file is not uploaded");
        debugPrint(e.toString());
      }

    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp(
        home: Scaffold(
          body: GoogleMap(
            myLocationEnabled: false,
            mapToolbarEnabled: false,
            compassEnabled: false,
            markers: Set.from(_markers),
            onMapCreated: _onMapCreated,
            zoomGesturesEnabled: false,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 16.0,
            ),
          ),
          floatingActionButton: FloatingActionButton(
            heroTag: 'cameraBtn',
            backgroundColor: const Color(0xff5DC86C),
            child: const Icon(Icons.add),
            onPressed: () async {
              getImage(ImageSource.camera);
            },
          ),
        ),
      ),
    );
  }
}