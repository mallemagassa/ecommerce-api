import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce/app/controllers/RegisterController.dart';
import 'package:ecommerce/app/view/secondaryScreen/UserCompte/CommercialAccount.dart';
import 'package:ecommerce/app/view/secondaryScreen/UserCompte/DemoProfilPhoto.dart';
import 'package:ecommerce/utils/DefaultTitle.dart';
import 'package:ecommerce/utils/InputWidget.dart';
import 'package:ecommerce/utils/NamePageSecondary.dart';
import 'package:ecommerce/utils/SizeHeigth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

// ignore: must_be_immutable
class ProfilUserScreen extends StatefulWidget {
  ProfilUserScreen({super.key});

  @override
  State<ProfilUserScreen> createState() => _ProfilUserScreenState();
}

class _ProfilUserScreenState extends State<ProfilUserScreen> {
  RegisterController registerController = Get.find();

  var box = GetStorage();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
   
  }

  RxBool isSeller = true.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: NamePageSecondary(title: "Compte utilisateur"),
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
                                        Get.to(DemoProfilPhoto(),
                                            fullscreenDialog: true,
                                            transition: Transition.zoom);
                                      },
                                      child: 
                                      SizedBox(
                                        width: 160,
                                        height: 160,
                                        child: CircleAvatar(
                                          child:
                                          // registerController.imageIsDefine.value ?
                                              SizedBox(
                                                  width: 160,
                                                  height: 160,
                                                  child: 
                                                  CachedNetworkImage(
                                                      imageUrl: "https://ecommerce.doucsoft.com/api/v1/getProfilImage",
                                                      width: 160,
                                                      height: 160,
                                                      cacheKey: registerController.key.value,
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
                                                  
                                                  // CircleAvatar(
                                                  //   foregroundImage:
                                                  //   Image.network(
                                                  //         'https://ecommerce.doucsoft.com/api/v1/getProfilImage/',
                                                  //         headers: {
                                                  //               "Authorization":
                                                  //                   "Bearer ${box.read('token')}"
                                                  //             },
                                                  //         width: 160,
                                                  //         height: 160,
                                                  //       ).image
                                                    
                                                  //   //  Image.file(
                                                  //   //   File(registerController.imagePath
                                                  //   //       .toString()),
                                                  //   //   width: 200.0,
                                                  //   //   height: 200.0,
                                                  //   //   fit: BoxFit.fitHeight,
                                                  //   // ).image,
                                                  // ),
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
                                    Positioned(
                                        bottom: 7,
                                        right: 8,
                                        child: Container(
                                            width: 48,
                                            height: 48,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(100),
                                                color: Colors.blue[400]),
                                            child: TextButton(
                                                onPressed: () {
                                                  Get.defaultDialog(
                                                    title: 'Photo de Profil',
                                                    content: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.spaceEvenly,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment.center,
                                                      children: [
                                                        IconButton(
                                                            onPressed: () {
                                                              //CachedNetworkImage.evictFromCache('https://ecommerce.doucsoft.com/api/v1/getProfilImage/');
                                                              registerController
                                                                  .getImageCamera();
                                                             Get.back(
                                                                result: true
                                                              );
                                                              //Get.snackbar('Succes', 'Votre profil est mis a jour', colorText: Colors.black, backgroundColor: Colors.greenAccent);
                                                              setState(() {
                                                                registerController.key.value;
                                                              });
                                                            },
                                                            icon: Icon(Icons.camera_alt)),
                                                        IconButton(
                                                            onPressed: () {
                                                              setState(() {
                                                                
                                                              });
                                                              //CachedNetworkImage.evictFromCache('https://ecommerce.doucsoft.com/api/v1/getProfilImage/');
                                                              registerController
                                                                  .getImageGallery();
                                                              Get.back(
                                                                result: true
                                                              );
                                                              //Get.snackbar('Succes', 'Votre profil est mis a jour', colorText: Colors.black, backgroundColor: Colors.greenAccent);
                                                              //Get.to(DemoProfilPhoto());
                                                              setState(() {
                                                                registerController.key.value;
                                                                setState(() {
                                                                  setState(() {
                                                                    
                                                                  });
                                                                });
                                                              });
                                                            
                                                            },
                                                            icon: Icon(Icons.photo))
                                                      ],
                                                    ),
                                                  );
                                                },
                                                child: const Center(
                                                    child: Icon(
                                                  Icons.camera_alt,
                                                  color: Colors.white,
                                                ))))),
                                  ],
                                ),
                              ),
                          
                            Sized().sizedHeigth(24),
                            DefautText().defautTitle2(box.read('info_user')['phone'], size: 24)
                          ],
                        )
                      ],
                    ),
                    Sized().sizedHeigth(24),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          box.read('info_user')['isSeller'] ?
                          // snapshot.data![0].isSeller 
                          ElevatedButton.icon(
                            
                            style: ElevatedButton.styleFrom(
                               backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    //to set border radius to button
                                    borderRadius: BorderRadius.circular(8)),
                                padding: EdgeInsets.all(15)),
                            onPressed: () {
                              Get.to(CommercialAccount(),
                                  fullscreenDialog: true, transition: Transition.zoom);
                            },
                            
                            icon: Icon(Icons.add, color: Colors.blue),
                            label: Text(
                              "Modifier mon compte",
                              style: TextStyle(color: Colors.blue),
                            ),
                            
                          )
                          :ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    //to set border radius to button
                                    borderRadius: BorderRadius.circular(8)),
                                padding: EdgeInsets.all(15)),
                            onPressed: () {
                              Get.to(CommercialAccount(),
                                  fullscreenDialog: true, transition: Transition.zoom);
                            },
                            icon: Icon(Icons.add, color: Colors.blue),
                            label: Text(
                              "Créer un compte commercial",
                              style: TextStyle(color: Colors.blue),
                            ),
                          )
                        ],
                      ),
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
                              initialValue: box.read('info_user')['nameCom'],
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
                                  box.read('info_user')['status'],
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
                              initialValue:box.read('info_user')['address'],//snapshot.data![0].address,
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
