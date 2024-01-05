import 'package:flutter/material.dart';

class DeviderPage extends StatelessWidget {
  const DeviderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  const Padding(
          padding: EdgeInsets.only(left: 20,right: 20) ,
          child: Divider(color: Color.fromARGB(255, 197, 195, 195),),
        );
  }
}