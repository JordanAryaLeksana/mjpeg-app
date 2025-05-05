

import 'package:flutter/material.dart';

class ComponentCard extends StatelessWidget {
  const ComponentCard({super.key, required this.color, required this.header, required this.description, required this.image});

  final String header;
  final String description;
  final String image;
  final int color;
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width / 3;
    final double height = MediaQuery.of(context).size.height / 4;
   
    return Container(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: Color(color),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                const SizedBox(height: 10),
                Text(
                  header.toString(),
                  style: const TextStyle(color: Colors.black),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Image.asset(
                    image,
                    width: width * 0.5,
                    height: height * 0.5,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  description.toString(),
                  style: const TextStyle(color: Colors.black),
                ),
              ],
            ),
          )
        ],
      ) ,
      );
  }
}