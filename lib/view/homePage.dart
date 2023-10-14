import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:object_detection_app/data/string.data.dart';
import 'package:object_detection_app/view/DetectionPage.dart';
import 'package:object_detection_app/view/about/about.view.dart';
import 'package:object_detection_app/view/detection/home.dart';
import 'package:object_detection_app/view/help/help.view.dart';

import '../data/function.data.dart';

class HomePage extends StatefulWidget {
    final List<CameraDescription> cameras;

  HomePage(this.cameras);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startSpeechIntroduction();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(onPressed: ()=>AboutView().launch(context), icon: Icon(Icons.question_mark_rounded)),
          IconButton(onPressed: ()=>toast("Page not available yet"), icon: Icon(Icons.help))
       
        ],
      ),
      body: ListView(
        children: [
          Lottie.asset('assets/walk.json',   height: FunctionData.getHeight(context)*.3, width: FunctionData.getWidth(context)*.3,).paddingBottom(12),
          Center(
            child: Text(
              StringData.WelcomeText,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 30,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'medium'),
            ),
          ).paddingAll(15),
          Lottie.asset('assets/start.json',   height: FunctionData.getHeight(context)*.3, width: FunctionData.getWidth(context)*.3,).onTap((){
            // DetectionPage().launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
            HomePageDetection(widget.cameras).launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
          }),
        ],
      ),
    );
  }

  void startSpeechIntroduction() {
    FunctionData.speak(text:StringData.WelcomeText);
  }
}
