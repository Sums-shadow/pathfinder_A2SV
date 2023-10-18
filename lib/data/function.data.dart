import 'package:flutter/material.dart';

import '../controller/AppController.dart';

class FunctionData {
  static bool speechEnabled = false;

  static Future speak({text = "", cb}) async {
    await AppController.flutterTts.setLanguage("en-US");
    var result = await AppController.flutterTts.speak(text);
    if (result == 1) AppController.isPlaying.value = true;
    //check if it ends
    AppController.flutterTts.setCompletionHandler(() {
      AppController.isPlaying.value = false;
      cb();
    });
  }

  static Future pause() async {
    var result = await AppController.flutterTts.pause();
    if (result == 1) AppController.isPlaying.value = false;
  }

  static Future stop() async {
    var result = await AppController.flutterTts.stop();
    if (result == 1) AppController.isPlaying.value = false;
  }

 
  static getHeight(context) => MediaQuery.of(context).size.height;
  static getWidth(context) => MediaQuery.of(context).size.width;

  static titleDecorator(title, {color = Colors.yellow}) {
    return Text(
      title,
      textAlign: TextAlign.center,
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: 40,
        foreground: Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1
          ..color = color,
      ),
    );
  }
}
