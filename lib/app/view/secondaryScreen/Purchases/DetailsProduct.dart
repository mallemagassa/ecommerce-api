import 'package:ecommerce/utils/ApiEndPoints.dart';
import 'package:ecommerce/utils/DefaultTitle.dart';
import 'package:ecommerce/utils/SizeHeigth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

// ignore: must_be_immutable
class DetailsProduct extends StatelessWidget {
  DetailsProduct({super.key});

  final box = GetStorage();
  dynamic argumentData = Get.arguments;
  @override
  Widget build(BuildContext context) {
    //print('ddddddddddddddddddddddddddd ${argumentData}');
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: false,
          leadingWidth: 5,
          
          //const DeviderPage(),//NamePageSecondary(title: "Produits "),
        ),
        body: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Sized().sizedHeigth(40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DefautText().defautTitle2(
                    "Vous pouvez discuter du prix des articles avec le fournisseur ",
                    textAlign: TextAlign.center,
                    size: 12,
                  )
                ],
              ),
              Sized().sizedHeigth(40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      DefautText().defautTitle(argumentData['name'],
                          textAlign: TextAlign.center, color: Colors.blueGrey),
                      Sized().sizedHeigth(20),
                      ZoomTapAnimation(
                        onTap: () {
                          Get.toNamed('/detailsProductImage', arguments: {
                            'url':argumentData['url']
                          });
                        },
                        child: Container(
                            width: 200.0,
                            height: 200.0,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Color.fromARGB(255, 223, 222, 222),
                                  width: 1),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: SizedBox(
                                width: 200.0,
                                child:Image.network(
                                                  "${ApiEndPoints.authEndPoints.getProductImage}${argumentData['url']}",
                                                  width: 150,
                                                  height: 150,
                                                  headers: {
                                                    "Authorization":
                                                        "Bearer ${box.read('token')}"
                                                  },
                                                ),)),///Image.asset("assets/images/phone.jpg")
                      ),
                      Sized().sizedHeigth(20),
                      DefautText().defautTitle("${argumentData['price'] }FCFA",
                          textAlign: TextAlign.center, color: Colors.blueGrey),
                      Sized().sizedHeigth(40),
                      Container(
                          width: 300.0,
                          height: 100.0,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Color.fromARGB(255, 223, 222, 222),
                                width: 1),
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(argumentData['describe']),
                          )),
                      Sized().sizedHeigth(40),
                      (box.read('info_user')['id'] != argumentData['userId']) ?
                      ZoomTapAnimation(
                        child: GestureDetector(
                          onTap: () {
                            Get.toNamed("/chatScreen", arguments: <String, dynamic>{
                                  'idProduct': argumentData['id'],
                                  'urlProduct': argumentData['url'].substring(22),
                                  'nameProduct': argumentData['name'],
                                  'priceProduct': argumentData['price'],
                                  'describeProduct': argumentData['describes'],
                                  'id': argumentData['userId'],
                                  'name': argumentData['userName'],
                                  'url': argumentData['userUrl'],
                                  'phone': argumentData['phone'],

                            });
                          },
                          child: Container(
                              width: 170.0,
                              height: 30.0,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Color.fromARGB(255, 223, 222, 222),
                                    width: 1),
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Text("Discuter le prix"),
                              )),
                        ),
                      ) :const Text('')
                    ] ,
                  )
                ],
              ),
              Sized().sizedHeigth(20),
            ]));
  }
}
