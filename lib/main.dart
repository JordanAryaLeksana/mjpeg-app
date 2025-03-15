import 'package:app/pages/Home.dart';
import 'package:app/pages/mjpeg.dart';
import 'package:flutter/material.dart';
import 'package:app/utils/routes.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: Routes.mjpegStreamRoute,
      routes: {
        Routes.homeRoute: (context) => const Home() as Widget,
        Routes.mjpegStreamRoute: (context) => const MjpegExample(),
      },
    );
  }
}



