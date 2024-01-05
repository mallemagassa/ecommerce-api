import 'package:ecommerce/utils/Icon.dart';
import 'package:ecommerce/utils/ButtonAuth.dart';
import 'package:ecommerce/utils/DefaultTitle.dart';
import 'package:ecommerce/utils/Logo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Logo(),
      ),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                child: Column(children: [
                  DefautText().defautTitle("e-commerce"),
                  DefautText().defautTitle2("Commerce en ligne avec des contacts"),

                ]),
              ),

              Container(
                //color: Colors.blue,
                child: Column(
                  children: [
                    IconHome(url: "assets/icons/cart.png"),
                    DefautText().defautTitle3("Acheter des produits en ligne")
                ]),
              ),
              
              Container(
                //color: Colors.blue,
                child: Column(
                  children: [
                    IconHome(url: "assets/icons/UserDefault.png"),
                    DefautText().defautTitle3("Chez vos contacts")
                ]),
              ),

              Container(
                //color: Colors.blue,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                  ButtonAuth(text1: "Se Connecter",text2: "à mon compte",
                  onPressed:() => Get.toNamed("/login"),
                  ),
                  ButtonAuth(text1: "S’inscrire",text2: "Si pas de compte",
                    onPressed:() => Get.toNamed("/register"),
                  )
                ]),
              ),
            ],
          )
        ,));
  }
}
