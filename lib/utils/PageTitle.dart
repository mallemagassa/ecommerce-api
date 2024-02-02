import 'package:ecommerce/utils/SizeHeigth.dart';
import 'package:flutter/material.dart';

class PageTitel extends StatelessWidget {
  final String title1;
  final String? title2;

  const PageTitel({required this.title1, this.title2, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 7, right: 7),
          child: Container(
            width: double.infinity,
            color: Colors.grey,
            child: Center(
              child: 
                Text(
                  //textAlign:TextAlign.center,
                  title1,
                  // "Vous pouvez mettre vos articles en ligne en créant un compte commercial",
                  style: const TextStyle(
                      fontSize: 10, color: Colors.white),
                ),
            ),
            
          ),
        ),
        Sized().sizedHeigth(24),
        Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Row(
            children: [
              Text(
                title2 ?? '',
                style: TextStyle(
                    color: Colors.blue,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
