
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';


class AppController extends GetxController {

 static RxInt pageIndex = 0.obs;
  static FlutterTts flutterTts = FlutterTts();
  static RxBool isPlaying = false.obs; 
  static RxBool canSpeak=false.obs;


  @override
  void onInit() {
    print("App controller init");

    super.onInit();
  }

  @override
  void dispose() {
    super.dispose();
  }

}
