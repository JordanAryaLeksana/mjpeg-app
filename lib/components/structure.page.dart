
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
          StructureIconPage(color: 0xFFA0522D, iconData: Icons.comment, text: 'VideoVLC', ),
          StructureIconPage(color: 0xFF8B3A3A, iconData: Icons.access_alarm, text: 'VideoVLC', ),
          StructureIconPage(color: 0xFF5D8AA8, iconData: Icons.camera_alt_rounded, text: 'VideoVLC', ),
          StructureIconPage(color: 0xFFF5F5DC, iconData: Icons.mail_lock_rounded, text: 'VideoVLC', ),
        ],
      ),
    );
  }
}