import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginButton extends StatefulWidget {
  const LoginButton({super.key});

  @override
  State<LoginButton> createState() => _LoginButtonState();
}

class _LoginButtonState extends State<LoginButton> {

  Color buttonColor = const Color(0xffABB2BA);
  // if ((emailController.text.isNotEmpty) && (passwordController.text.isNotEmpty)) {
  //   buttonColor = const Color(0xff80CA4C);
  // } else {
  //   buttonColor = const Color(0xffABB2BA);
  // }
  
  @override
  Widget build(BuildContext context) {
      return Container(
        margin: EdgeInsets.only(top: 124.h, left: 20.w, right: 20.w),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            backgroundColor: buttonColor,
            minimumSize: Size(350.w, 60.h),
            elevation: 0,
          ),
          onPressed: () {
            if (buttonColor == const Color(0xff80CA4C)) {
            
              // debugPrint(emailController.text);
              // debugPrint(passwordController.text);

              
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => const Home()),
              // );
            }
          },
          child: const Text(
            'Login',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
        ),
      );
    }
}