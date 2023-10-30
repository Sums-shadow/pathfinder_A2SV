import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_scalable_ocr/flutter_scalable_ocr.dart';
import 'package:get/get.dart';
import 'package:object_detection_app/controller/AppController.dart';
import 'package:speech_to_text/speech_to_text.dart';

class ReadTextView extends StatefulWidget {
  const ReadTextView({super.key});

  @override
  State<ReadTextView> createState() => _ReadTextViewState();
}

class _ReadTextViewState extends State<ReadTextView> {
  String text = "";
  final StreamController<String> controller = StreamController<String>();
    SpeechToText speechToText = SpeechToText();

    
  String textSpeech = '';
  void setText(value) {
    controller.add(value);
  }

  @override
  void initState() {
    super.initState();
     AppController.pageIndex.value=2;
       initSpeech();
  }

  void initSpeech() async {
    startListening();
  }

  @override
  void dispose() {
    controller.close();
    super.dispose();
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
        body: Stack(
          children: [
            Center(
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
                      AppController.textRead.value=text;
                      return Result(
                          text: snapshot.data != null ? snapshot.data! : "");
                    },
                  )
                ],
              ),
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
        ));
  }
  
  void startListening()async {
     await speechToText.listen();
  }

  
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
