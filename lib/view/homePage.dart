import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:object_detection_app/data/string.data.dart';
import 'package:object_detection_app/view/detection/home.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../controller/AppController.dart';
import '../data/function.data.dart';

class HomePage extends StatefulWidget {
    final List<CameraDescription> cameras;
    final isFirstTime;

  HomePage(this.cameras,{this.isFirstTime=false});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
 



    void _initSpeech() async {
    if(!widget.isFirstTime){
       await FunctionData.initSpeech(cbOnError: _startListening);
    }
      _startListening();
     
  }

  void _startListening() async {
      await FunctionData.speechToText
      .listen(onResult: _onSpeechResult);
  }
  void _onSpeechResult(SpeechRecognitionResult result)async {
    print("###############################${result.recognizedWords}");
    var word = result.recognizedWords;
    
    if (word.toLowerCase().startsWith("detect") || word.toLowerCase().startsWith("détect")) {
      AppController.isPlaying.value=false;
      FunctionData.speak(text:"I launch detection", cb: (){
        HomePageDetection(widget.cameras, algo:"yolo").launch(context);
      });
     

    }else{
       FunctionData.speak(text:"I don't understand, can you repeat please again", cb: ()=>_initSpeech());
     
    }
  }


  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startSpeechIntroduction();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    FunctionData.stop();

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
          Text("MENU", style: TextStyle(color:Colors.grey, fontSize: 22, fontWeight: FontWeight.w800),),
GridView(
  shrinkWrap: true,
  physics: NeverScrollableScrollPhysics(),
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
  children: [
    Card(
      child: Stack(
        children: [
           Positioned(
            left: 25,
            child: Lottie.asset('assets/detection.json',  ).paddingBottom(12)).center(),
           Positioned(
            bottom: 18,
          
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: (FunctionData.getWidth(context)*.5),
                  child: Text("Object Detection", style: TextStyle(color:Colors.grey, fontSize: 18),).center().paddingBottom(8)),
              ],
            ))
        ],
      ).onTap((){
     HomePageDetection(widget.cameras).launch(context);

      }),
    ),
    Card(
      child: Stack(
        children: [
           Positioned(
            left: 25,
            child: Lottie.asset('assets/color.json',  ).paddingBottom(12)).center(),
           Positioned(
            bottom: 18,
            child:  Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: (FunctionData.getWidth(context)*.5),
                  child: Text("Color Detection", style: TextStyle(color:Colors.grey, fontSize: 18),).center().paddingBottom(8)),
              ],
            ))
        ],
      ),
    ),
  
    Card(
      child: Stack(
        children: [
           Positioned(
            left: 25,
            child: Lottie.asset('assets/text.json',  ).paddingBottom(12)).center(),
           Positioned(
            bottom: 18,
          
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: (FunctionData.getWidth(context)*.5),
                  child: Text("Read Text", style: TextStyle(color:Colors.grey, fontSize: 18),).center().paddingBottom(8)),
              ],
            ))
        ],
      ),
    ),
    Card(
      child: Stack(
        children: [
           Positioned(
            left: 25,
            child: Lottie.asset('assets/help.json',  ).paddingBottom(12)).center(),
           Positioned(
            bottom: 18,
            child:  Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: (FunctionData.getWidth(context)*.5),
                  child: Text("About", style: TextStyle(color:Colors.grey, fontSize: 18),).center().paddingBottom(8)),
              ],
            ))
        ],
      ),
    )
  
  ])
         
        ],
      ),
    );
  }

  void startSpeechIntroduction() {
  !widget.isFirstTime? FunctionData.speak(text:"Welcome back to path finder", cb: ()=> FunctionData.speak(text:StringData.menuSpeech,).then((value) => print("FINI"))):FunctionData.speak(text:StringData.menuSpeech);

  }
}
