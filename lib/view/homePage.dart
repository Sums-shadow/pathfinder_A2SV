import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:object_detection_app/controller/AppController.dart';
import 'package:object_detection_app/controller/commandController.dart';
import 'package:object_detection_app/data/string.data.dart';
import 'package:object_detection_app/view/about/about.view.dart';
import 'package:object_detection_app/view/detection/home.dart';
import 'package:object_detection_app/view/read/read.view.dart';
import 'package:shake/shake.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:vibration/vibration.dart';
import 'package:weather/weather.dart';
import '../data/function.data.dart';
  import 'package:geolocator/geolocator.dart';
  

class HomePage extends StatefulWidget {
  final List<CameraDescription> cameras;

  const HomePage(this.cameras, {super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String textSpeech = '';
  SpeechToText speechToText = SpeechToText();
  bool speechEnabled = false;
  bool listen = false;
  String _lastWords = '';
  RxString statusListening = "".obs;
  bool hasShake=false;
  bool isScanQrCode=false;
  CommandController commandController = CommandController();

Position? position ;
WeatherFactory wf =  WeatherFactory(StringData.ow_key, language: Language.ENGLISH);
  @override
  void initState() {
    super.initState();
    AppController.pageIndex.value=0;
    startSpeechIntroduction();
    initSpeech();
    initPosition();
    ShakeDetector.autoStart(onPhoneShake: () {
      sendSOS();
    });
    ever(statusListening, (callback) => statutChanged(callback));
  }

  void initSpeech() async {
    // set language to english
    speechEnabled = await speechToText.initialize(
      options: [],
      onStatus: (status) => statusListening.value = status,
    );
startListening();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Stack(
          children: [
            getStringAsync(StringData.user).isEmpty
                ? _newPage()
                : ListView(
                    children: [
                      FunctionData.titleDecorator("PATH FINDER",
                          color: Colors.black),
                      // Obx(() => Text("MOT ${ AppController.currentCommand.value}")),
                      GridView(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2),
                          children: [
                            Card(
                              child: Stack(
                                children: [
                                  Positioned(
                                      child: Lottie.asset(
                                    'assets/detection.json',
                                  ).paddingBottom(12).center()),
                                  Positioned(
                                      bottom: 18,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                              width: (FunctionData.getWidth(
                                                      context) *
                                                  .5),
                                              child: const Text(
                                                "Object Detection",
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 18),
                                              ).center().paddingBottom(8)),
                                        ],
                                      ))
                                ],
                              ).onTap(() {
                                HomePageDetection(widget.cameras)
                                    .launch(context);
                              }),
                            ),
                            Card(
                              child: Stack(
                                children: [
                                  Positioned(
                                      child: Lottie.asset(
                                    'assets/qrcode.json',
                                  ).paddingBottom(12).center()),
                                  Positioned(
                                      bottom: 18,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                              width: (FunctionData.getWidth(
                                                      context) *
                                                  .5),
                                              child: const Text(
                                                "Scan QRCode",
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 18),
                                              ).center().paddingBottom(8)),
                                        ],
                                      ))
                                ],
                              ),
                            ).onTap((){
                             scanQr();
                            }),
                            Card(
                              child: Stack(
                                children: [
                                  Positioned(
                                      child: Lottie.asset(
                                    'assets/text.json',
                                  ).paddingBottom(12).center()),
                                  Positioned(
                                      bottom: 18,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                              width: (FunctionData.getWidth(
                                                      context) *
                                                  .5),
                                              child: const Text(
                                                "Read Text",
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 18),
                                              ).center().paddingBottom(8)),
                                        ],
                                      ))
                                ],
                              ),
                            ).onTap(() {
                              const ReadTextView().launch(context);
                            }),
                            Card(
                              child: Stack(
                                children: [
                                  Positioned(
                                      child: Lottie.asset(
                                    'assets/help.json',
                                  ).paddingBottom(12).center()),
                                  Positioned(
                                      bottom: 18,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                              width: (FunctionData.getWidth(
                                                      context) *
                                                  .5),
                                              child: const Text(
                                                "About",
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 18),
                                              ).center().paddingBottom(8)),
                                        ],
                                      ))
                                ],
                              ),
                            ).onTap(() => const AboutView().launch(context))
                          ]),
                           
          //  Lottie.asset("assets/africa.json", width: 130)
                         // Obx(() => Text("WORD ${AppController.currentCommand.value} $statusListening"))
                    ],
                  ),
                  Positioned(
                    bottom: 30,
                    right: MediaQuery.of(context).size.width/3,
                    child: Column(

                      children: [
                        Image.asset("assets/a2sv.jpeg", width: 100),
                        const Text("By binary brain", style: TextStyle(color: Colors.grey),)
                      ],
                    ),),
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

  void startSpeechIntroduction() {
    
 
    getStringAsync(StringData.user).isNotEmpty
        ? FunctionData.speak(
            text:
                "Welcome back${getStringAsync(StringData.user)} to path finder",
            cb: () => FunctionData.speak(
                text: StringData.menuSpeech, cb: startListening))
        : FunctionData.speak(
            text: StringData.WelcomeText,
            cb: () => FunctionData.speak(
                text: StringData.nameRequestText, cb: startListening));
  }

  void startListening() async {
    AppController.isSpeachEnabled.value = true;
    await speechToText.listen(
      
        onResult: onSpeechResult,
        
        listenFor: const Duration(hours: 1),
        listenMode: ListenMode.dictation);
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

  statutChanged(String callback) async {
    if (callback == StringData.listeningDone) {
      printInfo(
          info:
              "Speech said ${AppController.currentCommand.value}} Object detect ${AppController.objectDetected}");
      if (getStringAsync(StringData.user).isEmpty) {
        if (AppController.currentCommand.value.isNotEmpty) {
          setValue(StringData.user, AppController.currentCommand.value);
          setState(() {});
          AppController.currentCommand.value = "";
          FunctionData.speak(
              text: "Hi ${getStringAsync(StringData.user)}!",
              cb: () => FunctionData.speak(
                  text: StringData.menuSpeech, cb: startListening));
        } else {
          startListening();
        }
        return;
      }
    

      if (["detection", "detect", "détection", "détect"].contains(AppController.currentCommand.value)) {
        AppController.currentCommand.value = "";
        // stopListening();
        if (mounted) {
          await HomePageDetection(widget.cameras).launch(context);
        }
      } else if (["read", "launch read", "lire"].contains(AppController.currentCommand.value.toLowerCase())) {
        AppController.currentCommand.value = "";
        const ReadTextView().launch(context);
      } else if (["scan", "what is in front of me", "what is this","what's this"].contains(AppController.currentCommand.value.toLowerCase())) {
        AppController.startDetect.value = true;
        printInfo(info:"Detect Objectttt ${AppController.objectDetected}");
      }else if (["is someone in front of me", "is there a person"].contains(AppController.currentCommand.value.toLowerCase())) {
        AppController.startDetect.value = true;
      } else if (["can you read", "what is write","reading", "lecture"].contains(AppController.currentCommand.value.toLowerCase())) {
        await FunctionData.speak(
            text: AppController.textRead.value.isEmpty
                ? "Nothing is written here"
                : "Here what i can read, ${AppController.textRead.value}",
            cb: () {
              AppController.currentCommand.value = "";
              startListening();
            });
      } else if (["back", "return", "bac","bec", "retour", "home"].contains(AppController.currentCommand.value.toLowerCase())) {
        Get.back();
        AppController.currentCommand.value = "";
        startListening();
      } else if (["about", "à propos", "what is this application","tell about path finder"].contains(AppController.currentCommand.value.toLowerCase())) {
        stopListening();
        aboutPayhFinder();
     
      }else if (AppController.currentCommand.value.isEmpty) {
        stopListening();
        Timer(const Duration(seconds: 3), () {
          startListening();
        });
      } else if(["yes", "sure","sur","oui"].contains(AppController.currentCommand.value.toLowerCase())){
        if(hasShake){
          position ??= await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
          Weather w = await wf.currentWeatherByLocation(position!.latitude, position!.longitude);
          AppController.sendMessageHelp(w);
          hasShake=false;
          AppController.currentCommand.value="";
          FunctionData.speak(text: "We send a S.O.S message with your details", cb: startListening);
        }else{
          startListening();
        }
      } else if(AppController.currentCommand.value.toLowerCase()=="non"){
        if(hasShake){
          hasShake=false;
          AppController.currentCommand.value="";
          FunctionData.speak(text: "okay", cb: startListening);
        }
      }else if(["what's time", "what is time", "tell me time","what time is it", "quelle heure", "time"].contains(AppController.currentCommand.value.toLowerCase())){
          AppController.currentCommand.value="";
          FunctionData.speak(text: "It's ${DateTime.now().hour} hour ${DateTime.now().minute} minutes", cb: startListening);
      }else if(AppController.currentCommand.value.toLowerCase().contains("quelle est la date")){
          AppController.currentCommand.value="";
          FunctionData.speak(text: "It's ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}", cb: startListening);
      }else if(["qr code", "scan qr code"].contains(AppController.currentCommand.value.toLowerCase())){
          AppController.currentCommand.value="";
         scanQr();
        startListening();
      }else if(["weather", "what's weather", "what is weather","quel temps fait il"].contains(AppController.currentCommand.value.toLowerCase())){
          AppController.currentCommand.value="";
                    position ??= await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  Weather w = await wf.currentWeatherByLocation(position!.latitude, position!.longitude);
  print(w.toJson())
; await FunctionData.speak(text: "It's ", cb: ()=>FunctionData.speak(text: w.weatherDescription));
        Timer(const Duration(seconds: 3), () {
          startListening();
        });
        startListening();
      }else if(AppController.currentCommand.value.toLowerCase().contains("annuler")){
          AppController.currentCommand.value="";
        if(isScanQrCode){
          isScanQrCode=false;
          Get.back();
          startListening();
        }
      }else{
        AppController.currentCommand.value = "";
        await FunctionData.speak(text: "Sorry I didn't get that");
        Timer(const Duration(seconds: 3), () {
          startListening();
        });
      }
    }
  }

  _newPage() {
    return ListView(
      children: [
        Lottie.asset(
          'assets/walk.json',
          height: FunctionData.getHeight(context) * .3,
          width: FunctionData.getWidth(context) * .3,
        ).paddingBottom(12),
        Center(
          child: Text(
            StringData.WelcomeText,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 30,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
                fontFamily: 'medium'),
          ),
        ).paddingAll(15),
        Lottie.asset(
          'assets/start.json',
          height: FunctionData.getHeight(context) * .3,
          width: FunctionData.getWidth(context) * .3,
        ).onTap(() {
          setValue(StringData.notFirstTime, true);
          HomePage(
            widget.cameras,
          ).launch(context, isNewTask: true);
        }),
      ],
    );
  }
  
  void sendSOS()async {
    // Weather w = await wf.currentWeatherByLocation(position!.latitude, position!.longitude);
    // print("WEATHER ${w.areaName}\n${w.cloudiness}\n${w.country}\n${w.date}\n${w.humidity}\n${w.latitude}\n${w.longitude}\n${w.pressure}\n${w.rainLast3Hours}\n${w.rainLastHour}\n${w.temperature}\n${w.weatherDescription}\n${w.toJson()}");
Vibration.vibrate(duration: 500);
    hasShake=true;
     FunctionData.speak(text: "Do you want to send S.O.S message?", cb: startListening);
  }
  
  void initPosition() async{
     LocationPermission permission;
     permission = await Geolocator.checkPermission();
     if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale 
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }
   position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

    Future<void> scanQr() async {
      isScanQrCode=true;
    try {
      
      FlutterBarcodeScanner.scanBarcode('#2A99CF', 'cancel', true, ScanMode.QR)
          .then((value) async {
       if(value!="-1") FunctionData.speak(text: "The Qrcode says: ", cb: ()=> FunctionData.speak(text: "$value"));
       
      }).whenComplete(() => isScanQrCode=false);
    } catch (e) {
      print("ERRRRRRRRRRRR $e");
      
    }
  }
  
  void aboutPayhFinder() {
    FunctionData.speak(text: "Path Finder is an application that helps visually impaired people adapt to the environment where they are by detecting objects around them, reading certain texts and QR codes, and talking with their voice assistant", cb: startListening).then((value) => AppController.currentCommand.value="");
  }

// did change app lifecylce
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      startListening();
    } else if (state == AppLifecycleState.paused) {
      stopListening();
    }
  }
}
