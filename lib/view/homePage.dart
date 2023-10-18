import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:object_detection_app/data/string.data.dart';
import 'package:object_detection_app/view/about/about.view.dart';
import 'package:object_detection_app/view/detection/home.dart';
import 'package:object_detection_app/view/read/read.view.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:simple_speech_recognition/simple_speech_recognition.dart';

import '../data/function.data.dart';

class HomePage extends StatefulWidget {
  final List<CameraDescription> cameras;
  final isFirstTime;

  HomePage(this.cameras, {this.isFirstTime = false});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String textSpeech = '';
  SimpleSpeechRecognition? speechRecognition = SimpleSpeechRecognition();
  Timer? timer;

  
  @override
  void initState() {
    super.initState();
      recognize();
     streamListening();
    // startSpeechIntroduction();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timer!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        
      ),
      body: ListView(
        children: [
           
          FunctionData.titleDecorator("PATH FINDER", color: Colors.black),
          GridView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              children: [
                Card(
                  child: Stack(
                    children: [
                      Positioned(
                               
                              child: Lottie.asset(
                                'assets/detection.json',
                              ).paddingBottom(12).center()),
                      Positioned(
                          bottom: 18,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                  width: (FunctionData.getWidth(context) * .5),
                                  child: const Text(
                                    "Object Detection",
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 18),
                                  ).center().paddingBottom(8)),
                            ],
                          ))
                    ],
                  ).onTap(() {
                    HomePageDetection(widget.cameras).launch(context);
                  }),
                ),
                Card(
                  child: Stack(
                    children: [
                      Positioned(
                            
                              child: Lottie.asset(
                                'assets/color.json',
                              ).paddingBottom(12).center()),
                      Positioned(
                          bottom: 18,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                  width: (FunctionData.getWidth(context) * .5),
                                  child: const Text(
                                    "Color Detection",
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 18),
                                  ).center().paddingBottom(8)),
                            ],
                          ))
                    ],
                  ),
                ),
                Card(
                  child: Stack(
                    children: [
                      Positioned(
                              
                              child: Lottie.asset(
                                'assets/text.json',
                              ).paddingBottom(12).center()),
                      Positioned(
                          bottom: 18,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                  width: (FunctionData.getWidth(context) * .5),
                                  child: const Text(
                                    "Read Text",
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 18),
                                  ).center().paddingBottom(8)),
                            ],
                          ))
                    ],
                  ),
                ).onTap(() {
                  const ReadTextView().launch(context);
                }),
                Card(
                  child: Stack(
                    children: [
                      Positioned(
                               
                              child: Lottie.asset(
                                'assets/help.json',
                              ).paddingBottom(12).center()),
                      Positioned(
                          bottom: 18,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                  width: (FunctionData.getWidth(context) * .5),
                                  child: const Text(
                                    "About",
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 18),
                                  ).center().paddingBottom(8)),
                            ],
                          ))
                    ],
                  ),
                ).onTap(()=>AboutView().launch(context))
              ])
        ],
      ),
    );
  }

  void startSpeechIntroduction() {
    !widget.isFirstTime
        ? FunctionData.speak(
            text: "Welcome back to path finder",
            cb: () => FunctionData.speak(
                  text: StringData.menuSpeech,
                ).then((value) => print("FINI")))
        : FunctionData.speak(text: StringData.menuSpeech);



  }


    void recognize() async {
    if (!(await Permission.speech.isGranted)) {
      await Permission.speech.request();
      recognize();
    } else {
      initRecognition();
    }
  }

  void initRecognition() async {
    try {
      textSpeech = await speechRecognition!.start("en_EN");
      speechRecognition!.completer!.future.then((value) {
        printInfo(info: "RESULT $value");
        if (value.toLowerCase().startsWith("detect")) {
          HomePageDetection(widget.cameras).launch(context);
        } else if (value.toLowerCase().startsWith("read")) {
          const ReadTextView().launch(context);
        } else if (value.toLowerCase().startsWith("color")) {
          
        } else if (value.toLowerCase().startsWith("about")) {
          AboutView().launch(context);
          
        }
      });
      printInfo(info: "RESULT AFTER INIT $textSpeech");
    } catch(e){
      printError(info: e.toString());
    }
  }



  void streamListening() => timer =
      Timer.periodic(const Duration(seconds: 2), (timer) => recognize());
}
