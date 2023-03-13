import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:green_light/screens/home/drawerview.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({Key? key}) : super(key: key);
  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> with SingleTickerProviderStateMixin{
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        length: 2,
        vsync: this,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const DrawerView(),
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xffFFFFFF),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildFeedTop1(),
            _buildFeedTop2(),
            _buildFeedTab(_tabController),
          ],
        ),
      ),
    );

  }
}

Widget _buildFeedTop1() {
  return Builder(
    builder: (context) {
      return Container(
        margin: EdgeInsets.only(top: 18.h, left: 330.w, right: 24.w),
        child: IconButton(
          iconSize: 30,
          alignment: Alignment.centerRight,
          constraints: const BoxConstraints(),
          onPressed: () {
            Scaffold.of(context).openEndDrawer();
          },
          icon: const Icon(Icons.menu),
          color: const Color(0xff8C939B),
        ),
      );
    },
  );
}

Widget _buildFeedTop2() {
  return Container(
    alignment: Alignment.centerLeft,
    margin: EdgeInsets.only(left: 24.w),
    child: const Text(
      'Feed',
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: Color(0xff141C27),
        // fontFamily: 'Pretendard',
      ),
    ),
  );
}

Widget _buildFeedTab(TabController tabController) {
  return Expanded(
    child: SizedBox(
      height: 500,
      child: Padding(
        padding: EdgeInsets.only(left: 24.w, right: 24.w, top: 19.h),
        child: Column(
          children: [
            // give the tab bar a height [can change height to preferred height]
            Container(
              height: 50.h,
              margin: EdgeInsets.only(bottom: 12.h),
              decoration: const BoxDecoration(
                color: Color(0xffF2F3F5),
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
                boxShadow: <BoxShadow> [
                  BoxShadow(
                    color: Color(0xffeeeeee),
                    blurRadius: 5.0,
                    offset: Offset(0.0, 5),
                  ),
                ],
              ),
              child: TabBar(
                controller: tabController,
                indicatorPadding: const EdgeInsets.all(6.0),
                indicator: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  boxShadow: <BoxShadow> [
                    BoxShadow(
                      color: Color(0xffeaeaea),
                      blurRadius: 1.0,
                      offset: Offset(0.0, 3),
                    ),
                  ],
                  color: Color(0xffFFFFFF),
                ),
                labelStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
                labelColor: const Color(0xff444C58),
                unselectedLabelColor: const Color(0xff444C58),
                tabs: const <Tab>[
                  // first tab [you can add an icon using the icon property]
                  Tab(
                    text: 'Education',
                  ),

                  // second tab [you can add an icon using the icon property]
                  Tab(
                    text: 'Community',
                  ),
                ],
              ),
            ),
            // tab bar view here
            Expanded(
              child: TabBarView(
                controller: tabController,
                children: <Widget>[
                  // first tab bar view widget
                  ListView(
                    scrollDirection: Axis.vertical,
                    children: <Widget>[
                      InkWell(
                        child: Container(
                          padding: EdgeInsets.only(top: 8.h, bottom: 8.h),
                          child: Row(
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                                child: Image.network(
                                  'https://i0.wp.com/iammom.co.kr/wp-content/uploads/환경.jpg?w=800&ssl=1',
                                  width: 64.w,
                                  height: 64.h,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 12.w),
                                child: const Text(
                                  '탄소중립의 첫걸음, 해피 해빗',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        onTap: () {},
                      ),
                      InkWell(
                        child: Container(
                          margin: EdgeInsets.only(top: 8.h, bottom: 8.h),
                          child: Row(
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                                child: Image.network(
                                  'https://i0.wp.com/iammom.co.kr/wp-content/uploads/환경.jpg?w=800&ssl=1',
                                  width: 64.w,
                                  height: 64.h,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 12.w),
                                child: const Text(
                                  '일상의 플라스틱 프리 실천법',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        onTap: () {},
                      ),
                      InkWell(
                        child: Container(
                          margin: EdgeInsets.only(top: 8.h, bottom: 8.h),
                          child: Row(
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                                child: Image.network(
                                  'https://i0.wp.com/iammom.co.kr/wp-content/uploads/환경.jpg?w=800&ssl=1',
                                  width: 64.w,
                                  height: 64.h,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 12.w),
                                child: const Text(
                                  '스웨덴 환경 이야기 웹툰',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        onTap: () {},
                      ),
                      InkWell(
                        child: Container(
                          margin: EdgeInsets.only(top: 8.h, bottom: 8.h),
                          child: Row(
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                                child: Image.network(
                                  'https://i0.wp.com/iammom.co.kr/wp-content/uploads/환경.jpg?w=800&ssl=1',
                                  width: 64.w,
                                  height: 64.h,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 12.w),
                                child: const Text(
                                  '바다, 지구, 우리',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        onTap: () {},
                      ),
                      InkWell(
                        child: Container(
                          margin: EdgeInsets.only(top: 8.h, bottom: 8.h),
                          child: Row(
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                                child: Image.network(
                                  'https://i0.wp.com/iammom.co.kr/wp-content/uploads/환경.jpg?w=800&ssl=1',
                                  width: 64.w,
                                  height: 64.h,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 12.w),
                                child: const Text(
                                  '플라스틱 포장재',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        onTap: () {},
                      ),
                      InkWell(
                        child: Container(
                          margin: EdgeInsets.only(top: 8.h, bottom: 8.h),
                          child: Row(
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                                child: Image.network(
                                  'https://i0.wp.com/iammom.co.kr/wp-content/uploads/환경.jpg?w=800&ssl=1',
                                  width: 64.w,
                                  height: 64.h,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 12.w),
                                child: const Text(
                                  '플로깅 캠페인 참여 정보',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        onTap: () {},
                      ),
                      InkWell(
                        child: Container(
                          margin: EdgeInsets.only(top: 8.h, bottom: 8.h),
                          child: Row(
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                                child: Image.network(
                                  'https://i0.wp.com/iammom.co.kr/wp-content/uploads/환경.jpg?w=800&ssl=1',
                                  width: 64.w,
                                  height: 64.h,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 12.w),
                                child: const Text(
                                  '너무 많지도, 적지도 않은 환경 정보',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        onTap: () {},
                      ),
                      InkWell(
                        child: Container(
                          margin: EdgeInsets.only(top: 8.h, bottom: 8.h),
                          child: Row(
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                                child: Image.network(
                                  'https://i0.wp.com/iammom.co.kr/wp-content/uploads/환경.jpg?w=800&ssl=1',
                                  width: 64.w,
                                  height: 64.h,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 12.w),
                                child: const Text(
                                  '쓰레기섬, 그 원인과 해결방법',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        onTap: () {},
                      ),
                      InkWell(
                        child: Container(
                          margin: EdgeInsets.only(top: 8.h, bottom: 8.h),
                          child: Row(
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                                child: Image.network(
                                  'https://i0.wp.com/iammom.co.kr/wp-content/uploads/환경.jpg?w=800&ssl=1',
                                  width: 64.w,
                                  height: 64.h,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 12.w),
                                child: const Text(
                                  '아마존, 지구의 허파',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        onTap: () {},
                      ),
                    ],
                  ),
                  // second tab bar view widget
                  ListView(
                    scrollDirection: Axis.vertical,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 8.h, bottom: 8.h),
                        child: Row(
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(32),
                              child: Image.asset('assets/images/container.png',
                                width: 64.w,
                                height: 64.h,
                                fit: BoxFit.fill,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 20.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(bottom: 2.h),
                                    child: const Text(
                                      'Soonmin',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                    ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(top: 2.h),
                                    child: const Text(
                                      'Using reusable containers',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 8.h, bottom: 8.h),
                        child: Row(
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(32),
                              child: Image.asset(
                                'assets/images/tumblr.png',
                                width: 64.w,
                                height: 64.h,
                                fit: BoxFit.fill,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 20.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(bottom: 2.h),
                                    child: const Text(
                                      'Soonmin',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(top: 2.h),
                                    child: const Text(
                                      'Using a tumblr!',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 8.h, bottom: 8.h),
                        child: Row(
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(32),
                              child: Image.asset(
                                'assets/images/greenlight.png',
                                width: 64.w,
                                height: 64.h,
                                fit: BoxFit.fill,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 20.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(bottom: 2.h),
                                    child: const Text(
                                      'Soonmin',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(top: 2.h),
                                    child: const Text(
                                      'Achieved Greenlight',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 8.h, bottom: 8.h),
                        child: Row(
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(32),
                              child: Image.asset(
                                'assets/images/redlight.png',
                                width: 64.w,
                                height: 64.h,
                                fit: BoxFit.fill,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 20.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(bottom: 2.h),
                                    child: const Text(
                                      'Soonmin',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(top: 2.h),
                                    child: const Text(
                                      'Redlight Notification!',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
