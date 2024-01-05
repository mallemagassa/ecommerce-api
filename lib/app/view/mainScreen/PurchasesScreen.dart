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

// ignore: must_be_immutable
class PurchasesScreen extends StatefulWidget {
  PurchasesScreen({super.key});

  @override
  State<PurchasesScreen> createState() => _PurchasesScreenState();
}

class _PurchasesScreenState extends State<PurchasesScreen> {

  final box = GetStorage();
  final sellers = [];
 
  final users = GetStorage().read('users') ?? [];
  @override
  Widget build(BuildContext context) {
    print(users);
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
      children: [
        Sized().sizedHeigth(24),
        NamePage(title: "Achats en ligne"),
        Sized().sizedHeigth(24),
        const PageTitel(
            title1:
                'Vous pouvez commander des articles en ligne avec vos contacts',
            title2: 'Liste des vendeurs'),
        const DeviderPage(),
        Expanded(
            child: 
            
             ListView.builder(
                      itemCount: users?.length ,
                      itemBuilder: (context, index) {
                        String? imageUrl = users[index]['image'];
                        String processedImageUrl = imageUrl != null && imageUrl.isNotEmpty && imageUrl.length > 22
                            ? "${ApiEndPoints.authEndPoints.profilUser}${imageUrl.substring(22)}"
                            : "${ApiEndPoints.authEndPoints.profilUser}defaultAvatar.jpg";
                        print(processedImageUrl);
                        
                        return Column(
                          children: [
                              if(users[index]['isSeller']) ...[
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

                                    // Image.network(
                                    //   processedImageUrl,//.substring(22),
                                    //   width: 150,
                                    //   height: 150,
                                    //   headers: {
                                    //     "Authorization":
                                    //         "Bearer ${box.read('token')}" 
                                    //   },
                                    // ),
                                    //backgroundImage: Container(),
                                  ),
                                  titleText: "${users[index]['name']}" ?? "", //contacts[index].displayName,
                                  subTitleText:"${users[index]['phone']}" ,  //contains(contacts[index].phones?.first.value ?? "") ,
                                  onTap: () {
                                    //await  UserApi(). sellers();
                                      Get.toNamed('/userProduct', arguments: <String, dynamic>{
                                        'id': users[index]['id'],
                                        'url': processedImageUrl,
                                        'name': users[index]['name'],
                                        'phone': users[index]['phone'],
                                        'isSeller': users[index]['isSeller'],
                                        'nameCom': users[index]['nameCom'],
                                        'status': users[index]['status'],
                                        'address': users[index]['address'],
                                      },
                                    );
                                  },
                                ),
                                const DeviderPage(),
                              ] else if(!users[index]['isSeller']) ...[
                                  const Center()
                              ]
                            ]

                        );
                      }),
            
            
           
        )])
    );
  }
}





