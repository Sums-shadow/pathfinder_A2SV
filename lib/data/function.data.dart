import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../controller/AppController.dart';

class FunctionData{

 static SpeechToText speechToText = SpeechToText();
 static bool speechEnabled = false;


  
  static Future speak({text="", cb}) async{
    await AppController.flutterTts.setLanguage("en-US");
    var result = await AppController.flutterTts.speak(text);
    if (result == 1) AppController.isPlaying.value = true;
    //check if it ends
    AppController.flutterTts.setCompletionHandler(() {
      AppController.isPlaying.value = false;
      cb();

    });
  }
  static Future pause()async{
    var result = await AppController.flutterTts.pause();
    if (result == 1) AppController.isPlaying.value = false;

  }

  static Future stop() async{
    var result = await AppController.flutterTts.stop();
    if (result == 1) AppController.isPlaying.value = false;
  }



     static Future initSpeech({cbOnError}) async {
    speechEnabled = await speechToText.initialize(
        onStatus: (val) => print("onStatus: $val"),
        onError: (val)async{
          print("onError: $val");
         cbOnError();
        },
        debugLogging: true,
        finalTimeout: const Duration(seconds: 10),
      
    );

return speechEnabled;
  }


  static getHeight(context) => MediaQuery.of(context).size.height;
  static getWidth(context) => MediaQuery.of(context).size.width;
}