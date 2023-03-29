import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:green_light/models/user.dart';
import 'package:green_light/services/painting.dart';
import 'package:green_light/screens/shared/loading.dart';
import 'package:provider/provider.dart';


// This file is just for user's detail data.
// We don't allow user to edit his or her information instantly.
class MyPageView extends StatefulWidget {
  const MyPageView({Key? key}) : super(key: key);

  @override
  State<MyPageView> createState() => _MyPageViewState();
}

class _MyPageViewState extends State<MyPageView> {
  GL_User? user;
  
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();


  final db = FirebaseFirestore.instance;

  String? userName = "";
  Timestamp? dateTime;
  int? height;
  int? weight;
  int? greenLight;
  int? container;
  int? reporting;
  int? tumbler;


  @override
  void initState() {
    super.initState();

    _getUserInfo();
  }

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  Future<void> _getUserInfo() async {
    GL_User? user = Provider.of<GL_User?>(context, listen: false);
    db.collection("users").where('uid', isEqualTo: user!.uid).get().then((userData) {
      setState(() {
        userName = userData.docs[0].data()['nickname'];
        dateTime = userData.docs[0].data()['date_of_birth'];
        height = userData.docs[0].data()['height'];
        weight = userData.docs[0].data()['weight'];
        greenLight = userData.docs[0].data()['greenlight'];
        container = userData.docs[0].data()['container'];
        tumbler = userData.docs[0].data()['tumbler'];
        reporting = userData.docs[0].data()['reporting'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return dateTime == null ? const Loading() : SafeArea(
      child: Scaffold(
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
              'My Page',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 24,
                color: Color(0xff141C27),
              ),
            ),
          ),
        ),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            child: Container(
              width: 390.w,
              height: 750.h,
              decoration: const BoxDecoration(
                color: Color(0xffF2F3F5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  _buildUsername(userName!),
                  _buildBirth("${dateTime!.toDate().year}. ${dateTime!.toDate().month}. ${dateTime!.toDate().day}"),
                  _buildHeightWeight(_heightController, _weightController, height.toString(), weight.toString()),
                  _buildMiddle(),
                  _buildAchievement(container!, greenLight!, reporting!, tumbler!),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildUsername(String userName) {
  return Container(
    margin: EdgeInsets.only(top: 45.h),
    child: Column(
      children: <Widget>[
        _usernameTitle(),
        _usernameInput(userName),
      ],
    ),
  );
}

Widget _usernameTitle() {
  return Container(
    margin: EdgeInsets.only(left: 24.w),
    alignment: Alignment.centerLeft,
    child: const Text(
      'User name',
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Color(0xff141C27),
      ),
    ),
  );
}

Widget _usernameInput(String userName) {
  return Container(
    width: 342.w,
    height: 55.h,
    margin: EdgeInsets.only(top: 12.h),
    child: TextField(
      readOnly: true,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xffFFFFFF),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none
        ),
        hintText: userName,
        hintStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Color(0xff676767),
        ),
      ),
    ),
  );
}

Widget _buildBirth(String dateTime) {
  return Container(
    margin: EdgeInsets.only(top: 20.h),
    child: Column(
      children: <Widget>[
        _birthTitle(),
        _birthInput(dateTime),
      ],
    ),
  );
}

Widget _birthTitle() {
  return Container(
    margin: EdgeInsets.only(left: 24.w),
    alignment: Alignment.centerLeft,
    child: const Text(
      'Date of Birth',
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Color(0xff141C27),
      ),
    ),
  );
}

Widget _birthInput(String dateTime) {
  return Container(
    width: 342.w,
    height: 55.h,
    margin: EdgeInsets.only(top: 12.h),
    child: TextField(
      readOnly: true,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xffFFFFFF),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none
        ),
        hintText: dateTime,
        hintStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Color(0xff676767),
        ),
      ),
    ),
  );
}

Widget _buildHeightWeight(TextEditingController heightController, TextEditingController weightController, String height, String weight) {
  return Container(
    margin: EdgeInsets.only(top: 20.h),
    child: Column(
      children: <Widget>[
        _heightWeightTitle(),
        _heightWeightInput(heightController, weightController, height, weight),
      ],
    ),
  );
}
Widget _heightWeightTitle() {
  return Container(
    margin: EdgeInsets.only(left: 24.w),
    child: Row(
      // ignore: prefer_const_literals_to_create_immutables
      children: <Widget>[
        const Text(
          'Height & Weight',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xff141C27),
          ),
        ),
      ],
    ),
  );
}

Widget _heightWeightInput(TextEditingController heightController, TextEditingController weightController, String height, String weight) {
  return Container(
    margin: EdgeInsets.only(top: 12.h),
    child: Row(
      children: <Widget>[
        _heightInput(heightController, height),
        _heightUnit(),
        _weightInput(weightController, weight),
        _weightUnit(),
      ],
    ),
  );
}

Widget _heightInput(TextEditingController heightController, String height) {
  return Container(
    width: 70.w,
    height: 55.h,
    margin: EdgeInsets.only(left: 24.w),
    child: TextField(
      controller: heightController,
      textAlign: TextAlign.center,
      keyboardType: TextInputType.number,
      readOnly: true,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xffFFFFFF),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none
        ),
        hintText: height,
        hintStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Color(0xff676767),
        ),
      ),
    ),
  );
}

Widget _heightUnit() {
  return Container(
    margin: EdgeInsets.only(left: 8.w),
    child: const Text(
      'cm',
      style: TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 14,
        color: Color(0xff676767),
      ),
    ),
  );
}

Widget _weightInput(TextEditingController weightController, String weight) {
  return Container(
    width: 70.w,
    height: 55.h,
    margin: EdgeInsets.only(left: 58.w),
    child: TextField(
      controller: weightController,
      textAlign: TextAlign.center,
      keyboardType: TextInputType.number,
      readOnly: true,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xffFFFFFF),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none
        ),
        hintText: weight,
        hintStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Color(0xff676767),
        ),
      ),
    ),
  );
}

Widget _weightUnit() {
  return Container(
    margin: EdgeInsets.only(left: 8.w),
    child: const Text(
      'kg',
      style: TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 14,
        color: Color(0xff676767),
      ),
    ),
  );
}

Widget _buildMiddle() {
  return Container(
    margin: EdgeInsets.only(top: 30.h, left: 24.w, right: 24.w),
    color: const Color(0xffC3C8CE),
    height: 2.h,
  );
}

Widget _buildAchievement(int container, int greenLight, int reporting, int tumbler) {
  return Container(
    margin: EdgeInsets.only(top: 30.h),
    child: Column(
      children: <Widget>[
        _achievementTitle(),
        _achievementContent(container, greenLight, reporting, tumbler),
      ],
    ),
  );
}

Widget _achievementTitle() {
  return Container(
    margin: EdgeInsets.only(left: 24.w),
    alignment: Alignment.centerLeft,
    child: const Text(
      'Achievement',
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Color(0xff141C27),
      ),
    ),
  );
}

Widget _achievementContent(int container, int greenLight, int reporting, int tumbler) {
  return Builder(
    builder: (context) {
      return Container(
        width: 342.w,
        height: 166.h,
        decoration: BoxDecoration(
          color: const Color(0xffFFFFF),
          borderRadius: BorderRadius.circular(10),
        ),
        margin: EdgeInsets.only(top: 12.h),
        child: InkWell(
          child: Row(
            children: <Widget>[
              _greenlight(greenLight),
              _reporting(reporting),

            ],
          ),
          onTap: () {
          },
        ),
      );
    }
  );
}

Widget _greenlight(int greenLight) {
  return Container(
    margin: EdgeInsets.only(top: 29.h, left: 100.w),
    child: Column(
      children: <Widget>[
        SizedBox(
          width: 64.w,
          height: 64.h,
          child: Stack(
            children: <Widget>[
              Image.asset(
                "assets/images/greenlightCir.png",
                fit: BoxFit.fill,
              ),
              CustomPaint(
                painter: PainterView(
                  degree: 360 * (greenLight / 5),
                  borderThickness: 4,
                  borderColor: const Color(0xff5DC86C),
                ),
                child: const SizedBox(
                  width: 60,
                  height: 60,
                )
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 10.h),
          child: const Text(
            "greenlight",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xff000000),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 11.h),
          child: Row(
            children: <Widget>[
              Text(
                greenLight.toString(),
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff000000),
                ),
              ),
              const Text(
                " / 5",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff838383),
                ),
              )
            ],
          ),
        )
      ],
    ),
  );
}

Widget _reporting(int reporting) {
  return Container(
    margin: EdgeInsets.only(top: 29.h, left: 14.w),
    child: Column(
      children: <Widget>[
        SizedBox(
          width: 64.w,
          height: 64.h,
          child: Stack(
            children: <Widget>[
              Image.asset(
                "assets/images/reportingCir.png",
                fit: BoxFit.fill,
              ),
              CustomPaint(
                  painter: PainterView(
                    degree: 360 * (reporting / 5),
                    borderThickness: 4,
                    borderColor: const Color(0xff5DC86C),
                  ),
                  child: const SizedBox(
                    width: 60,
                    height: 60,
                  )
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 10.h),
          child: const Text(
            "reporting",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xff000000),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 11.h),
          child: Row(
            children: <Widget>[
              Text(
                reporting.toString(),
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff000000),
                ),
              ),
              const Text(
                " / 5",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff838383),
                ),
              )
            ],
          ),
        )
      ],
    ),
  );
}