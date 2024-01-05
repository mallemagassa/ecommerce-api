
import 'dart:convert';
import 'dart:io';

//import 'package:ecommerce/app/controllers/cache_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:ecommerce/app/models/UserModel.dart';
import 'package:ecommerce/managerCache/CacheConversation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../utils/ApiEndPoints.dart';

List<UserModel> parseProduct(String responseBody) {
  //debugPrint( responseBody.replaceAll(RegExp(r'\\'), '').substring(0,1));

  String jsonsDataString = responseBody.replaceAll(RegExp(r'\\'), '');
  debugPrint(jsonsDataString);
  final parsed =
      jsonDecode(jsonsDataString.substring(1, jsonsDataString.length - 1)).cast<Map<String, dynamic>>();
  return parsed
      .map<UserModel>((json) => UserModel.fromJson(json))
      .toList();
}

class ConversationApi extends GetConnect{

  var box = GetStorage();

  Future<List<UserModel>> getConversation() async{

    CacheManager instance = CacheConversation.instance;

    var file = await instance.getSingleFile(ApiEndPoints.authEndPoints.conversations,
          //key:'cacheConversation' ,
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
          return compute(parseProduct, jsonEncode(res).toString());
          //Response(body:compute(parseProduct, jsonEncode(res).toString()), statusCode:200);
        }
      return compute(parseProduct, jsonEncode({}).toString());
  }

   Future<bool> deleteConversation(int id) async{
       var file = await delete(ApiEndPoints.authEndPoints.conversations+id.toString(),
          headers: {
            //'Content-Type': 'multipart/form-data',
            //'cache-control': 'private, max-age=0',
            "X-Requested-With": "XMLHttpRequest",
            HttpHeaders.authorizationHeader: 'Bearer ${box.read('token')}',
          },
        );

        print('file.body ${file.body}');
        if (file.statusCode == 200) {
         print(file.body);
          //await getData();
          return true;
        }

      return false;
  }
}