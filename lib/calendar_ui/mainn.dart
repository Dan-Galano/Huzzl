import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:huzzl_web/calendar_ui/calendar.dart';


void main() {
  runApp(MyApp());
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 1500)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.custom
    ..backgroundColor =
        Color(0xFfd74a4a) 
    ..textColor = Colors.white 
    ..fontSize = 16.0 
    ..indicatorColor = Colors.white
    ..maskColor = Colors.black.withOpacity(0.5)
    ..userInteractions = false
    ..dismissOnTap = true;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    configLoading();
    return MaterialApp(
      builder: EasyLoading.init(),
      home: InterviewCalendar(),
      debugShowCheckedModeBanner: false,
    );
  }
}
