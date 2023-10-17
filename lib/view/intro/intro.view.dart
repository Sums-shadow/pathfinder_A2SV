import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:object_detection_app/data/string.data.dart';
import 'package:object_detection_app/view/about/about.view.dart';
import 'package:object_detection_app/view/detection/home.dart';
import 'package:object_detection_app/view/homePage.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../../controller/AppController.dart';
import '../../data/function.data.dart';

class IntroView extends StatefulWidget {
    final List<CameraDescription> cameras;

  const IntroView(this.cameras, {super.key});

  @override
  State<IntroView> createState() => _IntroViewState();
}

class _IntroViewState extends State<IntroView> {

 



    void _initSpeech() async {
    await FunctionData.initSpeech(cbOnError: _startListening);
      _startListening();
  }

  void _startListening() async {
      await FunctionData.speechToText.listen(onResult: _onSpeechResult);
  }
  void _onSpeechResult(SpeechRecognitionResult result)async {
    print("###############################${result.recognizedWords}");
    var word = result.recognizedWords;
    
    if (word.toLowerCase().startsWith("star")) {
      AppController.isPlaying.value=false;
      setValue(StringData.notFirstTime, true);
     HomePage(widget.cameras, isFirstTime: true,).launch(context, isNewTask: true);

    }else{
       FunctionData.speak(text:"I don't understand, can you repeat please one", cb: ()=>_initSpeech());
     
    }
  }

  @override
  void initState() {
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
                HomePage(widget.cameras, isFirstTime: true,).launch(context, isNewTask: true);

          }),
        ],
      ),
    );
  }

  void startSpeechIntroduction() {
    FunctionData.speak(text:StringData.WelcomeText, cb: ()=>_initSpeech()).then((value) => print("FINI"));
  }
}
