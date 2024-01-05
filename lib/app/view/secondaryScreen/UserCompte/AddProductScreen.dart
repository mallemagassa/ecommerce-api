import 'dart:io';

import 'package:ecommerce/app/controllers/ProductController.dart';
import 'package:ecommerce/app/models/ProductModel.dart';
import 'package:ecommerce/data/response/serviceApi/ProductApi.dart';
import 'package:ecommerce/utils/MainButton.dart';
import 'package:ecommerce/utils/NamePageSecondary.dart';
import 'package:ecommerce/utils/SizeHeigth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';

import '../../../../utils/InputWidget.dart';

// ignore: must_be_immutable
class AddProductScreen extends StatefulWidget {
  AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  ProductController productController = Get.put(ProductController());

  final  _formKey = GlobalKey<FormBuilderState>();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
     return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: NamePageSecondary(title: "Ajout des Produits"),
      ),
      body: SingleChildScrollView(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FormBuilder(
                key: _formKey,
                child: Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 16, right: 16),
                    child: Container(
                      decoration:  BoxDecoration(
                        border:Border.all(
                          color: Color.fromARGB(255, 223, 222, 222),
                          width:1),
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Sized().sizedHeigth(20),
                            InputWidget(
                              textAlign:TextAlign.center,
                              name: 'name',
                              decoration:const  InputDecoration(
                                contentPadding: EdgeInsets.all(10),
                                label: Text("Nom de l’article"),
                                labelStyle: TextStyle(
                                     fontWeight: FontWeight.w600,
                                    color: Colors.blue),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color.fromRGBO(224, 224, 224, 1))),
                              ),
                              valideType: FormBuilderValidators.compose([
                             FormBuilderValidators.required(
                              errorText: "Cette champ est obligatoire"
                              ),
                            ]),),
                            Sized().sizedHeigth(20),
                            Obx(() {
                              return Center(
                                child: GestureDetector(
                                  onTap: () async {
                                    Get.defaultDialog(
                                      title: 'Photo de Profil',
                                      content: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          IconButton(
                                              onPressed: () {
                                                productController.getImageCamera();
                                                Get.back();
                                              },
                                              icon: Icon(Icons.camera_alt)),
                                          IconButton(
                                              onPressed: () {
                                                productController.getImageGallery();
                                                Get.back();
                                              },
                                              icon: Icon(Icons.photo))
                                        ],
                                      ),
                                    );
                                    
                                  },
                                  child: Container(
                                    width: 200.0,
                                    height: 200.0,
                                    decoration:  BoxDecoration(
                                              border:Border.all(
                                                color: Color.fromARGB(255, 223, 222, 222),
                                                width:1),
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                    child: productController.imagePath.isNotEmpty
                                        ? SizedBox(
                                          width: 200.0,
                                          child: Image.file(
                                              File(productController.imagePath.toString()),
                                              width: 200.0,
                                              height: 200.0,
                                              fit: BoxFit.cover,
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
                            Sized().sizedHeigth(20),
                            InputWidget(
                              textAlign:TextAlign.center,
                              name: 'price',
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelStyle: TextStyle(
                                     fontWeight: FontWeight.w600,
                                    color: Colors.blue),
                                contentPadding: EdgeInsets.all(10),
                                label: Text("Prix de l’article"),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color.fromRGBO(224, 224, 224, 1))),
                              ),
                              valideType: FormBuilderValidators.compose([
                                FormBuilderValidators.required(
                                  errorText: "Cette champ est obligatoire"
                                  ),
                                ]),
                            ),
                            Sized().sizedHeigth(20),
                            InputWidget(
                              textAlign:TextAlign.center,
                              name: 'quantity',
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelStyle: TextStyle(
                                     fontWeight: FontWeight.w600,
                                    color: Colors.blue),
                                contentPadding: EdgeInsets.all(10),
                                label: Text("Quantité de l’article"),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color.fromRGBO(224, 224, 224, 1))),
                              ),
                              valideType: FormBuilderValidators.compose([
                                FormBuilderValidators.required(
                                  errorText: "Cette champ est obligatoire"
                                  ),
                                ]),
                            ),
                            Sized().sizedHeigth(20),
                            InputWidget(
                              textAlign:TextAlign.center,
                              name: 'describes',
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.all(10),
                                label: Text("Details de l’article", textAlign: TextAlign.end,),
                                labelStyle: TextStyle(
                                     fontWeight: FontWeight.w600,
                                    color: Colors.blue),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color.fromRGBO(224, 224, 224, 1))),
                              ),
                              minLines: 2,
                              valideType: FormBuilderValidators.compose([
                             FormBuilderValidators.required(
                              errorText: "Cette champ est obligatoire"
                              ),
                            ]),
                            ),
                            Sized().sizedHeigth(50),
                            Stack(
                              children: [
                                Align(
                                  alignment: AlignmentDirectional.bottomCenter,
                                  child: Stack(
                                    children: [
                                      Align(
                                          alignment:
                                              AlignmentDirectional.bottomCenter,
                                          child: MainButton(
                                              onTap: !isLoading ? () async{

                                                if (_formKey.currentState?.saveAndValidate() ?? false) {
                                                  debugPrint(_formKey.currentState?.value
                                                      .toString());
                                                  debugPrint('validation');
                                                  // FocusScope.of(context).requestFocus(FocusNode());
                                                  final map = _formKey.currentState!.value;
                                                  final newMap = {
                                                    ...map,
                                                    'quantity': int.parse(map['quantity']) ,
                                                    'price': int.parse(map['price']) ,
                                                    'isSelected': false.obs,
                                                    'image': productController.imageName.value,
                                                  };

                                                  print(newMap);
                                                  ProductModel product = ProductModel.fromMap(newMap);
                                                  //print(seller.phone);
                                                  
                                              
                                                  await ProductApi().createProduct(productController.imagePath.value, productController.imageName.value, product);
                                                  Get.snackbar(
                                                    '',
                                                    '',
                                                   
                                                    duration: const Duration(seconds: 3),
                                                    messageText: const Text(
                                                    'Produits est ajouter avec succes',
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 24
                                                      ),
                                                    ),
                                                    titleText: const Icon(Icons.check, color: Colors.green, size: 32,),
                                                  
                                                  );

                                                  Get.offAndToNamed('/product');

                                                   setState(() {
                                                    isLoading = true;
                                                    // productController.imagePath.value = '';
                                                    // productController.imagePath.value = '';
                                                  });
                                                          
                                                } else {
                                                  debugPrint(_formKey.currentState?.value
                                                      .toString());
                                                  debugPrint('validation échoue');
                                                }
                                               
                                              } : null,
                                              icon: Icons.check,
                                              color: Colors.black)),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}