import 'package:flutter/material.dart';

class Logo extends StatelessWidget {

  const Logo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Image(
        width: 112,
        height: 112,
        fit: BoxFit.contain,
        image: AssetImage('assets/logo/logo1.jpg'));
  }
}
