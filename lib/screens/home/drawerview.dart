import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:green_light/screens/home/loginview.dart';
import 'package:green_light/screens/home/managegroupsview.dart';
import 'package:green_light/screens/home/mypageview.dart';

class DrawerView extends StatelessWidget {
  const DrawerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 308.w,
      child: Drawer(
        child: Column(
          children: <Widget>[
            _buildMyPage(),
            _buildMiddle(),
            _buildSettings(),
          ],
        )
      ),
    );
  }
}
Widget _buildMyPage() {
  return Container(
    margin: EdgeInsets.only(top: 60.h),
    child: Column(
      children: <Widget>[
        _myPage(),
        _modifyMyPage(),
      ],
    ),
  );
}
Widget _myPage() {
  return Container(
    alignment: Alignment.centerLeft,
    margin: EdgeInsets.only(left: 24.w),
    child: const Text(
      'My Page',
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: Color(0xff141C27),
      ),
    ),
  );
}


Widget _modifyMyPage() {
  return Builder(
    builder: (context) {
      return InkWell(
        child: Container(
          margin: EdgeInsets.only(top: 36.h),
          padding: EdgeInsets.only(left: 24.w),
          child: Row(
            children: <Widget>[
              Container(
                width: 40.w,
                height: 40.h,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xffE9EAEC),
                ),
                child: const Icon(
                  Icons.person,
                  size: 25,
                  color: Color(0xffC3C8CE),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.only(bottom: 1.h),
                      child: const Text(
                        'User Name',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 1.h),
                      child: const Text(
                        'To modify my information',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 18.w),
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: Color(0xffC3C8CE),
                  size: 25,
                ),
              ),
            ],
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MyPageView()),
          );
        },
      );
    }
  );
}

Widget _buildMiddle() {
  return Container(
    margin: EdgeInsets.only(top: 23.h),
    color: const Color(0xffF2F3F5),
      height: 16.h,
  );
}

Widget _buildSettings() {
  return Container(
    margin: EdgeInsets.only(top: 36.h),
    child: Column(
      children: <Widget>[
        _settings(),
        _manageGroups(),
        _logout(),
        _appNotifications(),
      ],
    ),
  );
}

Widget _settings() {
  return Container(
    alignment: Alignment.centerLeft,
    margin: EdgeInsets.only(left: 24.w),
    child: const Text(
      'Settings',
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: Color(0xff141C27),
      ),
    ),
  );
}

Widget _manageGroups() {
  return Builder(
      builder: (context) {
        return InkWell(
          child: Container(
            margin: EdgeInsets.only(top: 36.h),
            padding: EdgeInsets.only(left: 24.w),
            child: Row(
              children: <Widget>[
                Container(
                  width: 40.w,
                  height: 40.h,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xffE9EAEC),
                  ),
                  child: const Icon(
                    Icons.manage_accounts,
                    size: 25,
                    color: Color(0xffC3C8CE),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 12.w),
                  child: const Text(
                    'Manage Groups',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 67.w),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: Color(0xffC3C8CE),
                    size: 25,
                  ),
                ),
              ],
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ManageGroupsView()),
            );
          },
        );
      }
  );
}

Widget _logout() {
  return Builder(
      builder: (context) {
        return InkWell(
          child: Container(
            margin: EdgeInsets.only(top: 36.h),
            padding: EdgeInsets.only(left: 24.w),
            child: Row(
              children: <Widget>[
                Container(
                  width: 40.w,
                  height: 40.h,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xffE9EAEC),
                  ),
                  child: const Icon(
                    Icons.logout,
                    size: 25,
                    color: Color(0xffC3C8CE),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 12.w),
                  child: const Text(
                    'Logout',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 136.w),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: Color(0xffC3C8CE),
                    size: 25,
                  ),
                ),
              ],
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LoginView()),
            );
          },
        );
      }
  );
}

Widget _appNotifications() {
  var switchValue = false;
  return Builder(
    builder: (context) {
      return Container(
        margin: EdgeInsets.only(top: 36.h),
        padding: EdgeInsets.only(left: 24.w),
        child: Row(
          children: <Widget>[
            Container(
              width: 40.w,
              height: 40.h,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xffE9EAEC),
              ),
              child: const Icon(
                Icons.notifications,
                size: 25,
                color: Color(0xffC3C8CE),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 12.w),
              child: const Text(
                'App Notifications',
                style: TextStyle(
                fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 22.w),
              child: CupertinoSwitch(
                value: switchValue,
                onChanged: (value) {
                  switchValue = value;
                },
              )
            ),
          ],
        ),
      );
    },
  );
}