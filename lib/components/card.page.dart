import 'package:app/components/card.comp.dart';
import 'package:flutter/material.dart';

class CardPage extends StatelessWidget {
  const CardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 25, 0, 25),
      height: 250, // pastikan ada tinggi agar bisa tampil
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: const [
            SizedBox(width: 12),
            ComponentCard(
              color: 0xFFA0522D,
              image: 'assets/images/vlc.png',
              header: 'VideoVLC',
              description: 'Ini adalah template kartu',
            ),
            SizedBox(width: 12),
            ComponentCard(
              color: 0xFFA0522D,
              image: 'assets/images/vlc.png',
              header: 'VideoVLC',
              description: 'Ini adalah template kartu',
            ),
            SizedBox(width: 12),
            ComponentCard(
              color: 0xFFA0522D,
              image: 'assets/images/vlc.png',
              header: 'VideoVLC',
              description: 'Ini adalah template kartu',
            ),
            SizedBox(width: 12),
          ],
        ),
      ),
    );
  }
}
