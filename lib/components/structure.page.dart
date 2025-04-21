
import 'package:app/components/structure.icon.page.dart';
import 'package:flutter/material.dart';

class Structurepage extends StatelessWidget {
  const Structurepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 35, 0, 35),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          StructureIconPage(color: 0xffee615e, iconData: Icons.comment, text: 'VideoVLC', ),
        ],
      ),
    );
  }
}