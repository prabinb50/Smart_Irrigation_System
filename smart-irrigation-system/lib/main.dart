import 'package:flutter/material.dart';
import 'package:green_guard/pages/homepage.dart';
import 'package:green_guard/pages/plantDetail.dart';
import 'package:green_guard/pages/plantHealth.dart';
import 'package:green_guard/pages/realTimeData.dart';
import 'package:green_guard/pages/splashscreen.dart';
import 'package:green_guard/widget/getPlant.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
        home: SplashScreen()
    );
  }
}