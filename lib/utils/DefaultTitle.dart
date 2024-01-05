// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';


class DefautText {

  Text defautTitle(String title, {double size=24 , TextAlign textAlign = TextAlign.left, Color color=const Color.fromARGB(255, 128, 118, 118)}){
    return Text(title,
      softWrap:true,
      textAlign:textAlign,
      style: TextStyle(
        color: color,
        fontSize: size,
        fontWeight: FontWeight.bold,
      ),);
  }

  Text defautTitle2(String title,  {double size=16 , TextAlign textAlign = TextAlign.left,}){
    return Text( softWrap:true,
      textAlign: textAlign,title, style: TextStyle(
      color: Color.fromARGB(255, 161, 159, 159),
      fontSize: size,
    ),);
  }

  Text defautTitle3(String title){
    return Text(title, 
    softWrap:true,
    style:const TextStyle(
      color: Color.fromARGB(255, 56, 56, 56),
      fontSize: 16,
    ),);
  }
}
