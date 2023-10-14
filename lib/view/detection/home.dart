import 'dart:async';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:object_detection_app/controller/AppController.dart';
import 'package:object_detection_app/view/homePage.dart';
import 'package:tflite/tflite.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'dart:math' as math;
import '../../data/function.data.dart';
import 'camera.dart';
import 'bndbox.dart';
import 'models.dart';

class HomePageDetection extends StatefulWidget {
  final List<CameraDescription> cameras;

  HomePageDetection(this.cameras);

  @override
  _HomePageDetectionState createState() => new _HomePageDetectionState();
}

class _HomePageDetectionState extends State<HomePageDetection> {
  List<dynamic>? _recognitions;
  int _imageHeight = 0;
  int _imageWidth = 0;
  String _model = "";
  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  late FlutterTts flutterTts;
  AppController appController = Get.put(AppController());

  @override
  void initState() {
    super.initState();
     //  FunctionData.speak(text: "There is a person in front of you");
     streamListening();
    initTTS();
    loadModel();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _speechToText.stop();
    _model="yolo";

  }

  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize(
        onStatus: (val) => print("onStatus: $val"),
        onError: (val){
          print("onError: $val");
          _initSpeech();
        },
        debugLogging: true,
        finalTimeout: const Duration(seconds: 10),
      
    );

    setState(() {
      _startListening();
    });
  }

  void _onSpeechResult(SpeechRecognitionResult result)async {
    print("###############################${result.recognizedWords}");
    var word = result.recognizedWords;
    var data = "";
    
    if (word.toLowerCase().startsWith("hello")) {
      AppController.isPlaying.value=false;
      setState(() {
        
      });

    }else if(word.toLowerCase().startsWith("exit")){
      FunctionData.speak(text: "Exiting the application", cb: (){
      HomePage(widget.cameras).launch(context, isNewTask: true, pageRouteAnimation: PageRouteAnimation.Fade);

      });
      
    }
  }

  void _startListening() async {
      await _speechToText.listen(onResult: _onSpeechResult);
    _initSpeech();
  }

  loadModel() async {
   (await Tflite.loadModel(
          model: "assets/yolov2_tiny.tflite",
          labels: "assets/yolov2_tiny.txt",
        ))!;
    
  }

  onSelect(model) {
    setState(() {
      _model = model;
    });
    loadModel();
  }

  setRecognitions(recognitions, imageHeight, imageWidth) {
    var data = "";
    for (var i = 0; i < recognitions.length; i++) {
      data = "${data + recognitions[i]["detectedClass"]} ";
    }
  if(!AppController.isPlaying.value){
    print("IIISSSSS PLAYINGGGG FALSE");
    AppController.isPlaying.value=true;
    FunctionData.speak(text: "There is a $data in front of you",cb: (){
              AppController.isPlaying.value=false;
              print("SET IS PLAYINGGG FALSE");

    } );
    
}
    print("There is $data recognitions");
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

  void streamListening() {
    Timer(const Duration(seconds: 1), () {
      if (!_speechEnabled) {
        _initSpeech();
      }
      streamListening();
    });
  }
  
  void initTTS() {
    flutterTts = FlutterTts();
  }
}
