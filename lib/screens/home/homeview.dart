import 'package:flutter/material.dart';
import 'package:green_light/screens/home/drawerview.dart';
import 'package:green_light/models/user.dart';
import 'package:provider/provider.dart';
import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:green_light/services/distance.dart';
import 'package:green_light/services/greenlight.dart';

class HomeView extends StatefulWidget {
  const HomeView({required this.location, required this.uid, super.key});

  final Future<LocationData> location;
  final String? uid;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {

  late LocationData myLoca;
  QuerySnapshot<Map<String, dynamic>>? greenlight;
  List<double> near = [10000.0, 10000.0];
  List<int> index = [-1, -1];
  List<String> textValue = ['', ''];
  List<String> dist = ['', ''];
  List<String> time = ['', ''];
  List<String> imgURL = ['', ''];
  Map<String, num> myInfo = Map();

  String? userName = "";
  Timestamp? dateTime;
  int? height;
  int? weight;

  Future<void> _getMyLoca() async {
    Location location = Location();
    location.getLocation().then((location) {
      setState(() {
        myLoca = location;
      });
    });
    print('plz');
  }

  var db = FirebaseFirestore.instance;
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

  Future<void> info() async {
    db.collection('users').where('uid', isEqualTo: widget.uid).get().then((users) {
      setState(() {
        // for (int i = 0; i < users.size; i++) {
        //   print('im herre@@@@@@@@@@@@@@@@@@@@@@@@@@');
        //   if (users.docs[i]['uid'] == widget.uid) {
        //     print(users.docs[i]['uid']);
        //     myInfo['steps'] = users.docs[i]['steps'];
        //     myInfo['height']= users.docs[i]['height'];
        //     myInfo['weight'] = users.docs[i]['weight'];
        //     myInfo['stride'] = myInfo['height']! * 0.45 / 100;
        //     double myCalories = (myInfo['stride']! * myInfo['steps']! * 60) / ((-3685.1683 * myInfo['stride']! + 7977.707) * (0.9 * myInfo['weight']! / 15));
        //     myInfo['calories'] = (myCalories * 100).round() / 100;
        //     myInfo['trees'] = ((myInfo['steps']! / 123) * 100).round() / 100;
        //     myInfo['CO2'] = (myInfo['steps']! * 0.0147 * 100).round() / 100;
        //     break;
        //   }
        // }
        myInfo['steps'] = users.docs[0]['steps'];
        myInfo['height']= users.docs[0]['height'];
        myInfo['weight'] = users.docs[0]['weight'];
        myInfo['stride'] = myInfo['height']! * 0.45 / 100;
        double myCalories = (myInfo['stride']! * myInfo['steps']! * 60) / ((-3685.1683 * myInfo['stride']! + 7977.707) * (0.9 * myInfo['weight']! / 15));
        myInfo['calories'] = (myCalories * 100).round() / 100;
        myInfo['trees'] = ((myInfo['steps']! / 123) * 100).round() / 100;
        myInfo['CO2'] = (myInfo['steps']! * 0.0147 * 100).round() / 100;
        print(myInfo['steps']);
      });
    });
  }

  Future<void> _getGreenLight() async {
    db.collection('greenlights').get().then((greenlight) {
      setState(() {
        print('제발요');
        print(myLoca);
        for (int i = 0; i < greenlight.docs.length; i++){
          print(i);
          var newGreenlight = greenlight.docs[i];
          var compareDist = calculateDistance(myLoca!.latitude, myLoca!.longitude, newGreenlight['lat'], newGreenlight['lng']);
          if (compareDist < near[0]) {
            near[0] = compareDist;
            index[0] = i;
            textValue[0] = greenlight!.docs[i]['message'];
            dist[0] = distCalcul(near[0]);
            imgURL[0] = greenlight!.docs[i]['imageURL'];
          } else if (compareDist >= near[0] && compareDist < near[1]) {
            near[1] = compareDist;
            index[1] = i;
            textValue[1] = greenlight!.docs[i]['message'];
            imgURL[1] = greenlight!.docs[i]['imageURL'];
            dist[1] = distCalcul(near[1]);
          }
        }
        print('사람살려2');
        print(textValue[0]);
        if (near[1] == double.infinity) {
          near.removeAt(1);
        }
        if (near[0] == double.infinity) {
          near.removeAt(0);
        }
        print('사람살려');
        print(near[0]);
        time[0] = timeCalcul(near[0]*1000.toDouble());
        time[1] = timeCalcul(near[1]*1000.toDouble());
        print(time[0]);
      });
    });
}

  // steps 가져오기
  // Future<Map<String, num>> get info async {
  //   var info = Map<String, num> ();
  //   var db = FirebaseFirestore.instance;
  //   QuerySnapshot<Map<String, dynamic>> users = await db.collection('users').get();
  //   for (int i = 0; i < users.size; i++) {
  //     if (users.docs[i]['uid'] == widget.uid) {
  //       info['steps'] = users.docs[i]['steps'];
  //       info['height']= users.docs[i]['height'];
  //       info['weight'] = users.docs[i]['weight'];
  //       info['null'] = 0;
  //       return info;
  //     }
  //   }
  //   info['null'] = 1;
  //   return info;
  // }

  @override
  void initState() {
    super.initState();

    // widget.location.then((value) {
    //   setState(() {
    //     myLoca = value!;
    //   });
    // });
    // }).then((value) async {
    //   greenlight = await db.collection('greenlights').get();
    // }).then((value) {
    //   for (int i = 0; i < greenlight!.size; i++){
    //     print(greenlight!.docs[i]['message']);
    //     var newGreenlight = greenlight!.docs[i];
    //     var compareDist = calculateDistance(myLoca!.latitude, myLoca!.longitude, newGreenlight['lat'], newGreenlight['lng']);
    //     if (compareDist < near[0]) {
    //       near[0] = compareDist;
    //       index[0] = i;
    //       textValue[0] = greenlight!.docs[i]['message'];
    //       dist[0] = distCalcul(near[0]);
    //     } else if (compareDist >= near[0] && compareDist < near[1]) {
    //       near[1] = compareDist;
    //       index[1] = i;
    //       textValue[1] = greenlight!.docs[i]['message'];
    //       dist[1] = distCalcul(near[1]);
    //     }
    //   }
    // }).then((value) {
    //   if (near[1] == double.infinity) {
    //     near.removeAt(1);
    //   }
    //   if (near[0] == double.infinity) {
    //     near.removeAt(0);
    //   }
    // });
    _getUserInfo().then((value) {
      _getMyLoca();
    }).then((value) {
      info();
    }).then((value) {
      _getGreenLight();
    });
    // _getUserInfo();
    // _getMyLoca();
    // info();
    // _getGreenLight();
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

  String timeCalcul(double dist) {
    double time = dist * 60 / (-3685.1683 * myInfo['stride']! + 7977.707);
    if (time >= 60) {
      int hour = time.floor() ~/ 60;
      int minute = (time / 60).floor();
      return hour.toString() + "h " + minute.toString() + "min";
    } else {
      return time.round().toString() + " min";
    }
  }

  @override
  Widget build(BuildContext context) {
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

    // info.then((value) {
    //   myInfo = value!;
    //   myInfo['stride'] = myInfo['height']! * 0.45 / 100;
    //   double myCalories = (myInfo['stride']! * myInfo['steps']! * 60) / ((-3685.1683 * myInfo['stride']! + 7977.707) * (0.9 * myInfo['weight']! / 15));
    //   myInfo['calories'] = (myCalories * 100).round() / 100;
    //   myInfo['trees'] = ((myInfo['steps']! / 123) * 100).round() / 100;
    //   myInfo['CO2'] = (myInfo['steps']! * 0.0147 * 100).round() / 100;
    // }).then((value) {
    //   time[0] = timeCalcul(near[0]);
    //   time[1] = timeCalcul(near[1]);
    // });
    print(myInfo['steps']);

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
              today(),
              redLight(),
            ],
          ),
        ),
      ),
    );

    // return Scaffold(
    //   backgroundColor: const Color(0xffF5F5F5),
    //   body: Column(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: <Widget> [
    //       _buildFeedTop1(),
    //       // today
    //       today(),
    //       redLight(),
    //
    //       // greenlight
    //
    //     ],
    //   ),
    // );
  }

  Widget _buildFeedTop1() {
    return Builder(
        builder: (context) {
          return Container(
            margin: EdgeInsets.only(top: 18, left: 330, right: 24),
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
  Widget today() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget> [
        todayText(),
        stepAndCalorie(),
        treeAndCo2(),
      ],
    );
  }

  Widget todayText() {
    return Container(
      child: Text(
        "Today",
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
      ),
      // top 68이었음
      margin: EdgeInsets.only(left: 24, top: 15),
    );
  }

  Widget stepAndCalorie() {
    return Container(
      width: 342,
      height: 82,
      margin: EdgeInsets.only(left: 24, top: 20),
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
                margin: EdgeInsets.only(top: 14),
                child: Text(
                  "Step",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xff8C939B)),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 3),
                child: Text(
                  myInfo['steps'].toString(),
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(left: 55, right: 55),
            child: Image.asset('assets/images/step_calorie_bar.png'),
          ),
          Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 14),
                child: Text(
                  "Calorie",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xff8C939B)),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 3),
                child: Text(
                  myInfo['calories'].toString() + " kcal",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget treeAndCo2() {
    return Row(
      children: [
        //tree
        Container(
          width: 165,
          height: 165,
          margin: EdgeInsets.only(left: 24, top: 12),
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
                margin: EdgeInsets.only(top: 12),
                child: Text(
                  "Tree",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 8, bottom: 8),
                child: Image.asset('assets/images/tree_image.png'),
              ),
              Container(
                child: Text(
                  myInfo['trees'].toString() + " ▲",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),

        // carbon dioxide
        Container(
          width: 165,
          height: 165,
          margin: EdgeInsets.only(left: 12, top: 12),
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
                margin: EdgeInsets.only(top: 12),
                child: Text(
                  "Carbon Dioxide",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xffFFFFFF)),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 18, bottom: 15),
                child: Image.asset('assets/images/co2_image.png'),
              ),
              Container(
                child: Text(
                  myInfo['CO2'].toString() + " ▽",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xffFFFFFF)),
                ),
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
  Widget redLight() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget> [
        redLightText(),
        firstLight(),
        secondLight(),
      ],
    );
  }

  Widget redLightText() {
    return Container(
      child: Text(
        "Red Light",
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
      ),
      margin: EdgeInsets.only(left: 24, top: 48),
    );
  }

  Widget firstLight() {
    return Container(
      width: 342,
      height: 120,
      margin: EdgeInsets.only(left: 24, top: 20),
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
      child: Container(
          child: Row(
            children: [
              Container(
                margin: EdgeInsets.only(left: 12),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  child: Image.network(
                    imgURL[0],
                    width: 96,
                    height: 96,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 12),
                child: redLightInfo(0),
              ),
            ],
          )
      ),
    );
  }

  Widget secondLight() {
    return Container(
      width: 342,
      height: 120,
      margin: EdgeInsets.only(left: 24, top: 15),
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
      child: Container(
          child: Row(
            children: [
              Container(
                margin: EdgeInsets.only(left: 12),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  child: Image.network(
                    imgURL[1],
                    width: 96,
                    height: 96,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 12),
                child: redLightInfo(1),
              ),
            ],
          )
      ),
    );
  }

  Widget redLightInfo(int idx) {
    Color colorCode1, colorCode2;
    if (idx == 0) {
      colorCode1 = Color(0xffFFFFFF);
      colorCode2 = Color(0xffFFFFFF);
    } else {
      colorCode1 = Color(0xff000000);
      colorCode2 = Color(0xff8E9399);
    }

    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 16),
            child: Text(textValue[idx],
              //"연세대학교",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: colorCode1),
            ),
          ),
          Container(
            child: Text(
              "서울 서대문구 연희로 144",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: colorCode2),
            ),
          ),
          Container(
            width: 200,
            height: 30,
            margin: EdgeInsets.only(top: 18),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Text(dist[idx],
                    //"1km 234m",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: colorCode2),
                  ),
                ),
                Container(
                    margin: EdgeInsets.only(left: 50, bottom: 0),
                    child: Text(time[idx],
                        //"13min",
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: colorCode2
                        )
                    )
                )
              ],
            ),
          )
        ]
    );
  }
}