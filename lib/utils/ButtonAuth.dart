import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ButtonAuth extends StatelessWidget {
  final String text1;
  final String text2;
  void Function()? onPressed;

  ButtonAuth({
    Key? key,
    this.onPressed,
    required this.text1,
    required this.text2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          shadowColor: Colors.blue,
          primary: Colors.white, //background color of button
          //side: BorderSide(width:1, color:Colors.black), //border width and color
          elevation: 3, //elevation of button
          shape: RoundedRectangleBorder(
              //to set border radius to button
              borderRadius: BorderRadius.circular(5)),
          padding: EdgeInsets.all(20) //content padding inside button
          ),
      onPressed:onPressed ,
      child: Column(
        children: [
          Text(
            text1,
            style: const TextStyle(
              color: Color.fromARGB(255, 56, 56, 56),
              fontSize: 16,
              fontStyle: FontStyle.italic),
          ),
          Text(
            text2,
            style:const TextStyle(
              color: Colors.grey, 
              fontStyle: FontStyle.italic),
          )
        ],
      ),
    );
  }
}
