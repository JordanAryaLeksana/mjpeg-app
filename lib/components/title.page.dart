import 'package:flutter/material.dart';

class Titlepage extends StatelessWidget {
  const Titlepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(15, 20, 15, 0),
      child: const Text('Welome to Class \nStreaming Drone App', style: TextStyle(
        fontSize: 23,
        fontWeight: FontWeight.w600
      ),),
    );
  }
}
