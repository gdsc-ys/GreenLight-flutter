import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:green_light/screens/home/drawerview.dart';

class GroupPage extends StatelessWidget {
  const GroupPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const DrawerView(),
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xffF2F3F5),
        ),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildGroupTop1(),
            _buildGroupTop2(),
            _buildGroupSchedule(),
            _buildGroupMembers(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff5DC86C),
        child: const Icon(Icons.add),
        onPressed: () {},
      ),
    );

  }
}

Widget _buildGroupTop1() {
  return Builder(
    builder: (context) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 18.h),
            child: IconButton(
              iconSize: 30,
              constraints: const BoxConstraints(),
              onPressed: () {},
              icon: const Icon(Icons.search),
              color: const Color(0xff8C939B),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 18.h, right: 12.w),
            child: IconButton(
              iconSize: 30,
              constraints: const BoxConstraints(),
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
              icon: const Icon(Icons.menu),
              color: const Color(0xff8C939B),
            ),
          ),
        ],
      );
    },
  );
}

Widget _buildGroupTop2() {
  return Container(
    alignment: Alignment.centerLeft,
    margin: EdgeInsets.only(left: 24.w),
    child: const Text(
      'Group',
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: Color(0xff141C27),
        // fontFamily: 'Pretendard',
      ),
    ),
  );
}

Widget _buildGroupSchedule() {
  return Container(
    margin: EdgeInsets.only(top: 9.h, bottom: 10.h),
    decoration: const BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(20.0)),
      color: Color(0xffFFFFFF),
      boxShadow: <BoxShadow> [
        BoxShadow(
          color: Color(0xffD3D3D3),
          blurRadius: 10.0,
          offset: Offset(0.0, 5),
        ),
      ],
    ),
    width: 342.w,
    height: 101.h,
    child: Column(
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.only(left: 15.w, top: 21.h, bottom: 10.h),
          child: const Text(
            'Schedule',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xff141C27),
            ),
          ),
        ),
        Row(
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              width: 175.w,
              margin: EdgeInsets.only(left: 15.w, right: 70.w),
              child: const Text(
                'We have an activity scheduled in three days!',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff141C27),
                ),
              ),
            ),
            Container(
              width: 73.w,
              alignment: Alignment.centerRight,
              margin: EdgeInsets.only(right: 9.w),
              child: const Text(
                '03.02',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff141C27),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget _buildGroupMembers() {
  return Expanded(
    child: SizedBox(
      height: 500,
      child: GridView.count(
        padding: EdgeInsets.only(top: 13.h, left: 18.w, right: 18.w),
        scrollDirection: Axis.vertical,
        physics: const ScrollPhysics(),
        shrinkWrap: true,
        crossAxisCount: 2,
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              color: Color(0xffFFFFFF),
              boxShadow: <BoxShadow> [
                BoxShadow(
                  color: Color(0xffD3D3D3),
                  blurRadius: 10.0,
                  offset: Offset(0.0, 5),
                ),
              ],
            ),
            margin: EdgeInsets.only(top: 6.h, bottom: 6.h, left: 6.w, right: 6.w),
            child: const Text('first'),
          ),
          Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              color: Color(0xffFFFFFF),
              boxShadow: <BoxShadow> [
                BoxShadow(
                  color: Color(0xffD3D3D3),
                  blurRadius: 10.0,
                  offset: Offset(0.0, 5),
                ),
              ],
            ),
            margin: EdgeInsets.only(top: 6.h, bottom: 6.h, left: 6.w, right: 6.w),
            child: const Text('first'),
          ),
          Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              color: Color(0xffFFFFFF),
              boxShadow: <BoxShadow> [
                BoxShadow(
                  color: Color(0xffD3D3D3),
                  blurRadius: 10.0,
                  offset: Offset(0.0, 5),
                ),
              ],
            ),
            margin: EdgeInsets.only(top: 6.h, bottom: 6.h, left: 6.w, right: 6.w),
            child: const Text('first'),
          ),
          Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              color: Color(0xffFFFFFF),
              boxShadow: <BoxShadow> [
                BoxShadow(
                  color: Color(0xffD3D3D3),
                  blurRadius: 10.0,
                  offset: Offset(0.0, 5),
                ),
              ],
            ),
            margin: EdgeInsets.only(top: 6.h, bottom: 6.h, left: 6.h, right: 6.w),
            child: const Text('first'),
          ),
          Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              color: Color(0xffFFFFFF),
              boxShadow: <BoxShadow> [
                BoxShadow(
                  color: Color(0xffD3D3D3),
                  blurRadius: 10.0,
                  offset: Offset(0.0, 5),
                ),
              ],
            ),
            width: 165,
            height: 165,
            margin: EdgeInsets.only(top: 6.h, bottom: 6.h, left: 6.w, right: 6.h),
            child: const Text('first'),
          ),
          Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              color: Color(0xffFFFFFF),
              boxShadow: <BoxShadow> [
                BoxShadow(
                  color: Color(0xffD3D3D3),
                  blurRadius: 10.0,
                  offset: Offset(0.0, 5),
                ),
              ],
            ),
            width: 165,
            height: 165,
            margin: EdgeInsets.only(top: 6.h, bottom: 6.h, left: 6.h, right: 6.w),
            child: const Text('first'),
          ),
        ],
      ),
    ),
  );
}