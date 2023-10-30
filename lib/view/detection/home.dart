
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:object_detection_app/controller/AppController.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:tflite/tflite.dart';
import 'dart:math' as math;
import '../../data/function.data.dart';
import 'camera.dart';
import 'bndbox.dart';
import 'models.dart';

class HomePageDetection extends StatefulWidget {
  final algo;
  final List<CameraDescription> cameras;

  const HomePageDetection(this.cameras, {super.key, this.algo = "mobilenet"});

  @override
  _HomePageDetectionState createState() => _HomePageDetectionState();
}

class _HomePageDetectionState extends State<HomePageDetection> {
  List<dynamic>? _recognitions;
  int _imageHeight = 0;
  int _imageWidth = 0;
  String _model = "";

  var data = "";
  SpeechToText speechToText = SpeechToText();

  @override
  void initState() {
    super.initState();
    AppController.pageIndex.value = 1;
    onSelect(yolo);
    startListening();
  }

  @override
  void dispose() async {
    super.dispose();
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

  setRecognitions(recognitions, imageHeight, imageWidth) async {
    data = "";
    for (var i = 0; i < recognitions.length; i++) {
      data = "${data + recognitions[i]["detectedClass"]} ";
    }
    AppController.objectDetected.value = data;
    // printInfo(info: "Detect object ${AppController.startDetect.value}");
    if (AppController.startDetect.value) {
      AppController.startDetect.value = false;
      AppController.clearCurrentCommand();
      await FunctionData.speak(
          text: "There is a ${data.isEmpty ? 'nothing' : data} in front of you",
          cb: () {
            printInfo(info: "Start listening");
            startListening();
          });
    }

    // print("There is $data recognitions  ${AppController.isPlaying.value}");
    if (mounted) {
      setState(() {
        _recognitions = recognitions;
        _imageHeight = imageHeight;
        _imageWidth = imageWidth;
      });
    }
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
                      child: const Text(posenet), onPressed: () => null),
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
                Obx(() => Positioned(
                      bottom: 30,
                      left: 30,
                      child: Icon(
                        Icons.circle,
                        size: 10,
                        color: AppController.isSpeachEnabled.value
                            ? Colors.green
                            : Colors.red,
                      ).onTap(() {
                        print(Navigator.of(context));
                      }),
                    )),
              ],
            ),
    );
  }

  void startListening() async {
    await speechToText.listen();
  }
}
