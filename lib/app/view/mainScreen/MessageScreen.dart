import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce/contactConfig/ContactConfig.dart';
import 'package:ecommerce/data/response/serviceApi/ConversationApi.dart';
import 'package:ecommerce/utils/ApiEndPoints.dart';
import 'package:ecommerce/utils/Devider.dart';
import 'package:ecommerce/utils/NamePage.dart';
import 'package:ecommerce/utils/PageTitle.dart';
import 'package:ecommerce/utils/SizeHeigth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';

class MessageScreen extends StatefulWidget {
  MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
    // setState(() {
      WidgetsBinding.instance?.addPostFrameCallback((_) {
      setState(() {
        ContactConfig().loadAndgetConversation();
      });
    });
  }

  final conversations = GetStorage().read('conversations') ?? [];
 
  Future<void> deleteConversations() async {
    for (var i = 0; i < selectedIndexes.length; i++) {
      selectedIndexes.remove(i);
    }

    for (var id in convId) {
      await ConversationApi().deleteConversation(id);
      conversations.removeWhere((element) => element['conversation_id'] == id);;
    }
    convId.clear();    
    setState(() {
      isVisible = false;
      Get.back();
    });

    await Future.delayed(Duration(milliseconds: 500));

    await reloadInitialData(); // Recharger les données initiales
  }

  Future<void> reloadInitialData() async {
    await ContactConfig().loadAndgetConversation();
    setState(() {});
  }

  void showDeleteConfirmationDialog() {
    Get.defaultDialog(
      title: 'Voulez-vous vraiment supprimer ?',
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextButton(
            onPressed: () async {
              await deleteConversations(); 
              // Suppression des conversations
            },
            child: const Text('Oui', style: TextStyle(fontSize: 20)),
          ),
          TextButton(
            onPressed: () {
              Get.back(); // Fermer le dialogue sans supprimer
            },
            child: const Text('Non', style: TextStyle(fontSize: 20)),
          ),
        ],
      ),
    );
  }



  Set<int> selectedIndexes = Set<int>();
  List<int> convId = [];
  bool isVisible = false;
  @override
  Widget build(BuildContext context) {
    //GetStorage().write('conversations', conversations);
    print('$conversations');
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
      children: [
        Sized().sizedHeigth(24),
         Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            NamePage(title: "Echanges"),
            if(isVisible)...[
              IconButton(
                onPressed: () {
                  showDeleteConfirmationDialog();
                },
                icon: const Icon(Icons.delete), color: Colors.redAccent,)
            ]
          ],
        ),
        Sized().sizedHeigth(24),
        const PageTitel(
            title1: 'Discussions avec vos contacts', title2: 'Avec'),
        const DeviderPage(),
        Expanded(
            child:  ListView.builder(

                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: (conversations?.length > 0) ? conversations?.length : 0,
                      itemBuilder: (context, index) {
                        String? processedImageUrl;
                        if (conversations[index]['image'] != null && conversations[index]['image'].isNotEmpty) {
                          String? imageUrl = conversations[index]['image'];
                          processedImageUrl = imageUrl != null && imageUrl.isNotEmpty && imageUrl.length > 22
                              ? "${ApiEndPoints.authEndPoints.profilUser}${imageUrl.substring(22)}"
                              : "${ApiEndPoints.authEndPoints.profilUser}defaultAvatar.jpg";
                          print(processedImageUrl);
                        }
                        
                        return Column(
                          children: [
                                GFListTile(
                                  shadow: BoxShadow(),
                                  avatar:  GFAvatar(
                                    backgroundColor: Color.fromARGB(255, 228, 224, 224),
                                    child: SizedBox(
                                      width: 160,
                                      height: 160,
                                      child:
                                      CachedNetworkImage(
                                          imageUrl: processedImageUrl ?? "",
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
                                  titleText: "${conversations[index]['name']}" ?? "", //contacts[index].displayName,
                                  subTitleText:"${conversations[index]['phone']}" ,  //contains(contacts[index].phones?.first.value ?? "") ,
                                  color: selectedIndexes.contains(index) ?  Colors.grey : Colors.white,
                                  onLongPress: (){
                                    selectedIndexes.add(index);
                                    convId.add(conversations[index]['conversation_id']);
                                    setState(() {
                                      isVisible = !isVisible;
                                      });

                                     // print(selectedIndexes.length);
                                  },
                                  onTap: () {
                                    //await  UserApi(). sellers();
                                    if (!isVisible) {
                                      Get.toNamed('/chatScreen', arguments: <String, dynamic>{
                                        'id': conversations[index]['id'],
                                        'receiver_id': conversations[index]['receiver_id'],
                                        'url': processedImageUrl,
                                        'conversation_id': conversations[index]['conversation_id'],
                                        'phone': conversations[index]['phone'],
                                        'name': conversations[index]['name'],
                                        'isSeller': conversations[index]['isSeller'],
                                        'nameCom': conversations[index]['nameCom'],
                                        'status': conversations[index]['status'],
                                        'address': conversations[index]['address'],
                                      },
                                    );
                                      
                                    }else{
                                      setState(() {
                                        if (selectedIndexes.contains(index)) {
                                          selectedIndexes.remove(index); // Désélectionner
                                          convId.remove(conversations[index]['conversation_id']);
                                        } else {
                                          selectedIndexes.add(index); // Sélectionner conversations[index]['conversation_id']
                                          convId.add(conversations[index]['conversation_id']);
                                        }
                                      });
                                    }
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
