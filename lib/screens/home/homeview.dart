import 'package:flutter/material.dart';
import 'package:green_light/screens/home/loginview.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        heroTag: 'loginBtn',
        backgroundColor: const Color(0xff5DC86C),
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LoginView(),
            ),
          );
        },
      ),
      backgroundColor: Colors.red,
    );
  }
}