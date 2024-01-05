
import 'package:ecommerce/utils/SizeHeigth.dart';
import 'package:flutter/material.dart';

class HeadAddContact extends StatelessWidget {
  final String title; //e-contacts
  final Color? color; //e-contacts
  final double? size; //e-contacts
  final IconData? icon;
  final Color? iconColor;
  const HeadAddContact({super.key,
    required this.title,
    this.color,
    this.size,
    this.icon,
    this.iconColor,
  });
  

  @override
  Widget build(BuildContext context) {
    
    return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              Icon(icon, color: iconColor,),
              Sized().sizedWith(12),
              Expanded(
                child:  Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                      Text(title,
                      style: TextStyle(
                        color: color,
                        fontSize: size ?? 10,
                        ),
                      ),
                     const Divider(color: Color.fromARGB(255, 197, 195, 195),),
                  ],
                ),
              )
            ],
          ),
        );
  }
}

