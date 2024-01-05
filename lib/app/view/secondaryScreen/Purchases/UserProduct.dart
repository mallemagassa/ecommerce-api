import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce/app/controllers/ProductController.dart';
import 'package:ecommerce/app/models/ProductModel.dart';
import 'package:ecommerce/data/response/serviceApi/ProductApi.dart';
import 'package:ecommerce/utils/ApiEndPoints.dart';
import 'package:ecommerce/utils/DefaultTitle.dart';
import 'package:ecommerce/utils/SizeHeigth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:getwidget/getwidget.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../../../controllers/CartController.dart';

// ignore: must_be_immutable
class UserProduct extends StatelessWidget {
  UserProduct({super.key});

  ProductController productController = Get.put(ProductController());
  final cartController = Get.put(CartController());

  RxBool isVisible = false.obs;
  List<Map<String, dynamic>> elemSelect = [];

  dynamic argumentData = Get.arguments;
  final box = GetStorage();

  // String? imageUrl = argumentData['url'];
  // String baseUrl = ApiEndPoints.authEndPoints.profilUser;

  // String processedImageUrl = argumentData['url'] != null && argumentData['url'].isNotEmpty? "$baseUrl$argumentData['url']": "defaultAvatar.jpg";
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
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
                  'id': argumentData['id'],
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DefautText().defautTitle2(
                  "Le panier vous permet de sélectionner des articles",
                  textAlign: TextAlign.center,
                  size: 14,
                )
              ],
            ),
            Sized().sizedHeigth(20),
            Expanded(
              child: Padding( 
                padding: const EdgeInsets.all(8.0),
                child: FutureBuilder<List<ProductModel>>(
                  future: ProductApi().getDataProductSeller(argumentData['id']), 
                  builder: (context, snapshot) {
                     if (snapshot.hasData) {
                    //  final seller = snapshot.data!.where((element) => element.userId == argumentData['id']).toList();
                    //     print(seller)
                           productController.products.value = snapshot.data!;
                           return GetX<ProductController>(builder: (products) {
                                isVisible.value;
                                return 
                                  GridView.builder(
                                    key: ValueKey(argumentData['id']),
                                itemCount: productController.products.length,
                                gridDelegate:
                                    const SliverGridDelegateWithMaxCrossAxisExtent(
                                  crossAxisSpacing: 10,
                                  mainAxisExtent: 230,
                                  maxCrossAxisExtent: 300,
                                  childAspectRatio: 2,
                                ),
                                itemBuilder: (context, index) {
                                  return Obx((){
                                    return
                                    ZoomTapAnimation(
                                      child: Container(child: 
                                      GestureDetector(
                                          onTap: () {
                                            if (!isVisible.value) {
                                               Get.toNamed('/detailProduct', arguments: <String, dynamic>{
                                                'id': snapshot.data![index].id,
                                                'url': snapshot.data![index].image.substring(22),
                                                'name': snapshot.data![index].name,
                                                'price': snapshot.data![index].price,
                                                'describe': snapshot.data![index].describes,
                                                'userId': argumentData['id'],
                                                'userUrl': argumentData['url'],
                                                'phone': argumentData['phone'],
                                                'userName': argumentData['name'],
                                              });
                                            }
                                            if (isVisible.value) {
                                              productController
                                                      .products[index].isSelected.value =
                                                  !productController
                                                      .products[index].isSelected.value;
                                              if (productController
                                                      .products[index].isSelected.value ==
                                                  true) {
                                                elemSelect
                                                    .add({
                                                      'id':productController.products[index].id,
                                                      'name':productController.products[index].name,
                                                      'image':productController.products[index].image.substring(22),
                                                      'price':productController.products[index].price,
                                                      'quantity':productController.products[index].quantity,
                                                      'describes':productController.products[index].describes,
                                                      'user_id':productController.products[index].userId,
                                                      'isSelected':productController.products[index].isSelected.value,
                                                    });
                                      
                                                print(elemSelect.length);
                                      
                                                elemSelect.forEach((element) {
                                                  print("${element['price']}");
                                                });
                                              } else {
                                                elemSelect.removeWhere((element) =>
                                                    element['id'] == productController.products[index].id);
                                                print(elemSelect.length);
                                              }
                                            }
                                          },
                                          child: Card(
                                            elevation: 0,
                                            color: Color.fromARGB(255, 255, 255, 255),
                                            shape: RoundedRectangleBorder(
                                              //<-- SEE HERE
                                              side: BorderSide(
                                                color: Colors.grey,
                                              ),
                                              borderRadius: BorderRadius.circular(10.0),
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                if (isVisible.value)
                                                  Stack(
                                                    children: [
                                                      Align(
                                                          alignment:
                                                              AlignmentDirectional.topEnd,
                                                          child: productController
                                                                  .products[index]
                                                                  .isSelected
                                                                  .value
                                                              ? Icon(Icons.check_circle,
                                                                  color: Colors.green)
                                                              : Icon(Icons.circle_outlined,
                                                                  color: Colors.grey)),
                                                    ],
                                                  ),
                                                Text(snapshot.data![index].name),
                                                Image.network(
                                                  "${ApiEndPoints.authEndPoints.getProductImage}${snapshot.data![index].image.substring(22)}",
                                                  width: 150,
                                                  height: 150,
                                                  headers: {
                                                    "Authorization":
                                                        "Bearer ${box.read('token')}"
                                                  },
                                                ),
                                      
                                      
                                                // Image.asset(
                                                //   snapshot.data![index].image,
                                                //   width: 150,
                                                //   height: 150,
                                                // ),
                                                Text(
                                                    "${snapshot.data![index].price} F CFA"),
                                              ],
                                            ),
                                          ),
                                        )
                                      
                                      
                                      ),
                                    );
                                  });
                                  
                                });
                              });

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

                  })
              ),
            )
          ]),
      floatingActionButton: !isVisible.value
          ? FloatingActionButton(
              onPressed: () {
                isVisible.value = !isVisible.value;
                if (!isVisible.value) {
                //print('xxxxxxxxxx ${isVisible.value}');
                  productController.products.forEach((element) {
                    //print(elemSelect.length);
                    element.isSelected.value = false;
                  });
                  cartController.addToCart(elemSelect);
                  if (elemSelect.isNotEmpty) {
                    Get.toNamed('/cartScreen', arguments: <String, dynamic>{
                      'productsCart':elemSelect,
                      'userId': argumentData['id'],
                      'userUrl': argumentData['url'],
                      'phone': argumentData['phone'],
                      'userName': argumentData['name'],
                    });
                  }
                  //elemSelect.clear();
                }
              },
              child: Obx(
                () => isVisible.value
                    ? Icon(Icons.check)
                    : Icon(Icons.shopping_cart),
              ),
              backgroundColor: Colors.white,
            )
          : FloatingActionButton(
              onPressed: () {
                isVisible.value = !isVisible.value;
              },
              child:  Obx(
                () => isVisible.value
                    ? Icon(Icons.check)
                    : Icon(Icons.shopping_cart),
              ),
              backgroundColor: Colors.white,
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // bottomNavigationBar: BottomAppBar(
      //   elevation: 1,
      //   shape: const CircularNotchedRectangle(),
      //   notchMargin: 10,
      //   child: Container(
      //     height: 60,
      //     child: Row(
      //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //       children: [
      //         DefautText().defautTitle2(
      //           "Lait sache",
      //           textAlign: TextAlign.center,
      //           size: 14,
      //         ),
      //         DefautText().defautTitle2(
      //           "Lait en Boite",
      //           textAlign: TextAlign.center,
      //           size: 14,
      //         )
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}




// elemSelect
                                                   
                                      
                                              //   print(elemSelect);
                                      
                                              //   elemSelect.forEach((element) {
                                              //     print("${element['price']}");
                                              //   });
                                              // } else {
                                              //   //productController.products[index].isSelected.value =false;
                                              //   elemSelect.forEach((element) {
                                              //     //element['isSelected'] = false;
                                              //     //print('isSelected : ${element['isSelected']}');
                                              //     elemSelect.removeWhere((element) => element['isSelected'] == false);
                                              //   });

                                                
                                                // print(elemSelect.length);