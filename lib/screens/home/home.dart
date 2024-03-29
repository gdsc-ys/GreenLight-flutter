import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:green_light/models/map.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:green_light/screens/home/feedview.dart';
import 'package:green_light/screens/home/groupview.dart';
import 'package:green_light/screens/home/homeview_for_device.dart';
import 'package:green_light/screens/home/mapview_for_device.dart';
import 'package:provider/provider.dart';



class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  
  // an under bar
  final List<Widget> _widgetOptions = <Widget>[
    const HomeView(),
    const FeedPage(),
    MapView(showMarkers: markers, ),
    const GroupPage(),
  ];


  @override
  void initState() {
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // We initially planned to use garbage can data
  // But it has somewhat postponed until now
  static Future<Set<Marker>> get markers async {
    var db = FirebaseFirestore.instance;
    Set<Marker> showMarkers = {};
    QuerySnapshot<Map<String, dynamic>> garbages = await db.collection('garbages2').get();

    BitmapDescriptor garbageBox = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(),
      "assets/images/recycle-symbol.png"
    );

    for (int i = 0; i < garbages.size; i++){
      debugPrint(garbages.docs[i]['name']);
      showMarkers.add(
        Marker(
          markerId: MarkerId(garbages.docs[i]['name']),
          position: LatLng(garbages.docs[i]['lat'], garbages.docs[i]['lng']),
          icon: garbageBox,
        )
      );
    }

    return showMarkers;
  }

  // an index for under bar
  int _selectedIndex = 0;

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

