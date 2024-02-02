import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce/contactConfig/ContactConfig.dart';
import 'package:ecommerce/utils/ApiEndPoints.dart';
import 'package:ecommerce/utils/Devider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';

class OdersScreen extends StatefulWidget {
  OdersScreen({super.key});

  @override
  State<OdersScreen> createState() => _OdersScreenState();
}

class _OdersScreenState extends State<OdersScreen> {
  final orders = GetStorage().read('orders') ?? [];

  final ordersReceirve =  GetStorage().read('ordersReceirve') ?? [];

   @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
    if (ordersReceirve.isEmpty) {
      setState(() {
        ContactConfig().loadAndgetMyOdersReceirve();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print( '::::::::::::::::::: $ordersReceirve');

      // setState(() {
      //   ContactConfig().loadAndgetMyOdersReceirve();
      // });

    return DefaultTabController(
          length: 2,
          child: 
          Scaffold(
              backgroundColor: Colors.white,
               appBar: AppBar(
                elevation: 0,
                backgroundColor: Colors.white,
                      bottom:const PreferredSize(
                      preferredSize: Size.fromHeight(0), 
                      child: TabBar(
                        labelColor: Colors.blue,
                        indicatorColor: Colors.blue,
                        tabs: [
                          Tab(text: 'Mes Commandes',),
                          Tab(text: 'Commandes reçues',),
                        ],
                      ),
                      ) 
                    ),
              body: TabBarView(
                children: [
                    Column(
                  children: [
                    Expanded(
                        child: ListView.builder(
                                  key:const  ValueKey('order'),
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
                ),
                Column(
                  children: [
                    Expanded(
                        child: ListView.builder(   
                                  key:const ValueKey('orderRecei') ,
                                  itemCount: ordersReceirve?.length,
                                  itemBuilder: (context, index) {
                                    String? imageUrl = ordersReceirve[index]['image'];
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
                                                      errorWidget: (context, url, error) => const Icon(Icons.error),
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
                                              titleText: "${ordersReceirve[index]['name']}" ?? "",
                                              subTitleText:"${ordersReceirve[index]['phone']}" , 
                                              onTap: () {                                    
                                                  Get.toNamed('/detailCartReceirveScreen', arguments: <String, dynamic>{
                                                    'id': ordersReceirve[index]['id'],
                                                    'url': processedImageUrl,
                                                    'conversation_id': ordersReceirve[index]['conversation_id'],
                                                    'phone': ordersReceirve[index]['phone'],
                                                    'name': ordersReceirve[index]['name'],
                                                    'isSeller': ordersReceirve[index]['isSeller'],
                                                    'nameCom': ordersReceirve[index]['nameCom'],
                                                    'status': ordersReceirve[index]['status'],
                                                    'address': ordersReceirve[index]['address'],
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
              ),
                ],)
          )  
        );
    
  }
}
