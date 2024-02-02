//import 'package:ecommerce/app/view/HomeScreen.dart';
import 'package:ecommerce/NotificationSetup.dart';
import 'package:ecommerce/app/controllers/RegisterController.dart';
import 'package:ecommerce/contactConfig/ContactConfig.dart';
import 'package:ecommerce/firebase_options.dart';
import 'package:ecommerce/resources/routes/route.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  //await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print(message.notification!.body);
}
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  Get.testMode = true;
  await GetStorage.init();
  ///await initOneSignal();
  RegisterController registerController = Get.put(RegisterController());
  //GetStorage().remove('users');
  if (registerController.isLogged.value && GetStorage().read('token').isNotEmpty) {
    
    //print('id user is : ${GetStorage().read('info_user')['id'].toString()}');
    await ContactConfig().loadAndStoreContacts();
    await ContactConfig().loadAndgetConversation();
    await ContactConfig().loadAndgetMyOders();
    await ContactConfig().loadAndgetMyOdersReceirve();
    await ContactConfig().refreshContactsLocally();
    await NotificationSetup().initNotification();
    //await ProductApi().getData();
    //await ChatMessag44xdesStorage(). getMessageFromApi();
    //await ContactConfig().refreshContactsLocally();
  }

 // print('ordersReceirve :::::: ${GetStorage().read('ordersReceirve')}');
  //GetStorage().remove('contacts');
  runApp(MyApp());
}

 
// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  MyApp({super.key});

  RegisterController registerController = Get.put(RegisterController());

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ecommerce',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        canvasColor:Colors.white
      ),
      initialRoute: '/',
      //home:registerController.isLogged.value ? HomeScreen()  : const WelcomeScreen(), //SplashView()
      getPages: AppRoutes.appRoutes(),
    );
  }
}