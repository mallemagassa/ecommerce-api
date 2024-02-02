import 'package:ecommerce/app/controllers/HomeController.dart';
import 'package:ecommerce/app/models/UserModel.dart';
import 'package:ecommerce/app/view/mainScreen/MessageScreen.dart';
import 'package:ecommerce/app/view/mainScreen/OdersScreen.dart';
import 'package:ecommerce/app/view/mainScreen/PurchasesScreen.dart';
import 'package:ecommerce/app/view/mainScreen/UserCompteScreen.dart';
import 'package:ecommerce/app/view/secondaryScreen/SearchPage.dart';
import 'package:ecommerce/contactConfig/ContactConfig.dart';
import 'package:ecommerce/data/response/serviceApi/ProductApi.dart';
import 'package:ecommerce/utils/Devider.dart';
import 'package:ecommerce/utils/Logo.dart';
import 'package:ecommerce/utils/NamePage.dart';
import 'package:ecommerce/utils/PageTitle.dart';
import 'package:ecommerce/utils/SizeHeigth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final box = GetStorage();
  final HomeController homeController = Get.put(HomeController());

 @override
  void initState() {
    super.initState();
    if (box.read('users') == null) {
      Get.snackbar(
      'Succès', 
      'Bienvenue dans votre application de commerce électronique. Vos données sont en cours de chargement...',
      backgroundColor:Colors.greenAccent,
      duration: const Duration(seconds: 6)
      );
      _loadData();
    }
  }

  Future<void> _loadData() async {
    await ContactConfig().loadAndStoreContacts();
    await ContactConfig().loadAndgetConversation();
    await ContactConfig().loadAndgetMyOders();
    await ContactConfig().refreshContactsLocally();
    await ProductApi().getData();
    // Mettre à jour l'état pour reconstruire le widget si nécessaire
    if (mounted) {
      setState(() {
        // Mettre à jour l'état si nécessaire
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return
        Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              bottom: PreferredSize(preferredSize: homeController.currentPage.value == 2 ?Size.fromHeight(150) :Size.fromHeight(0), child: 
              Obx(() {
                return Column(children: [
                if(homeController.currentPage.value == 2) ...[
                Sized().sizedHeigth(24),
                const NamePage(title: "Commandes"),
                Sized().sizedHeigth(24),
                const PageTitel(title1: 'Commandes avec des contacts'),
                //const DeviderPage(),
                ]
              ],);
              })
              ),
              elevation: 0,
              title: const Logo(),
              actions: [
                Obx((){
                  return Row(
                    children:[
                      if(homeController.currentPage.value == 0) ...[
                        IconButton(
                            onPressed: () {
                              //Get.to(const SearchPage(), fullscreenDialog: true, transition: Transition.downToUp, duration: Duration(milliseconds: 600));
                            },
                            icon: const Icon(Icons.camera_alt_rounded), color: Colors.blue,),

                      ] else if(homeController.currentPage.value == 1) ...[
                        IconButton(
                            onPressed: () {
                              Get.to(const SearchPage(), fullscreenDialog: true, transition: Transition.downToUp, duration: Duration(milliseconds: 600));
                            },
                            icon: const Icon(Icons.search), color: Colors.blue,),
                      
                      ]else if(homeController.currentPage.value == 2) ...[
                        IconButton(
                            onPressed: () {
                              Get.to(const SearchPage());
                            },
                            icon: const Icon(Icons.search), color: Colors.blue,),
                      
                      ]else
                        IconButton(
                            onPressed: () async {
                              await Get.toNamed('/addContactScreen');
                              setState(() {});
                            
                              //Get.to(const AddContactScreen(), fullscreenDialog: true, transition: Transition.downToUp, duration: Duration(milliseconds: 600));
                            },
                            icon: const Icon(Icons.edit_document), color: Colors.blue,),
                      
                    ]


                  );
                })
              
              ],
            ),
            body: PageView(
              onPageChanged: homeController.animateToTab,
              controller: homeController.pageController,
              children:  [
                UserCompteScreen(),
                PurchasesScreen(),
                OdersScreen(),
                MessageScreen()
              ],
              //physics: const BouncingScrollPhysics(),
            ),
            bottomNavigationBar: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                    top: BorderSide(
                        color: Color.fromARGB(255, 223, 221, 221), width: 1)),
              ),
              child: BottomAppBar(
                //notchMargin: 10,
                elevation: 0,
                child: Container(
                  color: Colors.white,
                  //padding: EdgeInsets.symmetric(horizontal: 35, vertical: 15),
                  child: Obx(
                    () => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _bottomAppBarItem(context,
                            icon: Icons.person, page: 0, label: "Compte"),
                        _bottomAppBarItem(context,
                            icon: Icons.shopping_cart, page: 1, label: "Achats"),
                        _bottomAppBarItem(context,
                            icon: Icons.shopping_cart_checkout_sharp,
                            page: 2,
                            label: "Commandes"),
                        _bottomAppBarItem(context,
                            icon: Icons.chat, page: 3, label: "Messagerie"),
                      ],
                    ),
                  ),
                ),
              ),
            ));
    });
    
  }

  Widget _bottomAppBarItem(BuildContext context,
      {required IconData icon, required page, required label}) {
    return ZoomTapAnimation(
      onTap: () => homeController.goToTab(page),
      child: Container(
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              child: Icon(
                icon,
                color: homeController.currentPage.value == page
                    ? Colors.blue
                    : Color.fromARGB(255, 161, 160, 160),
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: homeController.currentPage.value == page
                    ? Colors.blue
                    : Color.fromARGB(255, 99, 95, 95),
                fontWeight: homeController.currentPage.value == page
                    ? FontWeight.bold
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
