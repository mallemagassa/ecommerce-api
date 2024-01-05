import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce/app/controllers/CartController.dart';
import 'package:ecommerce/app/models/OrderModel.dart';
import 'package:ecommerce/data/response/serviceApi/OrderApi.dart';
import 'package:ecommerce/utils/ApiEndPoints.dart';
import 'package:ecommerce/utils/DefaultTitle.dart';
import 'package:ecommerce/utils/Devider.dart';
import 'package:ecommerce/utils/SizeHeigth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:intl/intl.dart';

class DetailCartOwnerScreen  extends StatelessWidget {
  DetailCartOwnerScreen ({super.key});
  final CartController cartController = Get.put(CartController());
  final argumentData = Get.arguments;
  final box = GetStorage();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        leadingWidth: 5,
        title: GFListTile(
          avatar: GFAvatar(
            backgroundColor: Color.fromARGB(255, 228, 224, 224),
            child:  SizedBox(
              width: 160,
              height: 160,
              child:
              CachedNetworkImage(
                  imageUrl: Get.arguments['url'] != null && Get.arguments['url'].isNotEmpty? "${Get.arguments['url']}": "defaultAvatar.jpg",
                  width: 160,
                  height: 160,
                  //cacheKey:"profil",
                  fadeOutDuration: Duration(seconds: 1),
                  fadeInDuration:Duration(seconds: 1),
                  httpHeaders: {
                            "Authorization":
                                "Bearer ${box.read('token')}"
                          },
                  progressIndicatorBuilder: (context, url, downloadProgress) => 
                          CircularProgressIndicator(value: downloadProgress.progress),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(70),
                    image: DecorationImage(
                      image:imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
            ))
         
          ),
          titleText: argumentData['name'],
          subTitleText: argumentData['phone'],
          onTap: () {
            Get.toNamed('/detailProfilUserScreen', arguments: <String, dynamic>{
                  'url': argumentData['url'],
                  'phone': argumentData['phone'],
                  'name': argumentData['name'],
                  'isSeller': argumentData['isSeller'],
                  'nameCom': argumentData['nameCom'],
                  'status': argumentData['status'],
                  'address': argumentData['address'],
            });
          },
        ),
        //const DeviderPage(),//NamePageSecondary(title: "Produits "),
      ),
      body: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Sized().sizedHeigth(20),
            Center(
              child: DefautText().defautTitle2(
                "La commande que vous avez passe avec ${argumentData['name']}",
                textAlign: TextAlign.center,
                size: 14,
              ),
            ),
      
            Expanded(
              child: Container(
                  margin: EdgeInsets.fromLTRB(24, 30, 24, 0),
                  child: Stack(
                    children: [
                      FutureBuilder<List<OrderModel>>(
                        future: OrderApi().getOrderDetail(), 
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                           
                              List<OrderModel> orders = snapshot.data!; 


                            return ListView.builder(
                              itemCount: orders.length,
                              itemBuilder: (context, index) {
                              print(ApiEndPoints.authEndPoints.getOrderImage + orders[index].imageUrl.substring(22));
                                  //print('snapshot ${products[index]}');
                                 String? imageUrl = orders[index].imageUrl;
                                String processedImageUrl = imageUrl != null && imageUrl.isNotEmpty && imageUrl.length > 22
                                    ? "${ApiEndPoints.authEndPoints.getOrderImage}${orders[index].imageUrl.substring(22)}"
                                    : "${ApiEndPoints.authEndPoints.getOrderImage}defaultAvatar.jpg";
                                return SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Column(
                                            children: [
                                                Container(
                                                height: 114,
                                                padding: const EdgeInsets.only(left: 6, top: 10, bottom: 10, right: 10),
                                                decoration:const BoxDecoration(
                                                  color: Colors.white54,
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
                                                      decoration: const BoxDecoration(
                                                          borderRadius: BorderRadius.all(Radius.circular(10)),
                                                          color: Colors.transparent),
                                                      child: Center(
                                                        child: CachedNetworkImage(
                                                            imageUrl: ApiEndPoints.authEndPoints.getOrderImage + orders[index].imageUrl.substring(21),
                                                            width: 160,
                                                            height: 160,
                                                           // cacheKey:"pr",
                                                            fadeOutDuration:const Duration(seconds: 1),
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
                                                      )                      //Text('')//Image.asset(product.product.image),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 4,
                                                    ),
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text('${orders[index].productName}'),
                                                        //Text(product.product.description),
                                                        const SizedBox(
                                                          height: 25,
                                                        ),
                                                        Text('${NumberFormat.currency(locale: 'fr', symbol: 'F').format(orders[index].priceTotal)} ')
                                                      ],
                                                    ),
                                  
                                                    Align(
                                                      alignment: Alignment.bottomLeft,
                                                      child: Container(
                                                        padding: const EdgeInsets.all(3),
                                                        height: 40,
                                                        decoration: const BoxDecoration(
                                                            color:Color.fromARGB(255, 233, 231, 231),
                                                            borderRadius: BorderRadius.all(Radius.circular(4))),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                          children: [
                                                            GestureDetector(
                                                              onTap: (){},
                                                              child: Container(
                                                                height: 30,
                                                                width: 30,
                                                                decoration:const BoxDecoration(
                                                                    color: Colors.white,
                                                                    borderRadius: BorderRadius.all(Radius.circular(4))),
                                                                child:const Center(
                                                                    child: Text(
                                                                  '-',
                                                                  style: TextStyle(fontSize: 24),
                                                                )),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              width: 5,
                                                            ),
                                                             Container(
                                                                height: 30,
                                                                width: 30,
                                                                child: GetBuilder<CartController>(builder: (controller) {
                                                                  return Center(
                                                                      child: Text(orders[index].quantity.toString()
                                                                    //product.qty.toString(),
                                                                    //style: TextStyle(fontSize: 18),
                                                                  ));
                                                                })),
                                                            const SizedBox(
                                                              width: 3,
                                                            ),
                                                            GestureDetector(
                                                              onTap:  (){},
                                                              child: Container(
                                                                decoration: const BoxDecoration(
                                                                    color: Colors.blue,
                                                                    borderRadius: BorderRadius.all(Radius.circular(4))),
                                                                height: 30,
                                                                width: 30,
                                                                child: const Center(
                                                                    child: Text(
                                                                  '+',
                                                                  style: TextStyle(fontSize: 24),
                                                                )),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      
                                                    ),
                                                    
                                                  ],
                                                ),
                                              ),
                                               Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text('#N ${orders[index].numOrder}'),
                                                  Sized().sizedWith(30),
                                                  Text(DateFormat('dd-MM-yyyy HH:mm:ss').format(orders[index].createdAt!),
                                                  style: const TextStyle(
                                                    color: Colors.blue,
                                                    fontStyle: FontStyle.italic
                                                    ),
                                                  )
                                                ],
                                              ),
                                              const SizedBox(
                                                height:5,
                                              ),
                                              const DeviderPage(),
                                              // const SizedBox(
                                              //   height:10,
                                              // ),
                                            ]
                                          
                                          
                                          ),
                                );
                              },
                            );
                                 
                                
                          }else if (snapshot.hasError) {
                        return const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.network_check, weight: 100, size: 50,),
                              Text("Une erreur s'est produite lors de la connexion. Veuillez vérifier votre connexion Internet et réessayer.",
                              style: TextStyle(
                                fontSize: 16
                              ),
                              textAlign: TextAlign.center,
                              )
                            ],
                          )
                        ) ;//Text('${snapshot.error}');
                      }
                    
                      return  Center(
                        child: Container(
                          width: 20,
                          height: 20,
                          child:const  CircularProgressIndicator(),
                        ),
                      );

                        }
                      )
                     
                // Align(
                //     alignment: Alignment.bottomCenter,
                //     child: Container(
                //       padding: EdgeInsets.only(top: 5),
                //       color: Colors.white,
                //       width: double.infinity,
                //       height: 130,
                //       child: Column(
                //         children: [
                //           Row(
                //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //             children: [
                //               Text('Total', style: TextStyle(fontSize: 18)),
                //               GetBuilder<CartController>(builder: (controller) {
                //                 return Text(
                //                   '${controller.count2}',
                //                   style: TextStyle(fontSize: 20),
                //                 );
                //               }),
                //             ],
                //           ),
                //           SizedBox(
                //             height: 30,
                //           ),
                //           Container(
                //             height: 64,
                //             width: double.infinity,
                //             decoration: BoxDecoration(
                //               color: Colors.blue,
                //               borderRadius: BorderRadius.all(Radius.circular(15)),
                //             ),
                //             child: Center(
                //               child: Text(
                //                 'Commander',
                //                 style:
                //                     TextStyle(fontSize: 24, color: Colors.white),
                //               ),
                //             ),
                //           )
                //         ],
                //       ),
                //     )),
                  ],
                ),
              ),
            )
      ])
    );
  }
}