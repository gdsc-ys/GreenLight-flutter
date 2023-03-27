import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:green_light/models/user.dart';
import 'package:green_light/screens/home/greenlightview.dart';
import 'package:green_light/screens/shared/loading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class RLCertificationView extends StatefulWidget {
  const RLCertificationView({Key? key, required this.markerID}) : super(key: key);

  final String markerID;

  @override
  State<RLCertificationView> createState() => _RLCertificationViewState();
}

class _RLCertificationViewState extends State<RLCertificationView> {
  final db = FirebaseFirestore.instance;

  GL_User? user;

  File? _image;
  final picker = ImagePicker();

  DocumentReference<Map<String, dynamic>>? documentRef;
  DocumentReference<Map<String, dynamic>>? userRef;


  String? imageURL;
  String? message;
  int? visit;
  int? greenLight;
  String? imagePath;
  String? userName;

  bool loadingFlag = false;
  @override
  void initState() {
    super.initState();
    user = Provider.of<GL_User?>(context, listen: false);

    documentRef = db.collection("greenlights").doc(widget.markerID);


    _getRedLightInfo(widget.markerID);
    _getUserInfo();
  }

  void _getRedLightInfo(String markerID) {
    documentRef!.get().then((DocumentSnapshot<Map<String, dynamic>> value) {

      setState(() {
        imageURL = value.data()!['imageURL'];
        message = value.data()!['message'];
        visit = value.data()!['visit'];
        imagePath = value.data()!['imagePath'];
      });

    });
  }

  void _getUserInfo() {
    db.collection("users").where("uid", isEqualTo: user!.uid).get().then((QuerySnapshot<Map<String, dynamic>> value) {

      setState(() {
        userRef = value.docs[0].reference;
        greenLight = value.docs[0].data()['greenlight'];
        userName = value.docs[0].data()['nickname'];
      });
    });
  }

  Future getImage(ImageSource imageSource) async {
    final image = await picker.pickImage(source: imageSource);

    var param = false;

    setState(() {
      loadingFlag = true;
      if (image != null){
        _image = File(image.path); // 가져온 이미지를 _image에 저장

        param = true;
      }
    });

    if (param){

      List<String>? redlightTitleDescription = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => GreenLightView(previousMessage: message!,))
        );

      if (redlightTitleDescription != null) {
        final path = 'red_lights/${user!.uid}_${DateTime.now().millisecondsSinceEpoch}';

        final storageRef = FirebaseStorage.instance.ref().child(path);

        final deleteRef = FirebaseStorage.instance.ref().child(imagePath!);

        try {
          await storageRef.putFile(_image!);

          final imageURL = await storageRef.getDownloadURL();

          await deleteRef.delete();

          await documentRef!.update({"message": redlightTitleDescription[0], "imageURL": imageURL, "visit": (visit! + 1), "imagePath": path});

          await userRef!.update({"greenlight": greenLight! + 1});

          final dataOfCommunityEvent = {
            "date": Timestamp.now().toDate(),
            "type": 0,
            "nickname": userName,
          };
          await db.collection("community_events").add(dataOfCommunityEvent);
          
          Navigator.pop(context);
        } catch (e) {
          debugPrint("file is not uploaded");
          debugPrint(e.toString());
        }
      } else {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return loadingFlag || imageURL == null ? const Loading() : Scaffold(
      appBar: AppBar(
        elevation: 0,
        titleSpacing: 0,
        leading: Container(
          margin: EdgeInsets.only(left: 20.w),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            color: const Color(0xffC3C8CE),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        backgroundColor: const Color(0xffF2F3F5),
        title: Container(
          margin: EdgeInsets.only(left: 5.w),
          alignment: Alignment.centerLeft,
          child: const Text(
            'RLCertification',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 24,
              color: Color(0xff141C27),
            ),
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Container(
            width: 342.w,
            height: 200.h,
            margin: EdgeInsets.only(left: 24.w, right: 24.w, top: 24.h, bottom: 24.h),
            child: Image.network(
              imageURL!,
            ),
          ),
          Container(
            width: 342.w,
            height: 190.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              boxShadow: const <BoxShadow> [
                BoxShadow(
                  color: Color(0xffD3D3D3),
                  blurRadius: 10.0,
                  offset: Offset(0.0, 5),
                ),
              ],
              color: const Color(0xffFFFFFF),
            ),
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 35.h),
                  child: const Text(
                    "Arrived at the Red light section",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff000000),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 7.h),
                  child: const Text(
                    "Please pick up the trash nearby",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                      color: Color(0xff000000),
                    ),
                  ),
                ),
                InkWell(
                  child: Container(
                    margin: EdgeInsets.only(top: 29.h, left: 12.w, right: 12.w),
                    height: 48.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xff5DC86C),
                    ),
                    child: const Center(
                      child: Text(
                        "Certification",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color(0xffFFFFFF),
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    getImage(ImageSource.camera);
                  }
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}