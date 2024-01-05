import 'package:ecommerce/utils/ApiEndPoints.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:zoom_widget/zoom_widget.dart';

class DetailsProductImage extends StatelessWidget {
  DetailsProductImage({super.key});
  final box = GetStorage();
  @override
  Widget build(BuildContext context) {
    //print('uuuuuuuuuuuuuuuuuuuuuuuuuu ${Get.arguments['url']}');
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          //const DeviderPage(),//NamePageSecondary(title: "Produits "),
        ),
        body:
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                  child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Color.fromARGB(255, 223, 222, 222),
                            width: 1),
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: SizedBox(
                         // width: double.infinity,
                          child: Zoom(
                            backgroundColor: Colors.white,
                            maxZoomWidth: 400,
                            maxZoomHeight: 800,
                            enableScroll:false,
                            //initScale: 10,
                            centerOnScale: true,
                            zoomSensibility: 0.05,
                            child: 
                            Image.network(
                              "${ApiEndPoints.authEndPoints.getProductImage}${Get.arguments['url']}",
                              headers: {
                                "Authorization":
                                    "Bearer ${box.read('token')}"
                              },
                            ),
                          )
                          
                          )),
                ),
            ],
          ),
        ),
        );
  }
}
