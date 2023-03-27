import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:green_light/models/user.dart';
import 'package:green_light/screens/home/drawerview.dart';
import 'package:green_light/screens/shared/loading.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:html/parser.dart' show parse;
import 'package:cp949_codec/cp949_codec.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';


class FeedPage extends StatefulWidget {
  const FeedPage({Key? key}) : super(key: key);
  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> with SingleTickerProviderStateMixin{
  // 번갈아 작동하는 탭
  late TabController _tabController;

  // DB 연결
  var db = FirebaseFirestore.instance;

  // 네이버 뉴스 불러오기 위한 데이터들
  List<String?> title = [];
  List<String?> link = [];
  List<String?> imgSrc = [];

  // 현재 streaming되는 user data
  String? userName = "";
  Timestamp? dateTime;
  int? height;
  int? weight;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        length: 2,
        vsync: this,
    );
    _getUserInfo();
    _getNews();

  }

  // 말 그대로 유저 정보 받아옴
  Future<void> _getUserInfo() async {
    GL_User? user = Provider.of<GL_User?>(context, listen: false);
    db.collection("users").where('uid', isEqualTo: user!.uid).get().then((userData) {
      setState(() {
        userName = userData.docs[0].data()['nickname'];
        dateTime = userData.docs[0].data()['date_of_birth'];
        height = userData.docs[0].data()['height'];
        weight = userData.docs[0].data()['weight'];
      });
    });
  }

  // 말 그대로 뉴스 받아옴
  Future<void> _getNews() async {
    var url = 'https://news.naver.com/main/list.naver?mode=LS2D&mid=shm&sid1=102&sid2=252';

    List<String?> title_in = [];
    List<String?> link_in = [];
    List<String?> imgSrc_in = [];

    var response = await http.get(Uri.parse(url));

    var document = parse(response.body);

    var ul = document.getElementsByClassName("type06_headline");

    var lists = ul[0].getElementsByClassName("photo");

    var dls = ul[0].getElementsByTagName("dl");

    for (var dl in dls) {
      var dt = dl.getElementsByTagName("dt");

      if (dt.length == 1){
        var a = dt[0].querySelector("a");

        title_in.add(cp949.decodeString(a?.innerHtml as String));

        imgSrc_in.add('https://i0.wp.com/iammom.co.kr/wp-content/uploads/환경.jpg?w=800&ssl=1');
      } else {
        var img = dt[0].querySelector("img");

        imgSrc_in.add(img?.attributes['src']);

        var a = dt[1].querySelector("a");

        title_in.add(cp949.decodeString(a?.innerHtml as String).trim());
      }

    }

    for (var list in lists) {
      var a = list.querySelector("a");

      link_in.add(a?.attributes['href']);

    }

    setState(() {
      title = title_in;
      imgSrc = imgSrc_in;
      link = link_in;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        endDrawer: DrawerView(userName: userName),
        body: Container(
          decoration: const BoxDecoration(
            color: Color(0xffFFFFFF),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _buildFeedTop1(),
              _buildFeedTop2(),
              _buildFeedTab(_tabController, title, imgSrc, link),
            ],
          ),
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
    }
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

// 링크 타고 뉴스로 감 브라우저 요청
Future<void> callLink(String link) async {
  launch(link, forceWebView: false, forceSafariVC: false);
}

Widget _buildFeedTab(TabController tabController, List<String?> title, List<String?> imgSrc, List<String?> link) {
  return Expanded(
    child: SizedBox(
      height: 500,
      child: Padding(
        padding: EdgeInsets.only(left: 24.w, right: 24.w, top: 12.h),
        child: Column(
          children: [
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

            Expanded(
              child: TabBarView(
                controller: tabController,
                children: [
                  ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: imgSrc.length,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        child: Container(
                          padding: EdgeInsets.only(top: 8.h, bottom: 8.h),
                          child: Row(
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                                child: Image.network(
                                  imgSrc[index]!,
                                  width: 64.w,
                                  height: 64.h,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              Flexible(
                                child: Container(
                                  margin: EdgeInsets.only(left: 12.w),
                                  child: Text(
                                    title[index]!,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        onTap: () => callLink(link[index]!),
                      );
                    },
                  ),
                  StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    // stream: null,
                    stream: FirebaseFirestore.instance.collection("community_events")
                    .orderBy("date", descending: true).snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Loading();
                      }
                      final documents = snapshot.data!.docs;
                      return ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: documents.length > 10 ? 10 : documents.length,
                        itemBuilder: (BuildContext context, int index) {
                          final data = documents[index].data();
                          return InkWell(
                            child: Container(
                              margin: EdgeInsets.only(top: 8.h, bottom: 8.h),
                              child: Row(
                                children: <Widget>[
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(32),
                                    child: Image.asset(
                                      data['type'] == 0 ? 'assets/images/greenlight.png' : 'assets/images/redlight.png',
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
                                          child: Text(
                                            data['nickname'],
                                            style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(top: 2.h),
                                          child: Text(
                                            data['type'] == 0 ? 'Achieved Greenlight ♥' : "Redlight Notification :)",
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {},
                          );
                        },
                      );
                    }
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
