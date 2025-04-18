import 'package:flutter/material.dart';
import 'package:flutter_mjpeg/flutter_mjpeg.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Stream'),
      ),
      body: Center(
        child: Mjpeg(
          isLive: true,
          stream: 'http://10.124.30.238:8080/stream.mjpeg?clientid=pskpxxz5e4nddjh2',
          error: (context, error, stack) {
            print(error);
            return Text(
              error.toString(),
              style: const TextStyle(color: Colors.red),
            );
          },
        ),
      ),
    );
  }
}
