import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_scalable_ocr/flutter_scalable_ocr.dart';
import 'package:get/get.dart';
import 'package:object_detection_app/data/function.data.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:simple_speech_recognition/simple_speech_recognition.dart';

class ReadTextView extends StatefulWidget {
  const ReadTextView({super.key});

  @override
  State<ReadTextView> createState() => _ReadTextViewState();
}

class _ReadTextViewState extends State<ReadTextView> {
  String text = "";
  final StreamController<String> controller = StreamController<String>();
  String textSpeech = '';
  SimpleSpeechRecognition? speechRecognition = SimpleSpeechRecognition();
  Timer? timer;
  void setText(value) {
    controller.add(value);
  }

  @override
  void initState() {
    super.initState();
        recognize();
     streamListening();
  }

  @override
  void dispose() {
    controller.close();
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
        if (value.toLowerCase().startsWith("read")) {
          FunctionData.speak(text: text);
          
        }
      });
      printInfo(info: "RESULT AFTER INIT $textSpeech");
    } catch(e){
      printError(info: e.toString());
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Read Text OCR"),
          elevation: 0,
          leading: const SizedBox(),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.close))
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              ScalableOCR(
                  paintboxCustom: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 4.0
                    ..color = const Color.fromARGB(153, 102, 160, 241),
                  boxLeftOff: 5,
                  boxBottomOff: 2.5,
                  boxRightOff: 5,
                  boxTopOff: 2.5,
                  boxHeight: MediaQuery.of(context).size.height / 2,
                  getRawData: (value) {
                    inspect(value);
                  },
                  getScannedText: (value) {
                    setText(value);
                  }),
              StreamBuilder<String>(
                stream: controller.stream,
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  text = snapshot.data != null ? snapshot.data! : "Nothing";
                  return Result(
                      text: snapshot.data != null ? snapshot.data! : "");
                },
              )
            ],
          ),
        ));
  }

    void streamListening() => timer =
      Timer.periodic(const Duration(seconds: 2), (timer) => recognize());
}

class Result extends StatelessWidget {
  const Result({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text("Readed text: $text");
  }
}
