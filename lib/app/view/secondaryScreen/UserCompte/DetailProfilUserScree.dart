import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce/app/controllers/RegisterController.dart';
import 'package:ecommerce/app/view/secondaryScreen/UserCompte/DemoProfilPhoto.dart';
import 'package:ecommerce/app/view/secondaryScreen/UserCompte/DemoUserPhoto.dart';
import 'package:ecommerce/utils/DefaultTitle.dart';
import 'package:ecommerce/utils/InputWidget.dart';
import 'package:ecommerce/utils/NamePageSecondary.dart';
import 'package:ecommerce/utils/SizeHeigth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

// ignore: must_be_immutable
class DetailProfilUserScreen extends StatefulWidget {
  DetailProfilUserScreen({super.key});

  @override
  State<DetailProfilUserScreen> createState() => _DetailProfilUserScreenState();
}

class _DetailProfilUserScreenState extends State<DetailProfilUserScreen> {
  RegisterController registerController = Get.find();

  var box = GetStorage();

  RxBool isSeller = true.obs;
  @override
  Widget build(BuildContext context) {
    print('${Get.arguments}');
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: NamePageSecondary(title: "${Get.arguments['name']}"),
      ),
      body:   Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Sized().sizedHeigth(20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Center(
                                child: Stack(
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        Get.to(DemoUserPhoto(),
                                            fullscreenDialog: true,
                                            transition: Transition.zoom,
                                            arguments: {
                                              'url':Get.arguments['url']
                                            }
                                            );
                                      },
                                      child: SizedBox(
                                        width: 160,
                                        height: 160,
                                        child: CircleAvatar(
                                          child:
                                          
                                              SizedBox(
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
                                                  
                                                //   // CircleAvatar(
                                                //   //   foregroundImage:
                                                //   //   Image.network(
                                                //   //         'https://ecommerce.doucsoft.com/api/v1/getProfilImage/',
                                                //   //         headers: {
                                                //   //               "Authorization":
                                                //   //                   "Bearer ${box.read('token')}"
                                                //   //             },
                                                //   //         width: 160,
                                                //   //         height: 160,
                                                //   //       ).image
                                                    
                                                //   //   //  Image.file(
                                                //   //   //   File(registerController.imagePath
                                                //   //   //       .toString()),
                                                //   //   //   width: 200.0,
                                                //   //   //   height: 200.0,
                                                //   //   //   fit: BoxFit.fitHeight,
                                                //   //   // ).image,
                                                //   // ),
                                                ))
                                              // : const SizedBox(
                                              //     width: 160,
                                              //     height: 160,
                                              //     child: CircleAvatar(
                                              //       foregroundImage: AssetImage(
                                              //           "assets/images/defaultAvatar.jpg"),
                                              //     ),
                                              //   ),
                                        ),
                                      ),
                                    ),
                                    // Positioned(
                                    //     bottom: 7,
                                    //     right: 8,
                                    //     child: Container(
                                    //         width: 48,
                                    //         height: 48,
                                    //         decoration: BoxDecoration(
                                    //             borderRadius: BorderRadius.circular(100),
                                    //             color: Colors.blue[400]),
                                    //         child: TextButton(
                                    //             onPressed: () {
                                    //               Get.defaultDialog(
                                    //                 title: 'Photo de Profil',
                                    //                 content: Row(
                                    //                   mainAxisAlignment:
                                    //                       MainAxisAlignment.spaceEvenly,
                                    //                   crossAxisAlignment:
                                    //                       CrossAxisAlignment.center,
                                    //                   children: [
                                    //                     IconButton(
                                    //                         onPressed: () {
                                    //                           registerController
                                    //                               .getImageCamera();
                                    //                           Get.back();
                                    //                           setState(() {
                                                                
                                    //                           });
                                    //                         },
                                    //                         icon: Icon(Icons.camera_alt)),
                                    //                     IconButton(
                                    //                         onPressed: () {
                                    //                           registerController
                                    //                               .getImageGallery();
                                    //                           Get.back();
                                    //                           setState(() {
                                                                
                                    //                           });
                                    //                         },
                                    //                         icon: Icon(Icons.photo))
                                    //                   ],
                                    //                 ),
                                    //               );
                                    //             },
                                    //             child: const Center(
                                    //                 child: Icon(
                                    //               Icons.camera_alt,
                                    //               color: Colors.white,
                                    //             ))))),
                                  ],
                                ),
                              ),
                          
                            Sized().sizedHeigth(24),
                            DefautText().defautTitle2(Get.arguments['phone'], size: 24)
                          ],
                        )
                      ],
                    ),
                    Sized().sizedHeigth(24),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 16, right: 16),
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Sized().sizedHeigth(10),
                            InputWidget(
                              enabled: false,
                              textAlign: TextAlign.center,
                              name: '',
                              initialValue:(Get.arguments['nameCom'] == 'null') ? '':Get.arguments['nameCom'],
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.all(10),
                                label: Text("Nom commercial",
                                  style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
                                ),
                                labelStyle:
                                    TextStyle(color: Color.fromARGB(255, 179, 178, 178)),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color.fromRGBO(224, 224, 224, 1))),
                              ),
                            ),
                            Sized().sizedHeigth(10),
                            InputWidget(
                              enabled: false,
                              textAlign: TextAlign.center,
                              name: '',
                              initialValue:
                                  (Get.arguments['status'] == 'null') ? '':Get.arguments['status'],
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.all(10),
                                label: Text("Statut commercial",
                                  style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
                                ),
                                labelStyle:
                                    TextStyle(color: Color.fromARGB(255, 179, 178, 178)),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color.fromRGBO(224, 224, 224, 1))),
                              ),
                              minLines: 4,
                            ),
                            Sized().sizedHeigth(10),
                            InputWidget(
                              enabled: false,
                              textAlign: TextAlign.center,
                              name: '',
                              initialValue:(Get.arguments['address'] == 'null') ? '':Get.arguments['address'],//snapshot.data![0].address,
                              decoration:const InputDecoration(
                                labelStyle:
                                    TextStyle(color: Color.fromARGB(255, 179, 178, 178)),
                                contentPadding: EdgeInsets.all(10),
                                label: Text("Adresse commercial",
                                style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
                                ),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color.fromRGBO(224, 224, 224, 1))),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                )
    
    );
  }
}
