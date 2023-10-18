import 'dart:async';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tflite/tflite.dart';
import 'dart:math' as math;
import '../../data/function.data.dart';
import 'camera.dart';
import 'bndbox.dart';
import 'models.dart';
import 'package:simple_speech_recognition/simple_speech_recognition.dart';

class HomePageDetection extends StatefulWidget {
  final algo;
  final List<CameraDescription> cameras;

  HomePageDetection(this.cameras, {this.algo = "mobilenet"});

  @override
  _HomePageDetectionState createState() => new _HomePageDetectionState();
}

class _HomePageDetectionState extends State<HomePageDetection> {
  List<dynamic>? _recognitions;
  int _imageHeight = 0;
  int _imageWidth = 0;
  String _model = "";
  String textSpeech = '';
  SimpleSpeechRecognition? speechRecognition = SimpleSpeechRecognition();
  Timer? timer;
  bool describ = false;

  @override
  void initState() {
    super.initState();
     onSelect(ssd);

    recognize();
     streamListening();
  }

  @override
  void dispose() async {
    super.dispose();
    timer!.cancel();
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
      print("Object $textSpeech");
      speechRecognition!.completer!.future.then((value) {
        printInfo(info: "RESULT $value");
        if (value == "what is in front of me") {
          describ = true;
        }
      });
      printInfo(info: "RESULT AFTER INIT $textSpeech");
    } catch(e){
      printError(info: e.toString());
    }
  }

  loadModel() async {
      
       await Tflite.loadModel(
            model: "assets/ssd_mobilenet.tflite",
            labels: "assets/ssd_mobilenet.txt");
  }

  onSelect(model) {
    setState(() {
      _model = model;
    });
    loadModel();
  }

  setRecognitions(recognitions, imageHeight, imageWidth) async {
    var data = "";
    for (var i = 0; i < recognitions.length; i++) {
      data = "${data + recognitions[i]["detectedClass"]} ";
    }
    if (describ) {
      describ = false;
      await FunctionData.speak(
          text: "There is a $data in front of you",
          cb: () {
            printInfo(info: "Start listening");
          });
    }

    // print("There is $data recognitions  ${AppController.isPlaying.value}");
    setState(() {
      _recognitions = recognitions;
      _imageHeight = imageHeight;
      _imageWidth = imageWidth;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return Scaffold(
      body: _model == ""
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    child: const Text(ssd),
                    onPressed: () => onSelect(ssd),
                  ),
                  ElevatedButton(
                    child: const Text(yolo),
                    onPressed: () => onSelect(yolo),
                  ),
                  ElevatedButton(
                    child: const Text(mobilenet),
                    onPressed: () => onSelect(mobilenet),
                  ),
                  ElevatedButton(
                    child: const Text(posenet),
                    onPressed: () => onSelect(posenet),
                  ),
                  ElevatedButton(
                      child: const Text(posenet), onPressed: () => recognize()),
                ],
              ),
            )
          : Stack(
              children: [
                Camera(
                  widget.cameras,
                  _model,
                  setRecognitions,
                ),
                BndBox(
                    _recognitions ?? [],
                    math.max(_imageHeight, _imageWidth),
                    math.min(_imageHeight, _imageWidth),
                    screen.height,
                    screen.width,
                    _model),
              ],
            ),
    );
  }

  void streamListening() => timer =
      Timer.periodic(const Duration(seconds: 2), (timer) => recognize());
}
