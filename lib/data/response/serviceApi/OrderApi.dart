
import 'dart:convert';
import 'dart:io';

//import 'package:ecommerce/app/controllers/cache_manager.dart';
import 'package:ecommerce/app/models/OrderModel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:ecommerce/app/models/UserModel.dart';
import 'package:ecommerce/managerCache/CacheOrder.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../utils/ApiEndPoints.dart';

List<UserModel> parseorderModel(String responseBody) {
  //debugPrint( responseBody.replaceAll(RegExp(r'\\'), '').substring(0,1));

  //String jsonsDataString = responseBody.replaceAll(RegExp(r'\\'), '');
  //jsonsDataString.substring(1, jsonsDataString.length - 1)
  debugPrint('orders ::::::::: is $responseBody');
  final parsed =
      jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed
      .map<UserModel>((json) => UserModel.fromJson(json))
      .toList();
}

List<OrderModel> parseOrder(String responseBody) {
  //debugPrint( responseBody.replaceAll(RegExp(r'\\'), '').substring(0,1));

  String jsonsDataString = responseBody.replaceAll(RegExp(r'\\'), '');
  debugPrint('orders Auth is $jsonsDataString');
  final parsed =
      jsonDecode(jsonsDataString.substring(1, jsonsDataString.length - 1)).cast<Map<String, dynamic>>();
  return parsed
      .map<OrderModel>((json) => OrderModel.fromJson(json))
      .toList();
}

class OrderApi extends GetConnect{

  var box = GetStorage();

    // CacheManager instance = CacheOrder.instance;

    // var file = await instance.getSingleFile(ApiEndPoints.authEndPoints.getOrderWithUser,
    //       //key:'cacheOrder' ,
    //       headers: {
    //         //'Content-Type': 'multipart/form-data',
    //         'cache-control': 'private, max-age=10',
    //         "X-Requested-With": "XMLHttpRequest",
    //         HttpHeaders.authorizationHeader: 'Bearer ${box.read('token')}',
    //       },
    //     );

    //     if (file != null && await file.exists()) {
    //       var res = await file.readAsString();
    //       print('response order est $res');
    //       return compute(parseorderModel, jsonEncode(res).toString());
    //       //Response(body:compute(parseorderModel, jsonEncode(res).toString()), statusCode:200);
    //     }
  Future<List<UserModel>> getMyOders() async{
    try {
    var file = await get(
      ApiEndPoints.authEndPoints.getOrderWithUser,
      headers: {
        //"Content-Type":"application/json",
        "X-Requested-With": "XMLHttpRequest",
        HttpHeaders.authorizationHeader: 'Bearer ${box.read('token')}',
      },
    );

    print('Response body type: ${file.body.runtimeType}');
    print('Response body content: ${file.body.toString()}');

    if (file.statusCode == 200) {
      // Vérifiez si la réponse est une chaîne JSON valide
      //var parsedData = parseorderModel(jsonDecode(file.body).toString()); // Décoder la réponse JSON
      return compute(parseorderModel, jsonEncode(file.body).toString());
    } else {
      throw Exception('Failed to load orders');
    }
  } catch (e) {
    print('Error fetching orders: $e');
    return []; // Retourne une liste vide en cas d'erreur
  }
  }

 Future<Map<String, dynamic>> createOrderModel(OrderModel orderModel) async {
  try {
    Map<String, String> headers = {
      "X-Requested-With": "XMLHttpRequest",
      "Authorization": 'Bearer ${box.read('token')}',
    };

    Map<String, dynamic> formData = {
      'priceTotal': orderModel.priceTotal,
      'quantity': orderModel.quantity,
      'product_id': orderModel.productId,
      'imageUrl': orderModel.imageUrl,
      'product_name': orderModel.productName,
    };

    Response response = await post(
      'https://ecommerce.doucsoft.com/api/v1/orders',
      formData,
      headers: headers,
    );

    print('response.body order ${response.body}');

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to create order');
    }
    } catch (e) {
      throw Exception(e.toString());
    }
  }


  Future<List<OrderModel>> getAuthOrders() async{

    CacheManager instance = CacheOrder.instance;

    var file = await instance.getSingleFile(ApiEndPoints.authEndPoints.getOrderAuth,
          //key:'cacheOrder' ,
          headers: {
            //'Content-Type': 'multipart/form-data',
            'cache-control': 'private, max-age=120',
            "X-Requested-With": "XMLHttpRequest",
            HttpHeaders.authorizationHeader: 'Bearer ${box.read('token')}',
          },
        );

        // ignore: unnecessary_null_comparison
        if (file != null && await file.exists()) {
          var res = await file.readAsString();
           //print('response produit est $res');
          return compute(parseOrder, jsonEncode(res).toString());
          //Response(body:compute(parseorderModel, jsonEncode(res).toString()), statusCode:200);
        }
      return compute(parseOrder, jsonEncode({}).toString());
  }
  
  Future<List<OrderModel>> getOrderDetail() async{

    CacheManager instance = CacheOrder.instance;

    var file = await instance.getSingleFile(ApiEndPoints.authEndPoints.getOrderDetail,
          //key:'cacheOrder' ,
          headers: {
            //'Content-Type': 'multipart/form-data',
            'cache-control': 'private, max-age=120',
            "X-Requested-With": "XMLHttpRequest",
            HttpHeaders.authorizationHeader: 'Bearer ${box.read('token')}',
          },
        );

        // ignore: unnecessary_null_comparison
        if (file != null && await file.exists()) {
          var res = await file.readAsString();
           print('response produit est $res');
          return compute(parseOrder, jsonEncode(res).toString());
          //Response(body:compute(parseorderModel, jsonEncode(res).toString()), statusCode:200);
        }
      return compute(parseOrder, jsonEncode({}).toString());
  }
}