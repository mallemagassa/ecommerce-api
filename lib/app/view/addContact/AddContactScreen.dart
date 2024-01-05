import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce/app/view/addContact/FormContact.dart';
import 'package:ecommerce/contactConfig/ContactConfig.dart';
import 'package:ecommerce/utils/ApiEndPoints.dart';
import 'package:ecommerce/utils/Devider.dart';
import 'package:ecommerce/utils/HeadAddContact.dart';

import 'package:ecommerce/utils/SizeHeigth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class AddContactScreen extends StatefulWidget {
  const AddContactScreen({super.key});

  @override
  State<AddContactScreen> createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {
  
  final box = GetStorage();
  final sellers = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ContactConfig().loadAndgetConversation();
  }

  @override
  Widget build(BuildContext context) {
    final users = box.read('users') ?? [];
    
    return  Scaffold(
      appBar:AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back), // Icône de retour par défaut
          onPressed: () {
            // Action à effectuer lors du clic sur le bouton de retour
            // Par exemple, pour retourner à l'écran précédent :
            Navigator.of(context).pop();
          },
        ),
        actions: [],
      ),
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //NamePage(title: "Achats en ligne"),
        Sized().sizedHeigth(24),
        const Center(child: Text('Envoyer un Message',
          style: TextStyle(
            color: Colors.grey
          ),
        ),),
        Sized().sizedHeigth(24),
        const HeadAddContact(title:'e-contacts', size: 22, color: Color.fromARGB(255, 20, 99, 164), icon: Icons.person_add_alt_sharp, iconColor: Color.fromARGB(255, 20, 99, 164),),
        Sized().sizedHeigth(10),
        ZoomTapAnimation(
          child: GestureDetector(
            onTap: (){
              Get.to(FormContac());
            },
            child: const HeadAddContact(title:'Nouveau Contact', size: 16, color: Color.fromARGB(255, 13, 77, 129), icon: Icons.person_add_alt_sharp, iconColor: Color.fromARGB(255, 13, 77, 129),),
          ),
        ),
        Sized().sizedHeigth(12),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child:  Text(
            'Client et vendeur',
            style: TextStyle(
                color: Colors.blue,
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ),
        ),
        const DeviderPage(),
        Sized().sizedHeigth(12),
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
                                GFListTile(
                                  avatar:  GFAvatar(
                                    backgroundColor: Color.fromARGB(255, 228, 224, 224),
                                    child: CachedNetworkImage(
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
                                    )),
                                  
                                  titleText: "${users[index]['name']}" ?? "",
                                  subTitleText:"${users[index]['phone']}" ,
                                  onTap: () async{
                                    //await  UserApi(). sellers();
                                     ContactConfig().loadAndgetConversation();
                                      Get.toNamed('/chatScreen', arguments: <String, dynamic>{
                                        'id': users[index]['id'],
                                        'url': processedImageUrl,
                                        'name': users[index]['name'],
                                        'phone': users[index]['phone'],
                                      },
                                    );
                                  },
                                ),
                                const DeviderPage(),
                           
                            ]

                        );
                      }),
            
            
           
        )])
    );
  }
}