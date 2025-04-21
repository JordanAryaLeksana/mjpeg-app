
import 'package:flutter/material.dart';

class Welcomepage extends StatelessWidget {
  const Welcomepage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ListTile(
      title:  Text('welcome!', style: TextStyle(
        fontSize: 12
        ),
      ),
      subtitle: Text('Christy Angelina', style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.black
      ),
      ),
      trailing: Icon(Icons.notification_add_outlined),
    );
  }
}