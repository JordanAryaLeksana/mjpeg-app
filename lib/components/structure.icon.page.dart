import 'package:flutter/material.dart';

class StructureIconPage extends StatelessWidget {
  const StructureIconPage({super.key, required this.color, required this.iconData, required this.text});

  final int color;
  final IconData iconData;
  final String text;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width / 7,
          height: MediaQuery.of(context).size.width / 7,
          decoration: BoxDecoration(
              color: Color(color),
              borderRadius:
                  BorderRadius.circular(MediaQuery.of(context).size.width / 7)),
          child: Icon(
            iconData,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'VLC Video',
          style: TextStyle(color: Colors.black),
        )
      ],
    );
  }
}
