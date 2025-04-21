import 'package:app/view/Home.dart';
import 'package:app/view/vlc-video.dart';

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
      initialRoute: Routes.homeRoute,
      routes: {
        Routes.homeRoute: (context) => const Home() as Widget,
        // Routes.vlcVideo: (context) => VLCvideopage(key: UniqueKey()),
      },
    );
  }
}
