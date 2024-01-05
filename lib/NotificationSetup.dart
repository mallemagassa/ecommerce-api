 import 'package:ecommerce/data/response/serviceApi/UserApi.dart';
import 'package:ecommerce/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

class NotificationSetup{
 
 final messaging = FirebaseMessaging.instance;

 Future<void> initNotification() async{
   await messaging.requestPermission();

   final fCMToken = await messaging.getToken();

   print('Token is ${fCMToken.toString()}');
  
   UserApi().setToken(fCMToken ?? fCMToken!.toString());
   await initPushNotification();
   await initNotificationLocal();
 }


 void showFlutterNotification(RemoteMessage? message) {
  if (message == null) return;

  final Map<String, dynamic> messageData = message.data;

  print('444444444444444444444444444 message ${message.data}');

  if (messageData != null && messageData.isNotEmpty) {
    String? receiverId = messageData['receiver_id'] as String?;
    String? conversationId = messageData['conversation_id'] as String?;

    if (receiverId != null && conversationId != null) {
      Get.toNamed('/chatScreen', arguments: {
        'id': int.parse(receiverId),
        'conversation_id': int.parse(conversationId),
      });
    }
    }
  }

  Future<void> initNotificationLocal() async{
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'doucChannelId', // ID unique du canal personnalisé
      'Default Channel', // Nom du canal
      //'Description of Custom Channel', // Description du canal
      importance: Importance.max, // Niveau d'importance
    );

   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  }



 Future<void> initPushNotification() async{
  FirebaseMessaging.instance.getInitialMessage().then(showFlutterNotification);
  FirebaseMessaging.onMessageOpenedApp.listen(showFlutterNotification);
  FirebaseMessaging.onMessage.listen((event) {
    print('event.data ${event.notification?.body}');
  });
 }

}