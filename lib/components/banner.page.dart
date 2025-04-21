

import 'package:flutter/material.dart';

class Bannerpage extends StatelessWidget {
  const Bannerpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
       child: Material(
        elevation: 10,
        borderRadius: BorderRadius.circular(20),
        color: Colors.transparent,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.28,
          decoration: BoxDecoration(color: Color(0xfff5f5f5),borderRadius: BorderRadius.circular(20)),
          child: Row(children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(25, 25, 0, 15),
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: const Text(
                    'Drone Streaming Application',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600
                    ),
                  ), 
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(25, 0, 0, 0),
                  width: MediaQuery.of(context).size.width * 0.5,
                  child : const Text('This Application can be run with IP adress or with Wireless Connection with Drone', style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.normal
                  ),),
                )
              ],
            ) 
            ],
          ),
        ),
       ),
    );
  }
}