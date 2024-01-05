import 'package:ecommerce/app/controllers/RegisterController.dart';
import 'package:ecommerce/data/response/serviceApi/UserApi.dart';
import 'package:ecommerce/utils/Devider.dart';
import 'package:ecommerce/utils/ListTile.dart';
import 'package:ecommerce/utils/PageTitle.dart';
import 'package:ecommerce/utils/SizeHeigth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

// ignore: must_be_immutable
class UserCompteScreen extends StatelessWidget {
  UserCompteScreen({super.key});

  RegisterController registerController = Get.find();
  var box = GetStorage();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
      //mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Sized().sizedHeigth(24),
        Padding(
          padding: const EdgeInsets.only(left: 6, right: 6),
          child: Container(
            child: Row(
              children: [
                
                TextButton.icon(
                  onPressed: () async{
                    Get.defaultDialog(
                          title: 'Voulez-vous vraiment vous déconnecter ?',
                          content: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              TextButton(
                                  onPressed: () async{
                                    var res = await UserApi().logout();
                                    if(res['status']){
                                      Get.snackbar(
                                        'Succés', 
                                        res['message'],
                                        backgroundColor: Colors.greenAccent
                                      );
                                      registerController.loading.value = false;
                                    }
                                    await registerController.disconnect();
                                    GetStorage().erase();
                                    box.remove('token');
                                    Get.back();
                                  },
                                  child: const Text('Oui',
                                  style: TextStyle(fontSize: 20),
                                  )),
                              TextButton(
                                  onPressed: () {
                                    //productController.getImageGallery();
                                    Get.back();
                                  },
                                  child: const Text('Non',
                                  style: TextStyle(fontSize: 20),
                                  )),
                            ],
                          ),
                        );
                    
                  },
                  icon: const Icon(
                    Icons.logout,
                    size: 24.0,
                    color: Colors.blue,
                  ),
                  label: const Text(
                    'Se déconnecter',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w600
                    ),
                  ), // <-- Text
                ),
              ],
            ),
          ),
        ),
        Sized().sizedHeigth(24),
        const PageTitel(
            title1:
                'Vous pouvez mettre vos articles en ligne en créant un compte commercial',
            title2: 'Compte'),
        const DeviderPage(),
        ListTiles(
          icon: Icons.person,
          title: 'Votre Profil',
          onTap: () {
            Get.toNamed("/profil");
          },
        ),
       if(box.read('info_user')['isSeller'])...[
        const DeviderPage(),
        ListTiles(
          icon: Icons.shopping_bag_sharp,
          title: 'Mettre des produits en ligne ',
          onTap: (){
            // var res = await ProductApi().getData();
            // print(res);
            Get.toNamed("/product");
          },
        ),
       ],
        const DeviderPage(),
        ListTiles(
          icon: Icons.info,
          title: 'A Propos',
          onTap: () {
            Get.toNamed("/about");
          },
        ),
        const DeviderPage(),
      ],
    ));
  }
}

ListTile listitle(IconData icon, String title, Function()? onTap) {
  return ListTile(
    leading: Icon(
      icon,
      size: 32,
    ),
    title: Text(title),
    onTap: onTap,
  );
}
