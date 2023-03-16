import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:green_light/screens/home/home.dart';
import 'dart:math';

class RedLightView extends StatefulWidget {
  const RedLightView({Key? key, required this.address}) : super(key: key);

  final String address;

  @override
  State<RedLightView> createState() => _RedLightViewState();
}

class _RedLightViewState extends State<RedLightView> {
  final _placeNameController = TextEditingController();
  final _greenMessageController = TextEditingController();

  @override
  void dispose() {
    _greenMessageController.dispose();
    _placeNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          padding: EdgeInsets.only(left: 24.w),
          icon: const Icon(Icons.arrow_back_ios),
          color: const Color(0xff8C939B),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: const Color(0xffFFFFFF),
        title: const Text(
          'Red Light Notification',
          style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 18,
              color: Colors.black
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Container(
            width: 390.w,
            height: 844.h,
            decoration: const BoxDecoration(
              color: Color(0xffFFFFFF),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _buildRedLightPlaceName(_placeNameController, widget.address),
                _buildRedLightMiddle(),
                _buildRedLightGreenMessage(_placeNameController,
                    _greenMessageController),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildRedLightPlaceName(TextEditingController placeNameController, String address) {
  return Container(
    child: Column(
      children: <Widget>[
        _placeName(),
        _placeInput(placeNameController),
        _myLocation(address),
      ],
    ),
  );
}

Widget _placeName() {
  return Container(
    alignment: Alignment.centerLeft,
    margin: EdgeInsets.only(left: 24.w, top: 30.h),
    child: const Text(
      'Place name',
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}

Widget _placeInput(TextEditingController placeNameController) {
  return Container(
    margin: EdgeInsets.only(top: 20.h, left: 24.w, right: 24.w),
    child: TextField(
      controller: placeNameController,
      decoration: const InputDecoration(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xffF2F3F5),
          ),
        ),
        hintText: 'Describe the place where there is trash',
        hintStyle: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w400,
          color: Color(0xff9D9D9D),
        ),
      ),
    ),
  );
}

Widget _myLocation(String address) {
  double radian = (360-22.08) * pi / 180;
  return Container(
    width: 342.w,
    height: 48.h,
    margin: EdgeInsets.only(top: 31.h),
    decoration: const BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(12.0)),
      color: Color(0xffFFFFFF),
      boxShadow: <BoxShadow> [
        BoxShadow(
          color: Color(0xffF2F3F5),
          blurRadius: 5.0,
          offset: Offset(0.0, 5),
        ),
      ],
    ),
    child: Row(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 3.h, left: 14.w),
          child: Transform.rotate(
            angle: radian,
            child: const Icon(
              Icons.near_me,
              size: 30,
              color: Color(0xffE6726C),
              shadows: <Shadow>[Shadow(color: Color(0xffE6726C), blurRadius: 10.0, offset: Offset(0, 0))],
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 6.8),
          child: const Text(
            '내 위치:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 4),
          child: Text(
            address,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildRedLightMiddle() {
  return Container(
    margin: EdgeInsets.only(top: 55.h),
    height: 16.h,
    color: const Color(0xffF2F3F5),
  );
}

Widget _buildRedLightGreenMessage(
    TextEditingController placeNameController,
    TextEditingController greenMessageController) {
  return Container(
    child: Column(
      children: <Widget>[
        _greenMessage(),
        _messageDetail(),
        _messageInput(greenMessageController),
        _registrationButton(placeNameController, greenMessageController),
      ],
    ),
  );
}

Widget _greenMessage() {
  return Container(
    alignment: Alignment.centerLeft,
    margin: EdgeInsets.only(left: 24.w, top: 35.h),
    child: const Text(
      'Green Message',
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}

Widget _messageDetail() {
  return Container(
    width: 345.w,
    height: 40.h,
    alignment: Alignment.centerLeft,
    margin: EdgeInsets.only(top: 19.h),
    child: const Text(
      'This message is sent to the neighbor who\nwill be turned greenlight.',
      style: TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w400,
      ),
    ),
  );
}

Widget _messageInput(TextEditingController greenMessageController) {
  return Container(
    height: 144.h,
    margin: EdgeInsets.only(top: 43.h, left: 24.w, right: 24.w),
    padding: EdgeInsets.only(bottom: 13.h),
    decoration: const BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(12.0)),
      color: Color(0xffFFFFFF),
      boxShadow: <BoxShadow> [
        BoxShadow(
          color: Color(0xffDFDFDF),
          blurRadius: 5.0,
          offset: Offset(0.0, 3),
        ),
      ],
    ),
    child: TextField(
      controller: greenMessageController,
      keyboardType: TextInputType.multiline,
      maxLines: 5,
      maxLength: 140,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          borderSide: BorderSide(
            color: Colors.transparent,
            width: 342.w,
          ),
        ),
        counterStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Color(0xffBFBFBF),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          borderSide: BorderSide(
            color: Colors.transparent,
            width: 342.w,
          ),
        ),
        hintText: 'Please leave support for your neighbors!',
        hintStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Color(0xffBFBFBF),
        ),
      ),
    ),
  );
}

Widget _registrationButton(
    TextEditingController placeNameController,
    TextEditingController greenMessageController) {
  Color buttonColor = const Color(0xffABB2BA);
  if ((placeNameController.text.isNotEmpty) && (greenMessageController.text.isNotEmpty)) {
    buttonColor = const Color(0xff5DC86C);
  } else {
    buttonColor = const Color(0xffABB2BA);
  }
  return Builder(
    builder: (context) {
      return Container(
        margin: EdgeInsets.only(top: 75.h, left: 24.w, right: 24.w),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(14)),
            ),
            backgroundColor: buttonColor,
            minimumSize: Size(342.w, 54.h),
            elevation: 0,
          ),
          onPressed: () {
            if (buttonColor == const Color(0xff5DC86C)) {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => const Home(),
              //   ),
              // );
              Navigator.pop(context, [placeNameController.text, greenMessageController.text]);
            }
          },
          child: const Text(
            'Registration',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
        ),
      );
    }
  );
}
