
import 'package:flutter/material.dart';
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
        title: const Text(
          'Camera',
        ),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const RedLightView(),
              ),
            );
          },
          child: const Text(
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
