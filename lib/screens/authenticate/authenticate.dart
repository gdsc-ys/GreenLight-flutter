import 'package:flutter/material.dart';
import 'package:green_light/screens/authenticate/register.dart';
import 'package:green_light/screens/authenticate/sign_in.dart';
import 'package:green_light/screens/home/createaccountview.dart';
import 'package:green_light/screens/home/loginview.dart';


class Authenticate extends StatefulWidget {
  const Authenticate({super.key});

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  // 로그인인지 회원가입인지 구분,, 다른 방식으로 구현해도 괜찮음
  bool showSignIn = true;

  void toggleView() {
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn){
      return LoginView(toggleView: toggleView);
    } else {
      return CreateAccountView(toggleView: toggleView);
    }
    // if (showSignIn){
    //   return SignIn(toggleView: toggleView);
    // } else {
    //   return Register(toggleView: toggleView);
    // }
  }
}