import 'package:ecommerce/app/controllers/ProductController.dart';
import 'package:ecommerce/app/models/ProductModel.dart';
import 'package:ecommerce/data/response/serviceApi/ProductApi.dart';
import 'package:ecommerce/utils/ApiEndPoints.dart';
import 'package:ecommerce/utils/DefaultTitle.dart';
import 'package:ecommerce/utils/MainButton.dart';
import 'package:ecommerce/utils/NamePageSecondary.dart';
import 'package:ecommerce/utils/SizeHeigth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class ProdutsScreen extends StatefulWidget {
  ProdutsScreen({super.key});

  @override
  State<ProdutsScreen> createState() => _ProdutsScreenState();
}

class _ProdutsScreenState extends State<ProdutsScreen> {
  final product = GetStorage();

  final box = GetStorage();

  List<ProductModel> productsData = [];

  ProductController productController = Get.put(ProductController());

  bool isVisible = false;
  List<Map<String, dynamic>> elemSelect = [];
  Set<int> selectedIndexes = Set<int>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: NamePageSecondary(title: "Produits"),
      ),
      body: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DefautText().defautTitle2(
                    "Appuyer sur + pour ajouter un nouveau article",
                    textAlign: TextAlign.center)
              ],
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FutureBuilder<List<ProductModel>>(
                  future:  ProductApi().getData(),//ProductApi().getData(), 
                  builder:  (context, snapshot) {
                      if (snapshot.hasData) {
                       
                       productsData = snapshot.data!;

                        return GridView.builder(
                          itemCount: productsData.length,
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                            crossAxisSpacing: 10,
                            mainAxisExtent: 230,
                            maxCrossAxisExtent: 300,
                            childAspectRatio: 2,
                          ),
                          itemBuilder: (context, index) {
                            return 
                              Container(
                                child: ZoomTapAnimation(
                                  child: GestureDetector(
                                    onLongPress: () {
                                      print('LongPress ....');
                                      setState(() {
                                        isVisible = !isVisible;
                                      });

                                      // if (!isVisible.value) {
                                      //   productsData.forEach((element) {
                                      //     element.isSelected.value = false;
                                      //   });
                                      
                                      //   elemSelect.clear();
                                     // }
                                    },
                                    onTap: () {
                                      if (!isVisible) {
                                        Get.toNamed("/detailProduct", arguments: {
                                            'id': snapshot.data![index].id,
                                            'url': snapshot.data![index].image.substring(22),
                                            'name': snapshot.data![index].name,
                                            'price': snapshot.data![index].price,
                                            'describe': snapshot.data![index].describes,
                                            'userId': snapshot.data![index].userId,
                                        });
                                      }

                                      //print(product.read('products'));

                                      if (isVisible) {
                                       
                                        if (selectedIndexes.contains(index)) {
                                          setState(() {
                                            selectedIndexes.remove(index);
                                            
                                            elemSelect.removeWhere((element) =>
                                               element['id'] == productsData[index].id);
                                            // ignore: collection_methods_unrelated_type
                                            //elemSelect.remove(productsData[index]);

                                            //print('Delete is selectedIndexes ${selectedIndexes}');
                                            //print('Delete is productsData ${productsData[index].id}');
                                           
                                          });
                                          print(elemSelect.length);
                                        } else {
                                           setState(() {
                                            selectedIndexes.add(index);
                                             elemSelect
                                              .add({
                                                'id':productsData[index].id,
                                                'name':productsData[index].name,
                                                'image':productsData[index].image.substring(22),
                                                'price':productsData[index].price,
                                                'quantity':productsData[index].quantity,
                                                'describes':productsData[index].describes,
                                                'user_id':productsData[index].userId,
                                                'isSelected':productsData[index].isSelected.value,
                                              });
                                           });

                                            print(elemSelect.length);
                                  
                                            elemSelect.forEach((element) {
                                              print("${element['price']}");
                                            });
                                          // elemSelect.removeWhere((element) =>
                                          //     element['id'] == productsData[index].id);
                                          // print(elemSelect.length);
                                        }

                                      }
                                    },
                                    child: Card(
                                      elevation: 0,
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                          color: Colors.grey,
                                        ),
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          if (isVisible)
                                              Stack(
                                                children: [
                                                  Align(
                                                      alignment:
                                                          AlignmentDirectional.topEnd,
                                                      child: selectedIndexes.contains(index)
                                                              
                                                          ? Icon(Icons.check_circle,
                                                              color: Colors.green)
                                                          : Icon(Icons.circle_outlined,
                                                              color: Colors.grey)),
                                                ],
                                              ),
                                          Text(snapshot.data![index].name),
                                          Image.network(
                                            "${ApiEndPoints.authEndPoints.getProductImage}"+ snapshot.data![index].image.substring(22),
                                            width: 150,
                                            height: 150,
                                            headers: {
                                              "Authorization":
                                                  "Bearer ${box.read('token')}"
                                            },
                                          ),
                                          Text("${snapshot.data![index].price} FCFA"),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
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
                  
                  }
                  
                )
                
                
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
            
                  Stack(
                    children: [
                      Align(
                          alignment: AlignmentDirectional.bottomCenter,
                          child: MainButton(
                            icon: isVisible ? Icons.delete : Icons.add,
                            color: isVisible ? Colors.redAccent : Colors.black,
                            onTap: () {
                              if (isVisible) {
                                // setState(() {
                                //   isVisible = !isVisible;
                                // });
                                //print('element is ${elemSelect.length}');
                                if (elemSelect.isNotEmpty) {
                                  //print('element id is 1 ${elemSelect[0]}');
                                  //List<Map<String, dynamic>> i = elemSelect;
                                  Get.defaultDialog(
                                    title: 'Voulez-vous vraiment vous Supprimer ?',
                                    content: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        TextButton(
                                            onPressed: () async{
                                              //print('element id is 2 ${elemSelect}');
                                              elemSelect.forEach((element) async {
                                               await ProductApi().deleteProduct(element['id']).then((value){
                                                   Get.snackbar(
                                                  'Suppression', 
                                                  'Produit(s) est supprimer !!',
                                                  backgroundColor: Colors.greenAccent,
                                                  colorText: Colors.black,
                                                );
                                                });
                                               
                                              });
                                            setState(() {
                                              Get.back();
                                              isVisible = !isVisible;
                                            });  
                                            await ProductApi().getData();
                                            selectedIndexes.clear();      
                                            elemSelect.clear();
                                            },
                                            child: const Text('Oui',
                                            style: TextStyle(fontSize: 20),
                                            )),
                                        TextButton(
                                            onPressed: () {
                                              //productController.getImageGallery();
                                              Get.back();
                                            },
                                            child: const Text('Non',
                                            style: TextStyle(fontSize: 20),
                                            )),
                                      ],
                                    ),
                                  );
                                  
                                
                                }
         
                              }else{
                                Get.toNamed("/addProduct");
                              }
                            },
                          )),
                    ],
                  ),
                
              ],
            ),
            Sized().sizedHeigth(10)
          ]),
    );
  }
}
