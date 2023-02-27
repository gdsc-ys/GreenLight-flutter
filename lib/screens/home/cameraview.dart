import 'dart:io';
import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
//import 'package:study_project/previewpage.dart';
import 'package:green_light/screens/home/redlightview.dart';

class CameraView extends StatefulWidget {
  const CameraView({Key? key}) : super(key: key);

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Camera',
        ),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RedLightView(),
              ),
            );
          },
          child: Text(
            '찰칵',
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 30,
            ),
          ),
        ),
      ),
    );
  }
}
