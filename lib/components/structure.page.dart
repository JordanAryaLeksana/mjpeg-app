
import 'package:app/components/structure.icon.page.dart';
import 'package:flutter/material.dart';

class Structurepage extends StatelessWidget {
  const Structurepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 35, 0, 35),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          StructureIconPage(color: 0xFFA0522D, iconData: Icons.comment, text: 'VideoVLC', onTap: () => Navigator.pushNamed(context, '/vlc-video'), ),
          StructureIconPage(color: 0xFF8B3A3A, iconData: Icons.access_alarm, text: 'vlc-video', onTap: () => Navigator.pushNamed(context, '/vlc-video')),
          StructureIconPage(color: 0xFF5D8AA8, iconData: Icons.camera_alt_rounded, text: 'vlc-video', onTap: () => Navigator.pushNamed(context, '/vlc-video')),
          StructureIconPage(color: 0xFFF5F5DC, iconData: Icons.mail_lock_rounded, text: 'vlc-video', onTap: () => Navigator.pushNamed(context, '/vlc-video')),
        ],
      ),
    );
  }
}