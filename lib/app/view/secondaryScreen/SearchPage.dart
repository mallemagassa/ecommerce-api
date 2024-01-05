import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce/utils/ApiEndPoints.dart';
import 'package:ecommerce/utils/InputWidget.dart';
import 'package:ecommerce/utils/SizeHeigth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final box = GetStorage();
  List<Map<String, dynamic>> users = [];
  List<Map<String, dynamic>> filteredUsers = [];

  TextEditingController controller = TextEditingController();

  @override
void initState() {
  super.initState();
  var storedUsers = GetStorage().read('users');
  if (storedUsers != null && storedUsers is List<dynamic>) {
    users = List<Map<String, dynamic>>.from(storedUsers.whereType<Map<String, dynamic>>());
    filteredUsers = List<Map<String, dynamic>>.from(users); // Initialise la liste filtrée avec la liste complète au début
  }
}
  // List<Map<String, dynamic>> userList = [
  //   {"id": 1, "name": "Malle Mgs", "phone": "+22392683269", "isSeller": true, "image": "public/images/profils/EFDO6P6fVNxhMRhBShFM2GaagEJTsKnVj59nSVc6.jpg"},
  //   {"id": 2, "name": "Moussa DG", "phone": "+22376705070", "isSeller": false, "image": "public/images/profils/VAOwhPxOioLjXJZnydHsxPvt78EKHxsPuRp29yo7.png"},
  //   {"id": 3, "name": "PAPA FOUNÉ", "phone": "+22376477745", "isSeller": false, "image": null}
  // ];

  @override
  Widget build(BuildContext context) {
      // if (storedUsers != null && storedUsers is List<dynamic>) {
      //   users = List<Map<String, dynamic>>.from(storedUsers.whereType<Map<String, dynamic>>());
      // }
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: InputWidget(
                      //textAlign: TextAlign.center,
                      textAlignVertical: TextAlignVertical.center,
                      name: "name",
                      controller: controller,
                      onChanged: (value) {
                       setState(() {
                          filteredUsers = users.where((user) {
                            String name = user['name'].toString().toLowerCase();
                            String searchTerm = value!.toLowerCase();
                            return name.contains(searchTerm);
                          }).toList();
                        });
                  },
                  decoration: InputDecoration(
                      
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                      filled: true,
                      
                      fillColor: Colors.grey.shade300,
                      alignLabelWithHint:false,
                      suffix: IconButton(
                      onPressed: (){
                        controller.clear();
                      }, 
                      icon: const Icon(
                        Icons.close
                      ),
                      ),
                      hintText:"Barre de Recherche",
                      
                      hintStyle: const TextStyle(
                        fontSize: 16,
                        height: 4,
                      ),
                      prefixStyle: const TextStyle(
                        //fontSize: 16,
                        height: 2,
                      ),
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(30))),
                )),
                //Sized().sizedWith(10),
                    
              ],
            ),

            Sized().sizedHeigth(20),

            Expanded(
              child: ListView.builder(
                itemCount: filteredUsers.length,
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
                          
                          titleText: "${users[index]['name']}" ?? "", //contacts[index].displayName,
                          subTitleText:"${users[index]['phone']}" ,  //contains(contacts[index].phones?.first.value ?? "") ,
                          onTap: () async{
                            //await  UserApi(). sellers();
                              Get.toNamed('userProduct', arguments: <String, dynamic>{
                                'id': users[index]['id'],
                                'url': processedImageUrl,
                                'name': users[index]['name'],
                                'phone': users[index]['phone'],
                              },
                            );
                          },
                        ),
                      ]
                    ],
                  );
                },
              ),
            ),

          //   const Padding(
          //     padding: EdgeInsets.only(left: 5),
          //     child: Text(
          //       "Recherche Récent",
          //       style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          //     ),
              
          //   ), 
          //  const ListTile(
          //     title: Text("Kizza Mgs"),
          //     leading: Icon(Icons.search),
          //     trailing: Icon(Icons.close),
          //   )
          ],
        ),
      )),
    );
  }

  // void searchUser(String query){
    
  //   List<String> userNam = [];
  //   final suggestion = allUsers.where((element) {
  //     userNam.add(element['name'].toLowerCase());
  //     final inputQuery = query.toLowerCase();

  //     return userNam.contains(inputQuery);
  //   }).toList();

  //   setState(() {
  //    //userNam = suggestion;
  //   });
  // }
}
