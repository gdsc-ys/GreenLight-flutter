import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RLCertificationView extends StatefulWidget {
  const RLCertificationView({Key? key}) : super(key: key);

  @override
  State<RLCertificationView> createState() => _RLCertificationViewState();
}

class _RLCertificationViewState extends State<RLCertificationView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        titleSpacing: 0,
        leading: Container(
          margin: EdgeInsets.only(left: 20.w),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            color: const Color(0xffC3C8CE),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        backgroundColor: const Color(0xffF2F3F5),
        title: Container(
          margin: EdgeInsets.only(left: 5.w),
          alignment: Alignment.centerLeft,
          child: const Text(
            'RLCertification',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 24,
              color: Color(0xff141C27),
            ),
          ),
        ),
      ),
      body: Center(
        child: Container(
          width: 342.w,
          height: 161.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            boxShadow: const <BoxShadow> [
              BoxShadow(
                color: Color(0xffD3D3D3),
                blurRadius: 10.0,
                offset: Offset(0.0, 5),
              ),
            ],
            color: const Color(0xffFFFFFF),
          ),
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 35.h),
                child: const Text(
                  "Arrived at the Red light section",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff000000),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 7.h),
                child: const Text(
                  "Please pick up the trash nearby",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                    color: Color(0xff000000),
                  ),
                ),
              ),
              InkWell(
                child: Container(
                  margin: EdgeInsets.only(top: 29.h, left: 12.w, right: 12.w),
                  height: 48.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0xff5DC86C),
                  ),
                  child: const Center(
                    child: Text(
                      "Certification",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xffFFFFFF),
                      ),
                    ),
                  ),
                ),
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
