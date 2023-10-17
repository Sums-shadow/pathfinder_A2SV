import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:object_detection_app/data/string.data.dart';
import 'package:object_detection_app/view/homePage.dart';
import 'package:object_detection_app/view/intro/intro.view.dart';

List<CameraDescription>? cameras;

Future<void> main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  await initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PathFinder',
      home: getBoolAsync(StringData.notFirstTime)?HomePage(cameras!): IntroView(cameras!),
      // home: HomePage(cameras!),
    );
  }
}

