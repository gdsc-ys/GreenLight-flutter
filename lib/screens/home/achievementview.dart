import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AchievementView extends StatefulWidget {
  const AchievementView({Key? key}) : super(key: key);

  @override
  State<AchievementView> createState() => _AchievementViewState();
}

class _AchievementViewState extends State<AchievementView> {
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
            'Achievement',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 24,
              color: Color(0xff141C27),
            ),
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Color(0xffF2F3F5),
        child: Column(
          children: <Widget>[
            _buildGreenLight(),
            _buildReporting(),
            _buildTumbler(),
            _buildReusable(),
          ],
        ),
      ),
    );
  }
}

Widget _buildGreenLight() {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      color: Color(0xff5C5C5C),
    ),
    margin: EdgeInsets.only(top: 69.h, left: 24.w, right: 24.w),
    height: 100.h,
    child: Row(
      children: <Widget>[
        _greenLightPicture(),
        _greenLightContent(),
      ],
    ),
  );
}

Widget _greenLightPicture() {
  return Container(
    margin: EdgeInsets.only(left: 11.w),
    width: 80.w,
    height: 80.h,
    child: Image.asset(
      "assets/images/greenlightSqr.png",
      fit: BoxFit.fill,
    ),
  );
}
Widget _greenLightContent() {
  return Container(
    margin: EdgeInsets.only(left: 14.w),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(top: 14.h),
          child: const Text(
            "Greenlight",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xffFFFFFF),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 5.h),
          child: const Text(
            "그린라이트 첫 도전",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Color(0xffFFFFFF),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 5.h),
          child: Text(
            "그린라이트 5회 성공",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Color(0xffFFFFFF).withOpacity(0.33),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 5.h),
          child: Text(
            "그린라이트 10회 성공",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Color(0xffFFFFFF).withOpacity(0.33),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildReporting() {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      color: Color(0xff5C5C5C),
    ),
    margin: EdgeInsets.only(top: 30.h, left: 24.w, right: 24.w),
    height: 100.h,
    child: Row(
      children: <Widget>[
        _reportingPicture(),
        _reportingContent(),
      ],
    ),
  );
}

Widget _reportingPicture() {
  return Container(
    margin: EdgeInsets.only(left: 11.w),
    width: 80.w,
    height: 80.h,
    child: Image.asset(
      "assets/images/reporting.png",
      fit: BoxFit.fill,
    ),
  );
}
Widget _reportingContent() {
  return Container(
    margin: EdgeInsets.only(left: 14.w),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(top: 14.h),
          child: const Text(
            "Reporting",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xffFFFFFF),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 5.h),
          child: const Text(
            "레드라이트 처음으로 알리기",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Color(0xffFFFFFF),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 5.h),
          child: Text(
            "레드라이트 5회 알림",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Color(0xffFFFFFF).withOpacity(0.33),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 5.h),
          child: Text(
            "레드라이트 10회 알림",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Color(0xffFFFFFF).withOpacity(0.33),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildTumbler() {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      color: Color(0xff5C5C5C),
    ),
    margin: EdgeInsets.only(top: 30.h, left: 24.w, right: 24.w),
    height: 100.h,
    child: Row(
      children: <Widget>[
        _tumblerPicture(),
        _tumblerContent(),
      ],
    ),
  );
}

Widget _tumblerPicture() {
  return Container(
    margin: EdgeInsets.only(left: 11.w),
    width: 80.w,
    height: 80.h,
    child: Image.asset(
      "assets/images/tumblerSqr.png",
      fit: BoxFit.fill,
    ),
  );
}
Widget _tumblerContent() {
  return Container(
    margin: EdgeInsets.only(left: 14.w),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(top: 14.h),
          child: const Text(
            "Tumbler",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xffFFFFFF),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 5.h),
          child: const Text(
            "텀블러 첫 사용",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Color(0xffFFFFFF),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 5.h),
          child: Text(
            "텀블러 5회 사용",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Color(0xffFFFFFF).withOpacity(0.33),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 5.h),
          child: Text(
            "텀블러 10회 사용",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Color(0xffFFFFFF).withOpacity(0.33),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildReusable() {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      color: Color(0xff5C5C5C),
    ),
    margin: EdgeInsets.only(top: 30.h, left: 24.w, right: 24.w),
    height: 100.h,
    child: Row(
      children: <Widget>[
        _reusablePicture(),
        _reusableContent(),
      ],
    ),
  );
}

Widget _reusablePicture() {
  return Container(
    margin: EdgeInsets.only(left: 11.w),
    width: 80.w,
    height: 80.h,
    child: Image.asset(
      "assets/images/reusable.png",
      fit: BoxFit.fill,
    ),
  );
}
Widget _reusableContent() {
  return Container(
    margin: EdgeInsets.only(left: 14.w),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(top: 14.h),
          child: const Text(
            "Reusable Containers",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xffFFFFFF),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 5.h),
          child: const Text(
            "용기내 챌린지 첫 도전",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Color(0xffFFFFFF),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 5.h),
          child: Text(
            "용기내 챌린지 5회 성공",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Color(0xffFFFFFF).withOpacity(0.33),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 5.h),
          child: Text(
            "용기내 챌린지 10회 성공",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Color(0xffFFFFFF).withOpacity(0.33),
            ),
          ),
        ),
      ],
    ),
  );
}