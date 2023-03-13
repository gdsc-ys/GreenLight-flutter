import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:green_light/models/map.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:green_light/screens/home/feedview.dart';
import 'package:green_light/screens/home/groupview.dart';
import 'package:green_light/screens/home/homeview.dart';
import 'package:green_light/screens/home/mapview.dart';
import 'package:green_light/services/auth.dart';
import 'package:provider/provider.dart';



class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  // firebase의 유저 정보 연결
  final AuthService _auth = AuthService();

  // 언더바로 4개의 컨테츠 제공하는 코드
  final List<Widget> _widgetOptions = <Widget>[
    const HomeView(),
    const FeedPage(),
    MapView(showMarkers: markers),
    const GroupPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static Future<Set<Marker>> get markers async {
    var db = FirebaseFirestore.instance;
    Set<Marker> showMarkers = {};
    QuerySnapshot<Map<String, dynamic>> garbages = await db.collection('garbages2').get();

    for (int i = 0; i < garbages.size; i++){
      print(garbages.docs[i]['name']);
      showMarkers.add(
        Marker(
          markerId: MarkerId(garbages.docs[i]['name']),
          position: LatLng(garbages.docs[i]['lat'], garbages.docs[i]['lng']),
        )
      );
    }

    return showMarkers;
  }

  int _selectedIndex = 0;

  // 아래는 언더바 뷰

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ListenableProvider(create: (_) => MapProvider())],
      child: Scaffold(
          // body: SafeArea(
          //   child: _widgetOptions.elementAt(_selectedIndex),
          // ),
          body: IndexedStack(
              index: _selectedIndex,
              children: _widgetOptions,
          ),
          backgroundColor: Colors.lightGreenAccent[50],
          appBar: AppBar(
            title: const Text('Green Light'),
            backgroundColor: Colors.lightGreenAccent[400],
            elevation: 0.0,
            actions: <Widget>[
              TextButton.icon(
                onPressed: () async {
                  await _auth.signOut();
                },
                  icon: const Icon(Icons.person, color: Colors.white,),
                  label: const Text('Logout', style: TextStyle(color: Colors.white),)
              ),
            ],
          ),
          bottomNavigationBar: Container(
            decoration: const BoxDecoration(
            boxShadow: <BoxShadow> [
              BoxShadow(
                color: Color(0xffDFDFDF),
                blurRadius: 13.0,
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
                    icon: Icon(Icons.dynamic_feed_sharp),
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
                selectedLabelStyle: const TextStyle(color: Color(0xff5DC86C),),
                selectedItemColor: const Color(0xff5DC86C),
                unselectedItemColor: const Color(0xff8C939B),
                unselectedLabelStyle: const TextStyle(color: Color(0xff8C939B),),
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

