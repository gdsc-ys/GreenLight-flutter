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


// This file is for feed part of our app
// It contains education area and community area
// First one is for news listing about ecology
// Second one is for showing users' activities
class FeedPage extends StatefulWidget {
  const FeedPage({Key? key}) : super(key: key);
  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> with SingleTickerProviderStateMixin{
  late TabController _tabController;

  var db = FirebaseFirestore.instance;

  // Lists for news crolling data
  List<String?> title = [];
  List<String?> link = [];
  List<String?> imgSrc = [];

  // current user data
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

  // This function is optimized for NAVER news and its ecology tab..
  // So if you want to get other sites' data
  // You must modify this function.
  Future<void> _getNews() async {
    var url = 'https://news.naver.com/main/list.naver?mode=LS2D&mid=shm&sid1=102&sid2=252';

    List<String?> titleIn = [];
    List<String?> linkIn = [];
    List<String?> imgsrcIn = [];

    var response = await http.get(Uri.parse(url));

    var document = parse(response.body);

    var ul = document.getElementsByClassName("type06_headline");

    var lists = ul[0].getElementsByClassName("photo");

    var dls = ul[0].getElementsByTagName("dl");

    for (var dl in dls) {
      var dt = dl.getElementsByTagName("dt");

      if (dt.length == 1){
        var a = dt[0].querySelector("a");

        titleIn.add(cp949.decodeString(a?.innerHtml as String));

        imgsrcIn.add('0');
      } else {
        var img = dt[0].querySelector("img");

        imgsrcIn.add(img?.attributes['src']);

        var a = dt[1].querySelector("a");

        titleIn.add(cp949.decodeString(a?.innerHtml as String).trim());
      }

    }

    for (var list in lists) {
      var a = list.querySelector("a");

      linkIn.add(a?.attributes['href']);

    }

    setState(() {
      title = titleIn;
      imgSrc = imgsrcIn;
      link = linkIn;
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

// call the link to get the news web page by users' browser.
Future<void> callLink(String link) async {
  launch(link, forceWebView: false, forceSafariVC: false);
}

Widget _buildFeedTab(TabController tabController, List<String?> title, List<String?> imgSrc, List<String?> link) {
  return Expanded(
    child: SizedBox(
      height: 500.h,
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
                                // if the news web page doesn't return any image
                                // then use our static default image.
                                child: imgSrc[index]! == "0" ? Image.asset(
                                  "assets/images/empty.png",
                                  width: 64.w,
                                  height: 64.h, 
                                  fit: BoxFit.fill,
                                  ) : Image.network(
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

                    // get other users' and my recent activities.
                    // at most 10 activities
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
                                      // images vary from types
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
