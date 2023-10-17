import 'dart:async';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:tflite/tflite.dart';
import 'dart:math' as math;
import '../../controller/AppController.dart';
import '../../data/function.data.dart';
import 'camera.dart';
import 'bndbox.dart';
import 'models.dart';

class HomePageDetection extends StatefulWidget {
  final algo;
  final List<CameraDescription> cameras;

  HomePageDetection(this.cameras,{this.algo="mobilenet"});

  @override
  _HomePageDetectionState createState() => new _HomePageDetectionState();
}

class _HomePageDetectionState extends State<HomePageDetection> {
  List<dynamic>? _recognitions;
  int _imageHeight = 0;
  int _imageWidth = 0;
  String _model = "";
 
  late FlutterTts flutterTts;

  @override
  void initState() {
    super.initState();
    onSelect(ssd);
      //  FunctionData.speak(text: "There is a person in front of you");
     _initSpeech();
     streamListening();
    initTTS();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
      
  }

  void _initSpeech() async {
 
await FunctionData.initSpeech(cbOnError: _startListening);
      _startListening();

  }

  void _onSpeechResult(SpeechRecognitionResult result)async {
    print("###############################${result.recognizedWords}");
    var word = result.recognizedWords;
    var data = "";
    
    if (word.toLowerCase().startsWith("hello")) {
      AppController.isPlaying.value=false;
     

    }else if(word.toLowerCase()=="exit"){
      FunctionData.speak(text: "Exiting the application", cb: (){
       setState(() {
          _model="";
       });
      HomePageDetection(widget.cameras).launch(context, isNewTask: true, pageRouteAnimation: PageRouteAnimation.Fade);

      });
      
    }
  }

  void _startListening() async {
    await FunctionData.speechToText.listen(onResult: _onSpeechResult);
    
 
  }

  loadModel() async {
    String res;
    switch (_model) {
      case yolo:
        res = (await Tflite.loadModel(
          model: "assets/yolov2_tiny.tflite",
          labels: "assets/yolov2_tiny.txt",
        ))!;
        break;

      case mobilenet:
        res = (await Tflite.loadModel(
            model: "assets/mobilenet_v1_1.0_224.tflite",
            labels: "assets/mobilenet_v1_1.0_224.txt"))!;
        break;

      case posenet:
        res = (await Tflite.loadModel(
            model: "assets/posenet_mv1_075_float_from_checkpoints.tflite"))!;
        break;

      default:
        res = (await Tflite.loadModel(
            model: "assets/ssd_mobilenet.tflite",
            labels: "assets/ssd_mobilenet.txt"))!;
    }
    print(res);
  }

  onSelect(model) {
    setState(() {
      _model = model;
    });
    loadModel();
  }

  setRecognitions(recognitions, imageHeight, imageWidth) async{
    var data = "";
    for (var i = 0; i < recognitions.length; i++) {
      data = "${data + recognitions[i]["detectedClass"]} ";
    }
     if(!AppController.isPlaying.value){
    AppController.isPlaying.value=true;
   await FunctionData.speak(text: "There is a $data in front of you",cb: (){
    printInfo(info: "Start listening");
              _startListening();

    } );
     _startListening();
    
}

    print("There is $data recognitions  ${AppController.isPlaying.value}");
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
      if (!FunctionData.speechEnabled) {
        _startListening();
      }
      streamListening();
    });
  }
  
  void initTTS() {
    flutterTts = FlutterTts();
  }
}
