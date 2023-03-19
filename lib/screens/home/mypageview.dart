import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:green_light/screens/home/achievementview.dart';
import 'package:green_light/screens/home/rlcertificationview.dart';

class MyPageView extends StatefulWidget {
  const MyPageView({Key? key}) : super(key: key);

  @override
  State<MyPageView> createState() => _MyPageViewState();
}

class _MyPageViewState extends State<MyPageView> {
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

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
                _buildUsername(),
                _buildBirth(),
                _buildHeightWeight(_heightController, _weightController),
                _buildMiddle(),
                _buildAchievement(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildUsername() {
  return Container(
    margin: EdgeInsets.only(top: 45.h),
    child: Column(
      children: <Widget>[
        _usernameTitle(),
        _usernameInput(),
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

Widget _usernameInput() {
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
        hintText: 'Sa Yii',
        hintStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Color(0xff676767),
        ),
      ),
    ),
  );
}

Widget _buildBirth() {
  return Container(
    margin: EdgeInsets.only(top: 20.h),
    child: Column(
      children: <Widget>[
        _birthTitle(),
        _birthInput(),
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

Widget _birthInput() {
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
        hintText: '2000. 10. 21',
        hintStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Color(0xff676767),
        ),
      ),
    ),
  );
}

Widget _buildHeightWeight(TextEditingController heightController, TextEditingController weightController) {
  return Container(
    margin: EdgeInsets.only(top: 20.h),
    child: Column(
      children: <Widget>[
        _heightWeightTitle(),
        _heightWeightInput(heightController, weightController),
      ],
    ),
  );
}
Widget _heightWeightTitle() {
  return Container(
    margin: EdgeInsets.only(left: 24.w),
    child: Row(
      children: <Widget>[
        Container(
          child: const Text(
            'Height & Weight',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xff141C27),
            ),
          ),
        ),
        Builder(
          builder: (context) {
            return Container(
              margin: EdgeInsets.only(left: 143.w),
              child: InkWell(
                child: SizedBox(
                  width: 64.w,
                  height: 20.h,
                  child: Image.asset('assets/images/edit.png'),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RLCertificationView()),
                  );
                },
              ),
            );
          }
        ),
      ],
    ),
  );
}

Widget _heightWeightInput(TextEditingController heightController, TextEditingController weightController) {
  return Container(
    margin: EdgeInsets.only(top: 12.h),
    child: Row(
      children: <Widget>[
        _heightInput(heightController),
        _heightUnit(),
        _weightInput(weightController),
        _weightUnit(),
      ],
    ),
  );
}

Widget _heightInput(TextEditingController heightController) {
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
        hintText: '170',
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

Widget _weightInput(TextEditingController weightController) {
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
        hintText: '60',
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
    color: Color(0xffC3C8CE),
    height: 2.h,
  );
}

Widget _buildAchievement() {
  return Container(
    margin: EdgeInsets.only(top: 30.h),
    child: Column(
      children: <Widget>[
        _achievementTitle(),
        _achievementContent(),
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

Widget _achievementContent() {
  return Builder(
    builder: (context) {
      return Container(
        width: 342.w,
        height: 166.h,
        margin: EdgeInsets.only(top: 12.h),
        child: InkWell(
          child: Image.asset(
            'assets/images/achievements.png',
            fit: BoxFit.fill,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AchievementView()),
            );
          },
        ),
      );
    }
  );
}