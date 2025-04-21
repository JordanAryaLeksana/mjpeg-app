import 'package:app/components/banner.page.dart';
import 'package:app/components/structure.page.dart';
import 'package:app/components/title.page.dart';
import 'package:app/components/welcome.page.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Welcomepage(),
            Titlepage(),
            Structurepage(),
            Bannerpage()
            
          ],
        ),
      ),
    );
  }
}