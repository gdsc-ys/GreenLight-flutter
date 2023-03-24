import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:green_light/models/map.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:green_light/screens/home/feedview.dart';
import 'package:green_light/screens/home/groupview.dart';
import 'package:green_light/screens/home/homeview.dart';
import 'package:green_light/screens/home/mapview_for_device.dart';
import 'package:green_light/services/auth.dart';
import 'package:provider/provider.dart';

import 'package:location/location.dart';
import 'package:green_light/services/greenlight.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Home extends StatefulWidget {
  const Home({required this.uid, super.key});

  final String? uid;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  // String? get uid => widget.uid;
  static String? uid;

  // location 가져오기
  static Future<LocationData> get location async {
    LocationGreenLight inst = await LocationGreenLight();
    LocationData? location = await inst.fetchCurrentLocation();

    return location!;
  }

  int state = 0;

  // firebase의 유저 정보 연결
  final AuthService _auth = AuthService();

  @override
  void initState() {
    super.initState();
    String? uid = widget.uid;
  }

  // 언더바로 4개의 컨테츠 제공하는 코드
  final List<Widget> _widgetOptions = <Widget>[
  HomeView(location: location, uid: uid),
  FeedPage(),
  MapView(showMarkers: markers),
  GroupPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // 쓰레기통 마커 불러오려고 쓴 건데 일단은 보류하는 기능
  static Future<Set<Marker>> get markers async {
    var db = FirebaseFirestore.instance;
    Set<Marker> _showMarkers = {};
    QuerySnapshot<Map<String, dynamic>> garbages = await db.collection('garbages2').get();

    BitmapDescriptor garbage_box = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(),
      "assets/style/recycle-symbol.png"
    );

    BitmapDescriptor redLight= await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(),
      "assets/images/redspot.png"
    );

    for (int i = 0; i < garbages.size; i++){
      print(garbages.docs[i]['name']);
      _showMarkers.add(
        Marker(
          markerId: MarkerId(garbages.docs[i]['name']),
          position: LatLng(garbages.docs[i]['lat'], garbages.docs[i]['lng']),
          icon: garbage_box,
        )
      );
    }

    return _showMarkers;
  }

  // 언더바 회전을 위한 인덱스
  int _selectedIndex = 0;

  // 아래는 언더바 뷰

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ListenableProvider(create: (_) => MapProvider())],
      child: Scaffold(
          body: IndexedStack(
              index: _selectedIndex,
              children: _widgetOptions,
          ),
          backgroundColor: Colors.lightGreenAccent[50],
          bottomNavigationBar: Container(
            // ignore: prefer_const_constructors
            decoration: BoxDecoration(
            boxShadow: const <BoxShadow> [
              BoxShadow(
                color: Color(0xffD3D3D3),
                blurRadius: 25.0,
                offset: Offset(0.0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25.0),
              topRight: Radius.circular(25.0),
            ),
            child: SizedBox(
              height: 90,
              child: BottomNavigationBar(
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.dynamic_feed),
                    label: 'Feed',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.place),
                    label: 'Map',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.people_alt),
                    label: 'Group',
                  ),
                ],
                currentIndex: _selectedIndex,
                selectedLabelStyle: const TextStyle(color: Colors.green),
                selectedItemColor: Colors.green,
                unselectedItemColor: Colors.grey,
                unselectedLabelStyle: const TextStyle(color: Colors.grey),
                showUnselectedLabels: true,
                onTap: _onItemTapped,
                type: BottomNavigationBarType.fixed,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

