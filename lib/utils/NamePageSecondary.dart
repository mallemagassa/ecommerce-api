import 'package:flutter/material.dart';

class NamePageSecondary extends StatelessWidget {
  final String title;
  final Color? color;
   NamePageSecondary({required this.title, this.color = Colors.black, super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 24,
        color:color,
      ),
    );
  }
}
