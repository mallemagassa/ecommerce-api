
import 'dart:convert';
import 'dart:io';
import 'package:ecommerce/app/models/ProductModel.dart';
import 'package:ecommerce/utils/ApiEndPoints.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get_connect/connect.dart';
import 'package:get_storage/get_storage.dart';

List<ProductModel> parseProduct(String responseBody) {
  //debugPrint( responseBody.replaceAll(RegExp(r'\\'), '').substring(0,1));
  //jsonsDataString.substring(1, jsonsDataString.length - 1)
  //String jsonsDataString = responseBody.replaceAll(RegExp(r'\\'), '');
  debugPrint(responseBody);
  final parsed =
      jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed
      .map<ProductModel>((json) => ProductModel.fromJson(json))
      .toList();
}
class ProductApi extends GetConnect {

  var box = GetStorage();

  // Future<List<ProductModel>> producFiles() async{
  //   CacheManager instance = MyCacheManager.instance;
  //     //await getData();
  //    final res = await instance.getFileFromCache(
  //     'customCacheKey',
  //     ignoreMemCache:true,
  //    );

  //    if (res != null && await res.file.exists()) {
  //         var ress = await res.file.readAsString();
  //         //print(ress);
  //         return compute(parseProduct, jsonEncode(ress).toString());
  //         //Response(body:compute(parseProduct, jsonEncode(res).toString()), statusCode:200);
  //       }
  //     return compute(parseProduct, jsonEncode({}).toString());

  // }

  Future<List<ProductModel>> getData() async{

    // CacheManager instance = MyCacheManager.instance;

    // var file = await instance.getSingleFile(ApiEndPoints.authEndPoints.myProducts,
    //       //key:'customcacheKey' ,
    //       headers: {
    //         //'Content-Type': 'multipart/form-data',
    //         'cache-control': 'private, max-age=2',
    //         "X-Requested-With": "XMLHttpRequest",
    //         HttpHeaders.authorizationHeader: 'Bearer ${box.read('token')}',
    //       },
    //     );
    //     if (file != null && await file.exists()) {
    //       var res = await file.readAsString();
          
    //       return compute(parseProduct, jsonEncode(res).toString());
    //       //Response(body:compute(parseProduct, jsonEncode(res).toString()), statusCode:200);
    //     }


       var file = await get(ApiEndPoints.authEndPoints.myProducts,
          headers: {
            //'Content-Type': 'multipart/form-data',
            //'cache-control': 'private, max-age=0',
            "X-Requested-With": "XMLHttpRequest",
            HttpHeaders.authorizationHeader: 'Bearer ${box.read('token')}',
          },
        );


        if (file.statusCode == 200) {
          //var res = await file.readAsString();
          //print('boody '+file.body);
          return compute(parseProduct, jsonEncode(file.body).toString());
          //Response(body:compute(parseProduct, jsonEncode(res).toString()), statusCode:200);
        }

      return compute(parseProduct, jsonEncode({}).toString());
  }

  Future<List<ProductModel>> getDataProductSeller(int id) async{

    //CacheManager instance = CacheManagerSellerProduct.instance;
    // await instance.getSingleFile(ApiEndPoints.authEndPoints.sellerProduct+id.toString(),
    //       key:'customsellerProduct',
    //       headers: {
    //         //'Content-Type': 'multipart/form-data',
    //         'cache-control': 'private, max-age=0',
    //         "X-Requested-With": "XMLHttpRequest",
    //         HttpHeaders.authorizationHeader: 'Bearer ${box.read('token')}',
    //       },
    //     );

    //  if (file != null && await file.exists()) {
    //       var res = await file.readAsString();
    //       return compute(parseProduct, jsonEncode(res).toString());
    //       //Response(body:compute(parseProduct, jsonEncode(res).toString()), statusCode:200);
    //     }

    var file = await get(ApiEndPoints.authEndPoints.sellerProduct+id.toString(),
          headers: {
            //'Content-Type': 'multipart/form-data',
            //'cache-control': 'private, max-age=0',
            "X-Requested-With": "XMLHttpRequest",
            HttpHeaders.authorizationHeader: 'Bearer ${box.read('token')}',
          },
        );


        if (file.statusCode == 200) {
          //var res = await file.readAsString();
          //print('boody '+file.body);
          return compute(parseProduct, jsonEncode(file.body).toString());
          //Response(body:compute(parseProduct, jsonEncode(res).toString()), statusCode:200);
        }
      return compute(parseProduct, jsonEncode({}).toString());
  }
  Future<int?> disconnect(int id) async{
    var file = await get(ApiEndPoints.authEndPoints.checkUserIsLine+id.toString(),
          headers: {
            "X-Requested-With": "XMLHttpRequest",
            HttpHeaders.authorizationHeader: 'Bearer ${box.read('token')}',
          },
        );


        if (file.statusCode == 200) {
          //var res = await file.readAsString();
          //print('boody '+file.body);
          return file.statusCode;
          //Response(body:compute(parseProduct, jsonEncode(res).toString()), statusCode:200);
        }
      return file.statusCode;
  }

  Future<Map<String, dynamic>> createProduct(String image, String imageName, ProductModel product) async {
    try {

      final form = FormData({
        'image': MultipartFile(File(image), filename: imageName, contentType:'multipart/form-data'),
        'name': product.name,
        'price': product.price,
        'quantity': product.quantity,
        'describes': product.describes,
      });

      Response response = await post(
        'https://ecommerce.doucsoft.com/api/v1/products', // Utilisation de la nouvelle URL
        form,
        headers: {
          "X-Requested-With": "XMLHttpRequest",
          "Authorization": 'Bearer ${box.read('token')}',
        },

      );

      if (response.statusCode == 200) {
        //await getData();
        return response.body;
      } else {
        return response.body;
      }
    } catch (e) {
      return throw Exception(e.toString());
    }
  }


  Future<bool> deleteProduct(int? id) async{
       var file = await delete(ApiEndPoints.authEndPoints.products+id.toString(),
          headers: {
            //'Content-Type': 'multipart/form-data',
            //'cache-control': 'private, max-age=0',
            "X-Requested-With": "XMLHttpRequest",
            HttpHeaders.authorizationHeader: 'Bearer ${box.read('token')}',
          },
        );

        print(file.body);
        if (file.statusCode == 200) {
         // print(file.body);
          //await getData();
          return true;
        }

      return false;
  }

  
  
}

