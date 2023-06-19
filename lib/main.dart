//import 'dart:html';
import 'dart:io';
// import 'dart:typed_data';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:riderapp/component/config.dart';
import 'package:riderapp/screens/Cancle_order.dart';
import 'package:riderapp/screens/home.dart';
import 'package:riderapp/screens/incomeRider.dart';
import 'package:riderapp/screens/location.dart';
import 'package:riderapp/screens/login.dart';
import 'package:riderapp/screens/messageScreen.dart';
import 'package:riderapp/screens/orderDetail.dart';
import 'package:riderapp/screens/profile.dart';
import 'package:riderapp/screens/register.dart';
//import 'package:riderapp/screens/preview_camera.dart';

Future<void> main() async {
  //ใช้เวลารัน api local
  //HttpOverrides.global = MyHttpOverrides();

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

//ใช้เวลารัน api local
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
