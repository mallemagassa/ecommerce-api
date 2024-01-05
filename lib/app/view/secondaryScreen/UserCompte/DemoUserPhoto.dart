import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce/utils/NamePageSecondary.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:photo_view/photo_view.dart';

class DemoUserPhoto extends StatelessWidget {
    DemoUserPhoto({super.key});

  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        foregroundColor:Colors.white,
        backgroundColor:Colors.black,
        centerTitle: true,
        title: NamePageSecondary(title: "Image profil", color: Colors.white,),
      ),
      body: Container(
        child: PhotoView(
           minScale: PhotoViewComputedScale.contained * 1,
           maxScale: 4.0,
          imageProvider: CachedNetworkImageProvider(
            Get.arguments['url'] != null && Get.arguments['url'].isNotEmpty? "${Get.arguments['url']}": "defaultAvatar.jpg",
            //cacheKey:"${DateTime.now().microsecondsSinceEpoch}",
            headers: {
                      "Authorization":
                          "Bearer ${box.read('token')}"
                    },
            ),
          ),
          
          //AssetImage("assets/images/defaultAvatar.jpg"),
        )
      );
  }
}