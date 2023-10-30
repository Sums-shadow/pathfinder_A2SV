import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:object_detection_app/controller/AppController.dart';
import 'package:object_detection_app/data/function.data.dart';
import 'package:object_detection_app/data/string.data.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';


class HelpView extends StatefulWidget {
  const HelpView({super.key});

  @override
  State<HelpView> createState() => _HelpViewState();
}

class _HelpViewState extends State<HelpView> {
 String textSpeech = '';

  SpeechToText speechToText = SpeechToText();

  bool speechEnabled = false;

  bool listen = false;

  String _lastWords = '';

  RxString statusListening = "".obs;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initSpeech();
        ever(statusListening, (callback) => statutChanged(callback));
  }
    void initSpeech() async {
    // set speech detection languauge to english
    
    
    speechEnabled = await speechToText.initialize(
      onStatus: (status) => statusListening.value = status,
    );
    startListening();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ListView(
            children: [
              Text("How to Use PathFinder"),
              Divider(),
              Text("WORD ${AppController.currentCommand.value}", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),)
              
            ],
          ),
           Obx(() => Positioned(
                bottom: 10,
                left: 10,
                child: Icon(
                  Icons.circle,
                  size: 10,
                  color: AppController.isSpeachEnabled.value
                      ? Colors.green
                      : Colors.red,
                )))
        ],
      ),
    );
  }



    statutChanged(String callback) async {
    if (callback == StringData.listeningDone) {
      printInfo(info: "Word prounounce ${AppController.currentCommand.value}"); 
   if(AppController.currentCommand.value.toLowerCase()=="bonjour"){

 AppController.currentCommand.value = "";
        await FunctionData.speak(text: "Bonjour ca va ?");
        Timer(const Duration(seconds: 3), () {
          startListening();
        });
   } else{
        AppController.currentCommand.value = "";
        await FunctionData.speak(text: "");
        Timer(const Duration(seconds: 3), () {
          startListening();
        });
      }
    }
  }



  void startListening() async {
    AppController.isSpeachEnabled.value = true;
    await speechToText.listen(
      localeId: "en_US",
        onResult: onSpeechResult,
        listenFor: Duration(minutes: 1),
        listenMode: ListenMode.confirmation);
  }

  void stopListening() async {
    await speechToText.stop();
    AppController.isSpeachEnabled.value = false;
    // printInfo(info: "Stop listening $speechEnabled");
  }

  void onSpeechResult(SpeechRecognitionResult result) {
    _lastWords = result.recognizedWords;
    AppController.currentCommand.value = _lastWords;

    stopListening();
  }


}