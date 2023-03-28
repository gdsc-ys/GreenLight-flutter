import 'package:flutter/material.dart';
import 'package:green_light/models/user.dart';
import 'package:green_light/screens/home/home.dart';
import 'package:green_light/screens/home/loginview.dart';
import 'package:provider/provider.dart';


class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<GL_User?>(context);

    if (user == null){
      return const LoginView();

    } else {
      return const Home();
    }
  }
}