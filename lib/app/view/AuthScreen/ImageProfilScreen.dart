import 'dart:io';
import 'package:ecommerce/app/controllers/RegisterController.dart';
import 'package:ecommerce/app/view/HomeScreen.dart';
import 'package:ecommerce/utils/ApiEndPoints.dart';
import 'package:ecommerce/utils/DefaultTitle.dart';
import 'package:ecommerce/utils/Logo.dart';
import 'package:ecommerce/utils/SizeHeigth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';



// ignore: must_be_immutable
class ImageProfilScreen extends StatelessWidget {

  ImageProfilScreen({super.key});

  RegisterController registerController = Get.find();
  var box = GetStorage();



  // GlobalKey<FormState> _formKey = GlobalKey();
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
              child: const Row(children: [Logo()]),
            ),
            Sized().sizedHeigth(5),
            Container(
              child: Column(children: [
                DefautText().defautTitle("e-commerce"),
                DefautText()
                    .defautTitle2("Commerce en ligne avec des contacts"),
              ]),
            ),
            Sized().sizedHeigth(100),
            Container(
              child: Column(children: [
                const Text(
                  "Voulez-vous ajouter une photo de profil",
                  style: TextStyle(
                    color: Color.fromARGB(255, 161, 159, 159),
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                Sized().sizedHeigth(40),
                const Icon(
                  Icons.arrow_drop_down,
                  color: Colors.grey,
                ),
              ]),
            ),
            Sized().sizedHeigth(40),
            Obx(() {
              return Center(
                child: GestureDetector(
                  onTap: () async {
                    print(ApiEndPoints.authEndPoints.profilUrl);
                    Get.defaultDialog(
                      title: 'Photo de Profil',
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                              onPressed: () {
                                registerController.getImageCamera();
                                Get.back();
                              },
                              icon: Icon(Icons.camera_alt)),
                          IconButton(
                              onPressed: () {
                                registerController.getImageGallery();
                                Get.back();
                              },
                              icon: Icon(Icons.photo))
                        ],
                      ),
                    );
                    
                  },
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration:  BoxDecoration(
                              border:Border.all(
                                color: Color.fromARGB(255, 223, 222, 222),
                                width:1),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                    child: registerController.imagePath.isNotEmpty
                        ? SizedBox(
                          width: 200.0,
                          child:
                           Image.network(
                            'http://127.0.0.1:8000/api/v1/getProfilImage/',
                            headers: {
                                  "Authorization":
                                      "Bearer ${box.read('token')}"
                                },
                            width: 200.0,
                            height: 200.0,
                           ),

                         
                        )
                        : Container(
                            decoration:  BoxDecoration(
                              border:Border.all(
                                color: Color.fromARGB(255, 223, 222, 222),
                                width:1),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            width: 200,
                            height: 200,
                            child: Icon(
                              Icons.camera_alt,
                              color: Colors.grey[800],
                            ),
                          ),
                  ),
                ),
              );
            }),
         
            Sized().sizedHeigth(10),

            Stack(
              children: [
                Align(
                    alignment: AlignmentDirectional.bottomEnd,
                    child: TextButton(
                      child: const Text('Suivant'),
                      onPressed: () {
                         Get.offAll(() => HomeScreen());
                        //Get.toNamed("/condition");
                        //_formKey.currentState?.validate();
                      },
                    )),
              ],
            )
          ],
        ),
      ),
    ));
  }
}
