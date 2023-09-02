import 'package:flutter/material.dart';
import 'package:object_detection_app/HomePage.dart';
import 'package:camera/camera.dart';

List<CameraDescription>? cameras;

Future<void> main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(MyApp());
}

class MyApp extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Object Detection',
      home: HomePage(),
    );
  }
}

