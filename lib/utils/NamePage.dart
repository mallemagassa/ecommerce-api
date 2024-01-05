import 'package:flutter/material.dart';

class NamePage extends StatelessWidget {
  final String title;
  const NamePage({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Container(
        child: Row(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 24,
                color: Colors.black,
                fontWeight: FontWeight.w700
              ),
            ), // <-- Text
          ],
        ),
      ),
    );
  }
}
