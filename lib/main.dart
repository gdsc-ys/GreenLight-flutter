import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:green_light/firebase_options.dart';
import 'package:green_light/models/map.dart';
import 'package:green_light/models/user.dart';
import 'package:green_light/screens/authenticate/authenticate.dart';
import 'package:green_light/screens/wrapper.dart';
import 'package:green_light/services/auth.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Provider 라이브러리 이용하고, 데이터에 변화가 생기는 걸 반영해서 다음 위젯에 넘김
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(390, 844),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return StreamProvider<GL_User?>.value(
            initialData: null,
            value: AuthService().user,
            child: const MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Wrapper(),
            ),
          );
        },
      );
  }
}
