import 'package:flutter/material.dart';

class GroupPage extends StatelessWidget {
  const GroupPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            _buildGroupTop1(),
            _buildGroupTop2(),
            _buildGroupSchedule(),
            _buildGroupMembers(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xff5DC86C),
          child: const Icon(Icons.add),
          onPressed: () {},
        ),
      ),
    );

  }
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
        icon: Icon(Icons.search),
        color: Color(0xff8C939B),
      ),
      IconButton(
        iconSize: 30,
        padding: EdgeInsets.only(top: 40, right: 24),
        constraints: BoxConstraints(),
        onPressed: () {},
        icon: Icon(Icons.menu),
        color: Color(0xff8C939B),
      ),
    ],
  );
}

Widget _buildGroupTop2() {
  return Container(
    alignment: Alignment.centerLeft,
    margin: EdgeInsets.only(left: 24),
    child: Text(
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
    margin: EdgeInsets.only(top: 5, bottom: 10),
    decoration: BoxDecoration(
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
          margin: EdgeInsets.only(right: 270, top: 21, bottom: 10),
          child: Text(
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
              margin: EdgeInsets.only(left: 15, right: 70),
              child: Text(
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
              margin: EdgeInsets.only(left: 20),
              child: Text(
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

Widget _GroupContainer() {
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
        margin: EdgeInsets.only(top: 16),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(right: 100, bottom: 70),
              child: Text("Sehui", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),),
            ),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 10, bottom: 10),
                  child: Text("495kcal", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20, bottom: 10),
                  child: Text("/ 1000kcal", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Text("49.5%"),
                ),
                Container(
                  margin: EdgeInsets.only(left: 80),
                  child: Text("18%"),
                )
              ],
            )
          ],
        ),
      )
  );
}

Widget _buildGroupMembers() {
  return Expanded(
    child: SizedBox(
      height: 500,
      child: GridView.count(
        padding: EdgeInsets.only(top: 30),
        scrollDirection: Axis.vertical,
        physics: ScrollPhysics(),
        shrinkWrap: true,
        crossAxisCount: 2,
        children: <Widget>[
          for (var i = 0; i < 6; i++) _GroupContainer()
        ],
      ),
    ),
  );

}