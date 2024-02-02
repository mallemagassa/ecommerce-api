import 'package:ecommerce/app/view/AuthScreen/ConditionScreen.dart';
import 'package:ecommerce/app/view/AuthScreen/LoginOtpScreen.dart';
import 'package:ecommerce/app/view/addContact/AddContactScreen.dart';
import 'package:ecommerce/app/view/secondaryScreen/Message/ChatScreen.dart';
import 'package:ecommerce/app/view/secondaryScreen/Order/CartScreen.dart';
import 'package:ecommerce/app/view/secondaryScreen/Order/DetailCartOwnerScreen.dart';
import 'package:ecommerce/app/view/secondaryScreen/Order/DetailCartReceirveScreen.dart';
import 'package:ecommerce/app/view/secondaryScreen/Order/DetailCartScreen.dart';
import 'package:ecommerce/app/view/secondaryScreen/Purchases/DetailsProduct.dart';
import 'package:ecommerce/app/view/secondaryScreen/Purchases/DetailsProductImage.dart';
import 'package:ecommerce/app/view/secondaryScreen/Purchases/UserProduct.dart';
import 'package:ecommerce/app/view/secondaryScreen/SearchPage.dart';
import 'package:ecommerce/app/view/secondaryScreen/UserCompte/AboutScreen.dart';
import 'package:ecommerce/app/view/secondaryScreen/UserCompte/AddProductScreen.dart';
import 'package:ecommerce/app/view/secondaryScreen/UserCompte/DetailProfilUserScree.dart';
import 'package:ecommerce/app/view/secondaryScreen/UserCompte/ProdutsScreen.dart';
import 'package:ecommerce/app/view/secondaryScreen/UserCompte/ProfilUserScreen.dart';
import 'package:ecommerce/app/view/welcomeScreen/WelcomeScreen.dart';
import 'package:ecommerce/app/view/AuthScreen/ImageProfilScreen.dart';
import 'package:ecommerce/app/view/AuthScreen/OtpScreen.dart';
import 'package:ecommerce/app/view/AuthScreen/RegisterScreen.dart';
import 'package:ecommerce/app/view/HomeScreen.dart';
import 'package:ecommerce/app/view/AuthScreen/loginScreen.dart';
import 'package:ecommerce/resources/routes/middleware/FirstMiddleware.dart';
import 'package:ecommerce/resources/routes/nameRoute.dart';
import 'package:get/get.dart';

class AppRoutes {
  static appRoutes() => [
    GetPage(
      name: NameRoute.homeScreen, 
      page: () =>  HomeScreen(), 
      transition: Transition.rightToLeftWithFade,
      transitionDuration:const Duration(milliseconds: 250),
      middlewares: [FirstMiddleware()]
    ),
    GetPage(
      name: NameRoute.registerScreen, 
      page: () => RegisterScreen(), 
      transition: Transition.rightToLeftWithFade,
      transitionDuration:const Duration(milliseconds: 250)
    ),
    GetPage(
      name: NameRoute.loginScreen, 
      page: () =>  LoginScreen(), 
      transition: Transition.rightToLeftWithFade,
      transitionDuration:const Duration(milliseconds: 250)
    ),
    GetPage(
      name: NameRoute.loginOtpScreen, 
      page: () =>  LoginOtpScreen(), 
      transition: Transition.rightToLeftWithFade,
      transitionDuration:const Duration(milliseconds: 250)
    ),
    GetPage(
      name: NameRoute.otpScreen, 
      page: () =>  OtpScreen(), 
      transition: Transition.rightToLeftWithFade,
      transitionDuration:const Duration(milliseconds: 250)
    ),
    GetPage(
      name: NameRoute.imageProfilScreen, 
      page: () =>  ImageProfilScreen(), 
      transition: Transition.rightToLeftWithFade,
      transitionDuration:const Duration(milliseconds: 250)
    ),
    GetPage(
      name: NameRoute.conditionScreen, 
      page: () => const ConditionScreen(), 
      transition: Transition.rightToLeftWithFade,
      transitionDuration:const Duration(milliseconds: 250)
    ),
    GetPage(
      name: NameRoute.loginScreen, 
      page: () =>  LoginScreen(), 
      transition: Transition.rightToLeftWithFade,
      transitionDuration:const Duration(milliseconds: 250)
    ),
    GetPage(
      name: NameRoute.welcome, 
      page: () => const WelcomeScreen(), 
      transition: Transition.rightToLeftWithFade,
      transitionDuration:const Duration(milliseconds: 250),
      
    ),
    GetPage(
      name: NameRoute.profil, 
      page: () => ProfilUserScreen(), 
      transition: Transition.rightToLeftWithFade,
      transitionDuration:const Duration(milliseconds: 250)
    ),
    GetPage(
      name: NameRoute.about, 
      page: () => const AboutScreen(), 
      transition: Transition.rightToLeftWithFade,
      transitionDuration:const Duration(milliseconds: 250)
    ),
    GetPage(
      name: NameRoute.product, 
      page: () => ProdutsScreen(), 
      transition: Transition.rightToLeftWithFade,
      transitionDuration:const Duration(milliseconds: 250)
    ),
    GetPage(
      name: NameRoute.addProduct, 
      page: () =>  AddProductScreen(), 
      transition: Transition.rightToLeftWithFade,
      transitionDuration:const Duration(milliseconds: 250)
    ),
    GetPage(
      name: NameRoute.userProduct, 
      page: () => UserProduct(), 
      transition: Transition.rightToLeftWithFade,
      transitionDuration:const Duration(milliseconds: 250)
    ),
    GetPage(
      name: NameRoute.detailProduct, 
      page: () =>  DetailsProduct(), 
      transition: Transition.rightToLeftWithFade,
      transitionDuration:const Duration(milliseconds: 250)
    ),
    GetPage(
      name: NameRoute.cartScreen, 
      page: () => CartScreen(), 
      transition: Transition.rightToLeftWithFade,
      transitionDuration:const Duration(milliseconds: 250)
    ),
    GetPage(
      name: NameRoute.chatScreen, 
      page: () => ChatScreen(), 
      transition: Transition.rightToLeftWithFade,
      transitionDuration:const Duration(milliseconds: 250)
    ),
    GetPage(
      name: NameRoute.detailsProductImage, 
      page: () =>  DetailsProductImage(), 
      transition: Transition.rightToLeftWithFade,
      transitionDuration:const Duration(milliseconds: 250)
    ),
    GetPage(
      name: NameRoute.detailProfilUserScreen, 
      page: () =>  DetailProfilUserScreen(), 
      transition: Transition.rightToLeftWithFade,
      transitionDuration:const Duration(milliseconds: 250)
    ),
    GetPage(
      name: NameRoute.detailCartScreen, 
      page: () =>  DetailCartScreen(), 
      transition: Transition.rightToLeftWithFade,
      transitionDuration:const Duration(milliseconds: 250)
    ),
    GetPage(
      name: NameRoute.detailCartReceirveScreen, 
      page: () =>  DetailCartReceirveScreen(), 
      transition: Transition.rightToLeftWithFade,
      transitionDuration:const Duration(milliseconds: 250)
    ),
    GetPage(
      name: NameRoute.searchPage, 
      page: () =>  const SearchPage(), 
      transition: Transition.rightToLeftWithFade,
      transitionDuration:const Duration(milliseconds: 250)
    ),
    GetPage(
      name: NameRoute.addContactScreen, 
      page: () =>  const AddContactScreen(), 
      transition: Transition.rightToLeftWithFade,
      transitionDuration:const Duration(milliseconds: 250)
    ),
    GetPage(
      name: NameRoute.detailCartOwnerScreen, 
      page: () =>  DetailCartOwnerScreen(), 
      transition: Transition.rightToLeftWithFade,
      transitionDuration:const Duration(milliseconds: 250)
    ),
  ];
}
