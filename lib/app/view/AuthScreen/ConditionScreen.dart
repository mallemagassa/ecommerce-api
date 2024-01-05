import 'package:ecommerce/app/view/AuthScreen/ImageProfilScreen.dart';
import 'package:ecommerce/utils/DefaultTitle.dart';
import 'package:ecommerce/utils/Logo.dart';
import 'package:ecommerce/utils/SizeHeigth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class ConditionScreen extends StatelessWidget {
  const ConditionScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  child: const Row(children: [
                    Logo()
                  ]),
                ),
                Sized().sizedHeigth(5),
                Container(
                  child: Column(children: [
                    DefautText().defautTitle("e-commerce"),
                    DefautText().defautTitle2("Commerce en ligne avec des contacts"),
                  ]),
                ),
                Sized().sizedHeigth(100),
                Container(
                  child: const Column(children: [
                    Text("Conditions générales e-commerce", style: TextStyle(
                      color: Color.fromARGB(255, 161, 159, 159),
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                    ),),
                    
                    Icon(
                      Icons.arrow_drop_down,
                      color:Colors.grey
                      ,
                    )
                  ]),
                ),
                Sized().sizedHeigth(40),
                Container(
                  child: const Padding(
                    padding:  EdgeInsets.all(20),
                    child: Text(
                      'En appuyant sur suivant, vous acceptez toutes nos conditions d’utilisation',
                      style: TextStyle(
                        fontStyle: FontStyle.italic
                      ),
                    )
                  ),
                ),

                Stack(
              children: [
                Align(
                    alignment: AlignmentDirectional.bottomEnd,
                    child: TextButton(
                      child: const Text('Suivant'),
                      onPressed: () {
                        Get.offAll(() => ImageProfilScreen());
                        //Get.toNamed("/userCompte");
                        //_formKey.currentState?.validate();
                      },
                    )),
              ],
            )
                
              ],
            )
          ,),
      )
    );
  }
}