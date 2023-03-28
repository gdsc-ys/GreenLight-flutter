import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class Launching extends StatelessWidget {
  const Launching({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.lightGreen,
            // backgroundColor: Colors.black,
            body: Container(
              margin: EdgeInsets.only(left: 137.w, top: 374.h),
              child: Image.asset(
                "assets/images/co2_image.png",
                width: 96.w,
                height: 96.h,
              ),
            ),
          )
        ),
      );
      }
    );
  }
}