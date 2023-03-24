import 'package:flutter/material.dart';
import 'package:green_light/models/user.dart';
import 'package:green_light/screens/home/home.dart';
import 'package:green_light/screens/home/loginview.dart';
import 'package:provider/provider.dart';


class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    
    // 유저 없는 상태면 로그인하고 아니면 홈 뷰 보여줘라~
    // 세션 유지 어떻게 할지는 고민 해봐야 할 듯?? top 100 안에 들면..!

    final user = Provider.of<GL_User?>(context);

    if (user == null){
      return const LoginView();

    } else {
      // type 문제 때문에 일단 const는 빼놓았음
      return Home(uid: user.uid);
    }
  }
}