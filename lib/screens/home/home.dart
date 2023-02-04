import 'package:flutter/material.dart';
import 'package:green_light/screens/home/feedview.dart';
import 'package:green_light/screens/home/groupview.dart';
import 'package:green_light/screens/home/homeview.dart';
import 'package:green_light/screens/home/mapview.dart';
import 'package:green_light/services/auth.dart';



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
    HomeView(),
    FeedView(),
    MapView(),
    GroupView(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  int _selectedIndex = 0;

  // 아래는 언더바 뷰

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      backgroundColor: Colors.lightGreenAccent[50],
      appBar: AppBar(
        title: Text('Green Light'),
        backgroundColor: Colors.lightGreenAccent[400],
        elevation: 0.0,
        actions: <Widget>[
          TextButton.icon(
            onPressed: () async {
              await _auth.signOut();
            }, icon: Icon(Icons.person, color: Colors.white,), label: Text('Logout', style: TextStyle(color: Colors.white),)
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
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
        selectedLabelStyle: TextStyle(color: Colors.green),
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        unselectedLabelStyle: TextStyle(color: Colors.grey),
        showUnselectedLabels: true,
        onTap: _onItemTapped,
      ),
    );
  }
}

