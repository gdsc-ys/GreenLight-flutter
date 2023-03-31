import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:green_light/screens/home/drawerview.dart';
import 'package:green_light/models/user.dart';
import 'package:green_light/screens/shared/loading.dart';
import 'package:provider/provider.dart';
import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:green_light/services/distance.dart';


// In emulator, Samsung step measurer doesn't work.
// So we ommitted that function in this file.
// Step data is a dummy of user's.
class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {

  GL_User? user;
  List<double> near = [10000.0, 10000.0];
  List<int> index = [-1, -1];
  List<String> textValue = ['', ''];
  List<String> dist = ['', ''];
  List<String> time = ['', ''];
  List<String> imgURL = ['', ''];
  List<String> address = ['', ''];

  String? userName = "";
  Timestamp? dateTime;
  int? height;
  int? weight;

  var db = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();

    user = Provider.of<GL_User?>(context, listen: false);
    _getUserInfo();
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

  String distCalcul(double dist) {
    int kilo = -1;
    int meter = -1;

    if (dist >= 1) {
      kilo = dist.round();
      if (kilo > dist) {
        meter = ((kilo.toDouble() - dist) * 1000).round();
      } else {
        meter = ((dist - kilo.toDouble()) * 1000).round();
      }
      return "${kilo.toString()}km ${meter.toString()}m";
    } else {
      kilo = 0;
      meter = (dist * 1000).round();
      return "${meter.toString()}m";
    }
  }

  String timeCalcul(double dist, num stride) {
    double time = dist * 60 / (-3685.1683 * stride + 7977.707);
    if (time >= 60) {
      int hour = time.floor() ~/ 60;
      int minute = (time / 60).floor();
      return "${hour}h ${minute}min";
    } else {
      return "${time.round()} min";
    }
  }

  @override
  Widget build(BuildContext context) {

    // our health data calculation reference
    // under korean writings are just instructions for our team members

    // https://thankspizza.tistory.com/77
    // 걷기 속도는 일정하다고 가정하면
    // 몇 분 걸었는지 알아야함 -> 걷기로 가정하면 운동계수 0.9
    // 0.9 * 체중 = 15분간 소모한 칼로리
    // 0.9 * 체중 / 15 = 1분간 소모한 칼로리
    // 보폭 = 키 * 0.45
    // 이동 거리 = 보폭 * 걸음수
    // 1시간 당 걸은 거리 = -3685.1683 * 보폭(m) + 7977.707 (m)
    // 60 : 60분 동안 걸은 거리 (m) = 걸은 시간 : 보폭 * 걸음수 (m)
    // 걸은 시간 = 보폭 * 걸음수 * 60 / (-3685.1683 * 보폭 + 7977.707)
    // 칼로리 = 1분간 소모한 칼로리 * 걸은 시간
    // 그린라이트까지 거리 * 60 / 60분 동안 걸은 거리 = 그린라이트까지 걸리는 시간

    // 보여줄 나의 정보
    // 1. step - firestore에서 step 가져오기
    // 2. calorie - 보폭 * 걸음수 * 60 / (-3685.1683 * 보폭 + 7977.707) * (0.9 * 체중 / 15)
    // 3. tree - step / 123 (소숫점까지 표시)
    // 4. CO2 - step * 0.0147kg

    // First of all, streaming user location data
    return user == null || height == null? const Loading() : StreamBuilder<LocationData>(
      stream: Location().onLocationChanged,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Loading();
        }
        final myLoc = snapshot.data!;

        // And run a pedometer streaming
        // Followings are respective calculating data
        final steps = 1234;
        final stride = height! * 0.45 / 100;
        double myCalories = (stride * steps * 60) / ((-3685.1683 * stride + 7977.707) * (0.9 * weight! / 15));
        final calories = (myCalories * 100).round() / 100;
        final trees = ((steps / 123) * 100).round() / 100;
        final CO2 = (steps * 0.0147 * 100).round() / 100;

        return SafeArea(
          child: Scaffold(
            endDrawer: DrawerView(userName: userName),
            body: Container(
              decoration: const BoxDecoration(
                color: Color(0xffFFFFFF),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    _buildFeedTop1(),
                    today(steps, calories, trees, CO2),
                    redLight(myLoc, stride),
                  ],
                ),
              ),
            ),
          ),
        );
      }
    );
  }

  Widget _buildFeedTop1() {
    return Builder(
        builder: (context) {
          return Container(
            margin: EdgeInsets.only(top: 19.5.h, right: 17.w),
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

  // today widget
  // L todayText widget
  // L stepAndCalorie widget
  // L treeAndCo2 widget
  Widget today(int steps, double calories, double trees, double CO2) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget> [
        todayText(),
        stepAndCalorie(steps, calories),
        treeAndCo2(trees, CO2),
      ],
    );
  }

  Widget todayText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 36.w, top: 15.h),
          child: const Text(
            "Today",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget stepAndCalorie(int steps, double calories) {
    return Container(
      width: 342.w,
      height: 82.h,
      margin: EdgeInsets.only(top: 16.h),
      decoration: BoxDecoration(
          color: const Color(0xffFFFFFF),
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.04),
              blurRadius: 4.0,
              spreadRadius: 0,
              offset: Offset(0, 0),
            ),
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.06),
              blurRadius: 8.0,
              spreadRadius: 0,
              offset: Offset(0, 4),
            )
          ]
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 14.h),
                child: const Text(
                  "Step",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xff8C939B)),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 3.h),
                child: Text(
                  steps.toString(),
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(left: 55.w, right: 55.w),
            child: Image.asset(
              'assets/images/step_calorie_bar.png',
              ),
          ),
          Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 14.h),
                child: const Text(
                  "Calorie",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xff8C939B)),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 3.h),
                child: Text(
                  "$calories kcal",
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget treeAndCo2(double trees, double CO2) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        //tree
        Container(
          width: 165.w,
          height: 165.h,
          margin: EdgeInsets.only(left: 8.w, top: 16.h),
          decoration: BoxDecoration(
              color: const Color(0xffFFFFFF),
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(15.0),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.04),
                  blurRadius: 4.0,
                  spreadRadius: 0,
                  offset: Offset(0, 0),
                ),
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.06),
                  blurRadius: 8.0,
                  spreadRadius: 0,
                  offset: Offset(0, 4),
                )
              ]
          ),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 12.h),
                child: const Text(
                  "Tree",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 8.h, bottom: 8.h),
                child: Image.asset(
                  'assets/images/tree_image.png', 
                ),
              ),
              Text(
                "$trees ▲",
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),

        // carbon dioxide
        Container(
          width: 165.w,
          height: 165.h,
          margin: EdgeInsets.only(left: 8.w, top: 16.h),
          decoration: BoxDecoration(
              color: const Color(0xff80CA4C),
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(15.0),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.18),
                  blurRadius: 4.0,
                  spreadRadius: 0,
                  offset: Offset(0, 0),
                ),
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.18),
                  blurRadius: 16.0,
                  spreadRadius: 0,
                  offset: Offset(0, 8),
                )
              ]
          ),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 12.h),
                child: const Text(
                  "Carbon Dioxide",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xffFFFFFF)),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 18.h, bottom: 15.h),
                child: Image.asset(
                  'assets/images/co2_image.png',
                  ),
              ),
              Text(
                "$CO2 ▽",
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xffFFFFFF)),
              ),
            ],
          ),
        ),
      ],
    );
  }


  // redLight widget
  // L redLightText widget
  // L firstLight widget
  // L secondLight widget
  Widget redLight(LocationData myLoc, double stride) {

    // Streaming green light instances.
    // Which of the greenlights exist near by the user.
    // We select 2 of the nearest instance.
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: db.collection('greenlights').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Loading();
        }
        final documents = snapshot.data!.docs;

        // These are selecting the nearest one processes.
        for (int i = 0; i < documents.length; i++){
          var newGreenlight = documents[i];
          var compareDist = calculateDistance(myLoc.latitude, myLoc.longitude, newGreenlight['lat'], newGreenlight['lng']);
          if (documents[i]['visit'] < 2 && compareDist <= near[0]) {
            near[0] = compareDist;
            index[0] = i;
            textValue[0] = documents[i]['message'];
            dist[0] = distCalcul(near[0]);
            imgURL[0] = documents[i]['imageURL'];
            address[0] = documents[i]['address'];
          } else if (index[0] != i && documents[i]['visit'] < 2 && compareDist >= near[0] && compareDist <= near[1]) {
            near[1] = compareDist;
            index[1] = i;
            textValue[1] = documents[i]['message'];
            imgURL[1] = documents[i]['imageURL'];
            dist[1] = distCalcul(near[1]);
            address[1] = documents[i]['address'];
          }
        }
        if (near[1] == double.infinity) {
          near.removeAt(1);
        }
        if (near[0] == double.infinity) {
          near.removeAt(0);
        }
        time[0] = timeCalcul(near[0]*1000.toDouble(), stride);
        time[1] = timeCalcul(near[1]*1000.toDouble(), stride);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget> [
            redLightText(),
            firstLight(),
            secondLight(),
          ],
        );
      }
    );
  }

  Widget redLightText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 36.w, top: 48.h),
          child: const Text(
            "Red Light",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget firstLight() {
    return imgURL[0] == ''? const Loading(): Container(
      width: 342.w,
      height: 120.h,
      margin: EdgeInsets.only(top: 16.h),
      decoration: BoxDecoration(
          color: const Color(0xffE6726C),
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.04),
              blurRadius: 4.0,
              spreadRadius: 0,
              offset: Offset(0, 0),
            ),
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.06),
              blurRadius: 8.0,
              spreadRadius: 0,
              offset: Offset(0, 4),
            )
          ]
      ),
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(left: 12.w),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(15.0)),
              child: CachedNetworkImage(
                imageUrl: imgURL[0],
                placeholder: (context, url) => const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                width: 96.w,
                height: 96.h,
                fit: BoxFit.fill,
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                margin: EdgeInsets.only(left: 12.w),
                child: redLightInfo(0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget secondLight() {
    return imgURL[1] == '' ? const Loading(): Container(
      width: 342.w,
      height: 120.h,
      margin: EdgeInsets.only(top: 15.h),
      decoration: BoxDecoration(
          color: const Color(0xffFFFFFF),
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.04),
              blurRadius: 4.0,
              spreadRadius: 0,
              offset: Offset(0, 0),
            ),
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.06),
              blurRadius: 8.0,
              spreadRadius: 0,
              offset: Offset(0, 4),
            )
          ]
      ),
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(left: 12.w),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(15.0)),
              child: CachedNetworkImage(
                imageUrl: imgURL[1],
                placeholder: (context, url) => const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                width: 96.w,
                height: 96.h,
                fit: BoxFit.fill,
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                margin: EdgeInsets.only(left: 12.w),
                child: redLightInfo(1),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget redLightInfo(int idx) {
    Color colorCode1, colorCode2;
    if (idx == 0) {
      colorCode1 = const Color(0xffFFFFFF);
      colorCode2 = const Color(0xffFFFFFF);
    } else {
      colorCode1 = const Color(0xff000000);
      colorCode2 = const Color(0xff8E9399);
    }

    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 16.h),
            child: Text(textValue[idx],
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: colorCode1),
            ),
          ),
          Text(
            address[idx],
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: colorCode2),
          ),
          Container(
            width: 200.w,
            height: 30.h,
            margin: EdgeInsets.only(top: 18.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(dist[idx],
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: colorCode2),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                        margin: EdgeInsets.only(left: 50.w, bottom: 0.h),
                        child: Text(time[idx],
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: colorCode2
                            )
                        )
                    ),
                  ),
                )
              ],
            ),
          )
        ]
    );
  }
}