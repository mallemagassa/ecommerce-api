import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce/utils/ApiEndPoints.dart';
import 'package:ecommerce/utils/Devider.dart';
import 'package:ecommerce/utils/NamePage.dart';
import 'package:ecommerce/utils/PageTitle.dart';
import 'package:ecommerce/utils/SizeHeigth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';

class OdersScreen extends StatelessWidget {
  OdersScreen({super.key});
  final orders = GetStorage().read('orders') ?? [];
  @override
  Widget build(BuildContext context) {
    print(orders);
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
      children: [
        Sized().sizedHeigth(24),
        NamePage(title: "Commandes"),
        Sized().sizedHeigth(24),
        const PageTitel(title1: 'Commandes avec des contacts', title2: 'Avec'),
        const DeviderPage(),
        Expanded(
            child: ListView.builder(
                      itemCount: orders?.length ,
                      itemBuilder: (context, index) {
                        String? imageUrl = orders[index]['image'];
                        String processedImageUrl = imageUrl != null && imageUrl.isNotEmpty && imageUrl.length > 22
                            ? "${ApiEndPoints.authEndPoints.profilUser}${imageUrl.substring(22)}"
                            : "${ApiEndPoints.authEndPoints.profilUser}defaultAvatar.jpg";
                        print(processedImageUrl);
                        
                        return Column(
                          children: [
                                GFListTile(
                                  avatar:  GFAvatar(
                                    backgroundColor: Color.fromARGB(255, 228, 224, 224),
                                    child: SizedBox(
                                      width: 160,
                                      height: 160,
                                      child:
                                      CachedNetworkImage(
                                          imageUrl: processedImageUrl,
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
                                  titleText: "${orders[index]['name']}" ?? "",
                                  subTitleText:"${orders[index]['phone']}" , 
                                  onTap: () {                                    
                                      Get.toNamed('/detailCartScreen', arguments: <String, dynamic>{
                                        'id': orders[index]['id'],
                                        'url': processedImageUrl,
                                        'conversation_id': orders[index]['conversation_id'],
                                        'phone': orders[index]['phone'],
                                        'name': orders[index]['name'],
                                        'isSeller': orders[index]['isSeller'],
                                        'nameCom': orders[index]['nameCom'],
                                        'status': orders[index]['status'],
                                        'address': orders[index]['address'],
                                      },
                                    );
                                  },
                                ),
                                const DeviderPage(),
                              
                            ]

                        );
                      }),
            
              )
      ],
    ));
  }
}
