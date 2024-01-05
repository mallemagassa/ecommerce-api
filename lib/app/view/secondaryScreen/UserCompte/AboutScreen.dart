import 'package:ecommerce/utils/DefaultTitle.dart';
import 'package:ecommerce/utils/Icon.dart';
import 'package:ecommerce/utils/Logo.dart';
import 'package:ecommerce/utils/NamePageSecondary.dart';
import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
     return  Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: NamePageSecondary(title: "A Propos"),
      ),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                child: Column(children: [
                  const Logo(),
                  DefautText().defautTitle2("Commerce en ligne"),

                ]),
              ),

              Container(
                //color: Colors.blue,
                child: Column(
                  children: [
                    IconHome(url: "assets/icons/cart.png"),
                ]),
              ),
              
              Container(
                //color: Colors.blue,
                child: Column(
                  children: [
                    Text(
                      textAlign:TextAlign.center,
                      "e-commerce« est une plateforme de commerce en ligne qui permet à l’utilisateur d’acheter ou de vendre des produits en ligne avec ses contacts",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800
                      ),  
                    )
                ]),
              ),

          
            ],
          )
        ,));
  }
}