
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:object_detection_app/data/string.data.dart';
import 'package:weather/weather.dart';



class AppController extends GetxController {
static String urlbase="http://wa.good-vibes.africa";
 static RxInt pageIndex = 0.obs;
  static FlutterTts flutterTts = FlutterTts();
  static RxBool isPlaying = false.obs; 
  static RxBool canSpeak=false.obs;

  static RxString objectDetected="".obs;
    static RxString currentCommand="".obs;
    static RxBool startDetect=false.obs;
        static RxString textRead="".obs;
    static RxBool isSpeachEnabled=false.obs;



  @override
  void onInit() {
    print("App controller init");

    super.onInit();
  }

  @override
  void dispose() {
    super.dispose();
  }

  static clearCurrentCommand()=>currentCommand.value="";


  static sendMessageHelp(Weather w)async{
      var dio = Dio();
 await dio.post("$urlbase/send-message", data: {
  "message":"*SOS from ${getStringAsync(StringData.user)}*\n* * * * * * * * * * * * *\n*LOCALISATION:*\n⤷Long: ${w.longitude}\n⤷Lat: ${w.latitude}\nCountry: ${w.country}\nDate & Time: ${w.date!.toIso8601String()}\n\n░_by binary brain_░",
  "number":"0824550480"
});
  }

}
