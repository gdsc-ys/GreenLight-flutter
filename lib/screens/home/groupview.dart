import 'package:flutter/material.dart';
import 'package:green_light/screens/home/drawerview.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:green_light/models/user.dart';
import 'package:provider/provider.dart';
import 'dart:math';


// This file is for each user's group details
// We didn't implement further functions such as a group master, a group creation now.
class GroupPage extends StatefulWidget {
  const GroupPage({super.key});

  @override
  State<GroupPage> createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {

  String? userName = "";
  Timestamp? dateTime;
  int? height;
  int? weight;
  static late DocumentReference gid_ref;
  List<List<String>> group_users = [];
  int group_num = 0;

  var db = FirebaseFirestore.instance;
  Future<void> _getUserInfo() async {
    GL_User? user = await Provider.of<GL_User?>(context, listen: false);
    await db.collection("users").where('uid', isEqualTo: user!.uid).get().then((userData) {
      userName = userData.docs[0].data()['nickname'];
      dateTime = userData.docs[0].data()['date_of_birth'];
      height = userData.docs[0].data()['height'];
      weight = userData.docs[0].data()['weight'];
      gid_ref = userData.docs[0].data()['gid'];
    }).then((value) async {
      await db.collection("users").where('gid', isEqualTo: gid_ref).get().then((userData) {
        for (var ud in userData.docs) {
          List<String> temp = [];
          temp.add(ud.data()['nickname']);
          temp.add(ud.data()['steps'].toString());
          if (ud.data()['uid'] == user.uid) {
            group_users.insert(0, temp);
          } else {
            group_users.add(temp);
          }
          setState(() {
            group_num++;
          });
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: DrawerView(userName: userName),
      body: Column(
        children: <Widget>[
          _buildGroupTop1(),
          _buildGroupTop2(),
          _buildGroupSchedule(),
          if (group_users.isNotEmpty) _buildGroupMembers()
          else _noGroup()
        ],
      ),
      // This floating button is now limitted.
      // Since we are not going to elaborate group views.

      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: const Color(0xff5DC86C),
      //   child: const Icon(Icons.add),
      //   onPressed: () {
      //     if (group_users.isEmpty) {

      //     }
      //   },
      // ),
    );
  }

  Widget _buildGroupTop1() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        IconButton(
          iconSize: 30,
          padding: const EdgeInsets.only(top: 40, right: 10),
          constraints: const BoxConstraints(),
          onPressed: () {},
          icon: const Icon(Icons.search),
          color: const Color(0xff8C939B),
        ),
        Builder(
            builder: (context) {
              return Container(
                margin: const EdgeInsets.only(top: 40, right: 24),
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
        ),
      ],
    );
  }

  Widget _buildGroupTop2() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.only(left: 24),
      child: const Text(
        'Group',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: Color(0xff141C27),
        ),
      ),
    );
  }

  Widget _buildGroupSchedule() {
    return Container(
      margin: const EdgeInsets.only(top: 5, bottom: 10),
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
      width: 390,
      height: 101,
      child: Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(right: 270, top: 21, bottom: 10),
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
                width: 200,
                margin: const EdgeInsets.only(left: 15, right: 70),
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
                width: 80,
                margin: const EdgeInsets.only(left: 20),
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
    return FutureBuilder(
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.none) {
          return Expanded(
            child: SizedBox(
              height: 500,
              child: GridView.count(
                padding: const EdgeInsets.only(top: 30),
                scrollDirection: Axis.vertical,
                physics: const ScrollPhysics(),
                shrinkWrap: true,
                crossAxisCount: 2,
                children: <Widget>[
                  for (var i = 0; i < group_users.length; i++) _GroupContainer(i)
                ],
              ),
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Awaiting result...');
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return Text('Result: ${snapshot.data}');
        }
      }
    );
  }

  // ignore: non_constant_identifier_names
  Widget _GroupContainer(var index) {
    // If steps ratio by 100000 is over 0.8 then change its icon's background to green.
    double ratio = min(double.parse(group_users[index][1]) / 10000, 1.0);

    if (ratio < 0.8) {
      return Container(
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
          margin: const EdgeInsets.only(left: 12, right: 12, bottom: 30),
          child: Container(
            margin: const EdgeInsets.only(top: 16),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 120, bottom: 70),
                  child: Text(group_users[index][0], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 10, bottom: 10),
                            child: Text(group_users[index][1], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            child: const Text(' steps', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),),
                          ),
                        ]
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 10, bottom: 10),
                      child: const Text("/ 10000 steps", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w400, color: Color(0xffA3A3A3)),),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      height: 5,
                      width: ratio * 160,
                      margin: const EdgeInsets.only(left: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xff5DC86C),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    Container(
                      height: 5,
                      width: (1-ratio) * 160,
                      margin: const EdgeInsets.only(right: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD1D1D1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 40, top: 5),
                      child: Text("${(ratio*100).round()}%", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 40, top: 5),
                      child: Text("${(100 - ratio*100).round()}%", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),),
                    )
                  ],
                ),
              ],
            ),
          )
      );
    } else {
      return Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            color: Color(0xff5DC86C),
          ),
          width: 165,
          height: 165,
          margin: const EdgeInsets.only(left: 12, right: 12, bottom: 30),
          child: Container(
            margin: const EdgeInsets.only(top: 16),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 120, bottom: 70),
                  child: Text(group_users[index][0], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 10, bottom: 10),
                            child: Text(group_users[index][1], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            child: const Text(' steps', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Colors.white),),
                          ),
                        ]
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 10, bottom: 10),
                      child: const Text("/ 10000 steps", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w400, color: Colors.white),),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      height: 5,
                      width: ratio * 160,
                      margin: const EdgeInsets.only(left: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    Container(
                      height: 5,
                      width: (1-ratio) * 160,
                      margin: const EdgeInsets.only(right: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD1D1D1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 40, top: 5),
                      child: Text("${(ratio*100).round()}%",
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 40, top: 5),
                      child: Text("${(100 - ratio*100).round()}%",
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white),),
                    )
                  ],
                ),
              ],
            ),
          )
      );
    }
  }

  Widget _noGroup() {
    return const Text("No Group");
  }
}