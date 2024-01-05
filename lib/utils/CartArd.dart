

import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce/app/controllers/CartController.dart';
import 'package:ecommerce/app/models/CartModel.dart';
import 'package:ecommerce/utils/ApiEndPoints.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class CartCArd extends StatelessWidget {
  final CartController cartController = Get.find();
  final CartModel product;
  final Function()? function1;
  final Function()? function2;
  //  String? imageUrl = snapshot.data![1][index].image;
  //                               String processedImageUrl = imageUrl != null && imageUrl.isNotEmpty && imageUrl.length > 22
  //                                   ? "${ApiEndPoints.authEndPoints.getProductImage}${imageUrl.substring(22)}"
  //                                   : "${ApiEndPoints.authEndPoints.getProductImage}defaultAvatar.jpg";
  CartCArd({required this.product, this.function1, this.function2});
  @override
  Widget build(BuildContext context) {
    print('imaaaaaaaaaa : ${ApiEndPoints.authEndPoints.getProductImage}${product.product['image']}');
    return Container(
      height: 114,
      padding: EdgeInsets.only(left: 6, top: 10, bottom: 10, right: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: Row(
        // crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 6),
            height: 82,
            width: 82,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Colors.transparent),
            child: Center(
              child: CachedNetworkImage(
                        imageUrl:'${ApiEndPoints.authEndPoints.getProductImage}${product.product['image']}',
                        width: 160,
                        height: 160,
                        //cacheKey:"profil",
                        fadeOutDuration: Duration(seconds: 1),
                        fadeInDuration:Duration(seconds: 1),
                        httpHeaders: {
                          "Authorization":
                              "Bearer ${GetStorage().read('token')}"
                        },
                        progressIndicatorBuilder: (context, url, downloadProgress) => 
                                CircularProgressIndicator(value: downloadProgress.progress),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      //   imageBuilder: (context, imageProvider) => Container(
                      //     decoration: BoxDecoration(
                      //     borderRadius: BorderRadius.circular(70),
                      //     image: DecorationImage(
                      //       image:imageProvider,
                      //       fit: BoxFit.cover,
                      //     ),
                      //   ),
                      // ),
                  )           ,
            ),
          ),
          SizedBox(
            width: 4,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(product.product['name']),
              //Text(product.product.description),
              SizedBox(
                height: 25,
              ),
              Text(product.product['price'].toString())
            ],
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: EdgeInsets.all(3),
              height: 40,
              decoration: BoxDecoration(
                  color:Color.fromARGB(255, 233, 231, 231),
                  borderRadius: BorderRadius.all(Radius.circular(4))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: function2,
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(4))),
                      child: Center(
                          child: Text(
                        '-',
                        style: TextStyle(fontSize: 24),
                      )),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                      height: 30,
                      width: 30,
                      child: GetBuilder<CartController>(builder: (controller) {
                        return Center(
                            child: Text(
                          product.qty.toString(),
                          style: TextStyle(fontSize: 18),
                        ));
                      })),
                  SizedBox(
                    width: 3,
                  ),
                  GestureDetector(
                    onTap: function1,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.all(Radius.circular(4))),
                      height: 30,
                      width: 30,
                      child: Center(
                          child: Text(
                        '+',
                        style: TextStyle(fontSize: 24),
                      )),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
