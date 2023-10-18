import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:object_detection_app/data/string.data.dart';
import 'package:object_detection_app/view/homePage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:simple_speech_recognition/simple_speech_recognition.dart';
import '../../data/function.data.dart';

class IntroView extends StatefulWidget {
    final List<CameraDescription> cameras;

  const IntroView(this.cameras, {super.key});

  @override
  State<IntroView> createState() => _IntroViewState();
}

class _IntroViewState extends State<IntroView> {

   String textSpeech = '';
  SimpleSpeechRecognition? speechRecognition = SimpleSpeechRecognition();
  Timer? timer;

 
  @override
  void initState() {
    super.initState();
    startSpeechIntroduction();
        recognize();
    streamListening();
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
        actions: [
         
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
             setValue(StringData.notFirstTime, true);
                HomePage(widget.cameras, isFirstTime: true,).launch(context, isNewTask: true);

          }),
        ],
      ),
    );
  }

  void startSpeechIntroduction() {
    FunctionData.speak(text:StringData.WelcomeText);
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
        if (value.toLowerCase().startsWith("star")) {
          setValue(StringData.notFirstTime, true);
          HomePage(widget.cameras, isFirstTime: true,).launch(context, isNewTask: true);
          
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
