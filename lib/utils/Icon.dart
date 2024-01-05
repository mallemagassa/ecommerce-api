import 'package:flutter/material.dart';

// ignore: must_be_immutable
class IconHome extends StatelessWidget {
  String url;
  IconHome({required this.url, super.key});

  @override
  Widget build(BuildContext context) {
    return Image(
        fit: BoxFit.contain, width: 72, height: 72, image: AssetImage(url));
  }
}
