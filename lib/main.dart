import 'package:camera/camera.dart';
import 'package:face_attendance/home_page.dart';
import 'package:face_attendance/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:google_fonts/google_fonts.dart';

import 'helper_function.dart';
List<CameraDescription> cameras = [];
bool _isSigned=false;


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  try {
    cameras = await availableCameras();

  } on CameraException catch (e) {
    print(e.toString());
  }
  getUserLoggedStatus() async{
    await Helper.getUserLoggedStatus().then((value) => {
      _isSigned=value!
    });
  }


  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent
        )
    );
    return GetMaterialApp(
      title: 'Timble2.o',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:  FirebaseAuth.instance.currentUser!=null? HomePage():LoginPage(cameras: cameras,),
    );
  }
}


