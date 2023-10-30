import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:object_detection_app/view/homePage.dart';

List<CameraDescription>? cameras;

Future<void> main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  await initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget
{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PathFinder',
      home:  HomePage(cameras!) ,
      // home: HelpView(),
      // home: HomePage(cameras!),
    );
  }
}

