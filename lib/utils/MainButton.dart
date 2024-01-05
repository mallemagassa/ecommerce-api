import 'package:flutter/material.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class MainButton extends StatelessWidget {
  final IconData icon;
  final Function()? onTap;
  final Color? color;
  const MainButton({required this.icon, this.onTap, this.color,super.key});

  @override
  Widget build(BuildContext context) {
    return ZoomTapAnimation(
      child: GestureDetector(
        onTap:onTap,
        child: Container(
          decoration: BoxDecoration(
            border:
                Border.all(color: Color.fromARGB(255, 223, 222, 222), width: 1),
            color: Colors.white,
            borderRadius: BorderRadius.circular(50),
          ),
          //color: Colors.white,
          width: 60,
          height: 60,
          child: Icon(icon, color: color,),
        ),
      ),
    );
  }
}
