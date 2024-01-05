import 'package:ecommerce/app/controllers/RegisterController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class FirstMiddleware  extends GetMiddleware{

  @override
  int? priority = 2;

  //FirstMiddleware({required this.priority});

  var box = GetStorage();


  @override
  RouteSettings? redirect(String? route) {
    RegisterController registerController = Get.find();
    if (registerController.isLogged.value == false) {
      return const RouteSettings(name: '/welcome');
    }
  }
  
}