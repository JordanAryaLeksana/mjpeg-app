import 'package:flutter/material.dart';

class StructureIconPage extends StatelessWidget {
  const StructureIconPage({
    super.key,
    required this.color,
    required this.iconData,
    required this.text,
    required this.onTap,
  });

  final int color;
  final IconData iconData;
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final double size = MediaQuery.of(context).size.width / 7;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: Color(color),
              borderRadius: BorderRadius.circular(size),
            ),
            child: Icon(
              iconData,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            text,
            style: const TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }
}
