import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geocoder/geocoder.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

// 유저의 현 위치 추적까지 있는 맵
class MapView extends StatefulWidget {
  const MapView({required this.showMarkers, required this.location, required this.locChange, super.key});

  final Future<Set<Marker>>? showMarkers;
  final Function(LocationData newLoc) locChange;
  final Location location;
  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {

  GL_User? user;

  Set<Marker> _showMarkers = {};


  late GoogleMapController googleMapController;

  LocationData? currentLocation;

  DocumentReference<Map<String, dynamic>>? userRef;

  BitmapDescriptor userIcon = BitmapDescriptor.defaultMarker;

  var db = FirebaseFirestore.instance;

  List<Marker> _markers = [];

  String _mapStyle = "";

  int? reporting;

  String? userName;

  File? _image;
  final picker = ImagePicker();

  Future<void> getCurrentLocation() async {
    // 위치 업데이트
    widget.location.onLocationChanged.listen(
      (newLoc) {
        setState(() {
          widget.locChange(newLoc);
          currentLocation = newLoc;
          _markers.add(
            Marker(
              markerId: MarkerId("currentLocation"),
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
    // 현위치업데이트
    getCurrentLocation();
    // 현위치를 유저의 것으로 반영
    _getUserLocation(context);
    // 레드라이트 불러옴
    _loadMarkers();
    // 레드라이트들 변화 스트리밍
    _subscribeToMarkers();

    widget.showMarkers?.then((value) {
      setState(() {
        _markers.add(
          Marker(
            markerId: MarkerId("currentLocation"),
            icon: userIcon,
            position: LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
          )
        );
      });
    });
  }

  void userIconSet() async {
    await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(), 
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
  
  Future getImage(ImageSource imageSource) async {
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

    // 유저 아이콘 초기화 <= 솔직히 필요없음
    userIconSet();

    user = Provider.of<GL_User?>(context, listen: false);

    rootBundle.loadString("assets/style/map_style.txt").then((value) => {
      _mapStyle = value
    });

    widget.location.getLocation().then(
      (location) {
        setState(() {
          currentLocation = location;
        });
      }
    );
    _getUserInfo();
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
          scrollGesturesEnabled: false,
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
            getImage(ImageSource.camera);
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
        print("already granted");
      },
      permissionDenied: () {
        Fluttertoast.showToast(
          msg: 'Please grant the required permission from settings to access this feature.',
          backgroundColor: Colors.grey,
        );
    });
  }
}
