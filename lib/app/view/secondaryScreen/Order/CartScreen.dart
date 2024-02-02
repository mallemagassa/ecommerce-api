import 'dart:io';
import 'dart:typed_data';

import 'package:ecommerce/app/controllers/CartController.dart';
import 'package:ecommerce/app/models/MessageModel.dart';
import 'package:ecommerce/app/models/OrderModel.dart';
import 'package:ecommerce/data/response/serviceApi/MessageApi.dart';
import 'package:ecommerce/data/response/serviceApi/OrderApi.dart';
import 'package:ecommerce/utils/CartArd.dart';
import 'package:ecommerce/utils/DefaultTitle.dart';
import 'package:ecommerce/utils/SizeHeigth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';
import 'package:intl/intl.dart';
import 'dart:math';

// ignore: must_be_immutable
class CartScreen extends StatefulWidget {

  CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartController cartController = Get.put(CartController());

  final argumentData = Get.arguments;

  final box = GetStorage();

  double priceTotal = 0;

  int qtyProduct = 1;

  final List<Map<String, dynamic>> map = [];

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    // print('ellllle  '+argumentData['productsCart'].toString());
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        leadingWidth: 5,
        title: const Text('Bienvenue à votre Panier d\'Achat',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        
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
                "Vous pouvez modifier les quantités des produits dont vous souhaitez commander",
                textAlign: TextAlign.center,
                size: 14,
              ),
            ),
      
            Expanded(
              child: Container(
                  margin: EdgeInsets.fromLTRB(24, 30, 24, 0),
                  child: Stack(
                    children: [
                      ListView(
                        children: [
                          GetBuilder<CartController>(builder: (controller) {
                            return SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Column(
                                  children: cartController.cartItems
                                      .map((e) => Padding(
                                          padding: const EdgeInsets.only(bottom: 10),
                                          child: CartCArd(
                                            function1: () {
                                              cartController.increasQty(e);
                                              qtyProduct = e.qty;
                                              print('Price total is ${qtyProduct}');
                                            },
                                            function2: () {
                                              cartController.decreasqty(cart: e);
                                              qtyProduct = e.qty;
                                             
                                            },
                                            product: e,
                                          )))
                                      .toList()),
                            );
                          }),
                          const SizedBox(
                            height: 150,
                          )
                        ],
                      ),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      padding: EdgeInsets.only(top: 5),
                      color: Colors.white,
                      width: double.infinity,
                      height: 130,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Total', style: TextStyle(fontSize: 18)),
                              GetBuilder<CartController>(builder: (controller) {
                                priceTotal = controller.count2;
                                //print('Price total is ${controller.count2}');
                                return 
                                Text(
                                  NumberFormat.currency(locale: 'fr', symbol: 'F', decimalDigits: 0).format(controller.count2),
                                  style: TextStyle(fontSize: 20),
                                );
                              }),
                            ],
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          ZoomTapAnimation(
                            child: GestureDetector(
                              onTap: () async{
                                    if (!isLoading) {
                                      try {
                                      
                                        setState(() {
                                          isLoading = true;
                                        });

                                        int numOrder = generateUniqueCode();

                                        final List<Map<String, dynamic>> map = [];

                                        await Future.wait(cartController.cartItems.map((element) async {
                                          String imageUrl = element.product['image'];
                                          final maps = {
                                            'priceTotal':element.product['price']*element.qty,
                                            'quantity': element.qty,
                                            'product_id': element.product['id'],
                                            'numOrder': 'C${DateFormat('ddMMyyyy').format(DateTime.now()) }$numOrder',
                                            'imageUrl': imageUrl.replaceAll('/', ''),
                                            'product_name': element.product['name'],
                                            'product_price': element.product['price'],
                                          };

                                          OrderModel orders = OrderModel.fromMap(maps);

                                          var res = await OrderApi().createOrderModel(orders);
                                          map.add(res['orders']);
                                        }));

                                        if (map.isNotEmpty) {
                                          await MessageApi().sendMessage(MessageModel(senderId: 1, receiverId: argumentData['userId'], type: 'unsupported', text: 'Votre commande a été passée avec succès. Cliquez pour voir les détails de la commande.', media: map.first['imageUrl'].substring(21), numOrder: map.first['numOrder'])); //fileName: localPath.substring(47)
                                        }

                                        Get.offAndToNamed("/chatScreen", arguments: <String, dynamic>{
                                          'id': argumentData['userId'],
                                          'name': argumentData['userName'],
                                          'url': argumentData['userUrl'],
                                          'phone': argumentData['phone'],
                                        });

                                        // cartController.cartItems.clear();
                                        // cartController.count2 = 0;

                                        setState(() {
                                          isLoading = false;
                                        });
                                      } catch (e) {
                                        print('Erreur lors de la validation de la commande : $e');
                                        setState(() {
                                          isLoading = false;
                                        });
                                      }
                                    }
                              },
                              child: Container(
                                height: 64,
                                width: double.infinity,
                                decoration:const  BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.all(Radius.circular(15)),
                                ),
                                child:  Center(
                                  child: !isLoading ? const Text(
                                    ' Valider votre Commande',
                                    style:
                                        TextStyle(fontSize: 24, color: Colors.white),
                                  ): const CircularProgressIndicator(color: Colors.white,)
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )),
                  ],
                ),
              ),
            )
      ])
    );
  }

  int generateUniqueCode() {
    List<OrderModel> orders = [];
    Random random = new Random();
    int numOrder;

    do {
      numOrder = 1000 + random.nextInt(9000);
    } while (orders.any((order) => order.numOrder == numOrder));

    return numOrder;
  }
}