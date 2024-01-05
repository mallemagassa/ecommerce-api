
import 'dart:convert';
import 'dart:io';

import 'package:ecommerce/app/models/ProfilModel.dart';
import 'package:ecommerce/managerCache/CacheProfil.dart';
import 'package:ecommerce/utils/ApiEndPoints.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get_connect/connect.dart';
import 'package:get_storage/get_storage.dart';


List<ProfilModel> parseProfil(String responseBody) {
  //debugPrint( responseBody.replaceAll(RegExp(r'\\'), '').substring(0,1));

  String jsonsDataString = responseBody.replaceAll(RegExp(r'\\'), '');
  //debugPrint(jsonsDataString);
  final parsed =
      jsonDecode(jsonsDataString.substring(1, jsonsDataString.length - 1)).cast<Map<String, dynamic>>();
  return parsed
      .map<ProfilModel>((json) => ProfilModel.fromJson(json))
      .toList();
}

class ImageProfilApi extends GetConnect {

  var box = GetStorage();

  Future<List<ProfilModel>> profilFiles() async{
    CacheManager instance = CacheProfil.instance;
      //await getDataProfil();
     final res = await instance.getFileFromCache(
      'cacheprofil',
      ignoreMemCache:true,
     );

     if (res != null && await res.file.exists()) {
          //final Directory temp = await getTemporaryDirectory();
          // final File imageFile = File(res.file.path);
          // print(imageFile);
          var ress = await res.file.readAsString();
          //print(ress);

          return compute(parseProfil, jsonEncode(ress).toString());
          //Response(body:compute(parseProduct, jsonEncode(res).toString()), statusCode:200);
        }
      return compute(parseProfil, jsonEncode({}).toString());

  }

  Future<List<ProfilModel>> getDataProfil() async{

    CacheManager instance = CacheProfil.instance;

    var file = await instance.getSingleFile(
      ApiEndPoints.authEndPoints.profils,
          //key:'cacheprofi' ,
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
          //print(res);
          return compute(parseProfil, jsonEncode(res).toString());
          //Response(body:compute(parseProduct, jsonEncode(res).toString()), statusCode:200);
        }
      return compute(parseProfil, jsonEncode({}).toString());
  }


  Future<Response<dynamic>> addImage(String image, String imageName, data) async {
    try {
      Map<String, String> headers = {
        "X-Requested-With": "XMLHttpRequest",
        "Authorization": 'Bearer ${box.read('token')}',
      };

      final form = FormData({
        'image': MultipartFile(File(image), filename: imageName, contentType: 'multipart/form-data'),
        // Ajoutez d'autres données si nécessaire
      });

      Response response = await post(
        'https://ecommerce.doucsoft.com/api/v1/profils', // Utilisation de la nouvelle URL
        form,
        headers: headers,
      );

      print(response.body);

      if (response.statusCode == 200) {
        return response.body;
      } else {
        return response.body;
      }
    } catch (e) {
      return Response(statusCode: 1, statusText: e.toString());
    }
  }



  // Future<Response<dynamic>> addImage(String image, String imageName, data) async {
  //    try {
  //      Map<String, String> headers = {
  //         //'Content-Type': 'multipart/form-data',
  //         "X-Requested-With": "XMLHttpRequest",
  //         "Authorization": 'Bearer ${box.read('token')}',
  //       };

  //       final form = FormData({
  //         'image': MultipartFile(File(image), filename: imageName, contentType:'multipart/form-data'),
  //         // 'firstname':data['firstname'] ? data['firstname'] : null ,
  //         // 'lastname':data['lastname'] ? data['lastname'] : null,
  //         //'otherFile': MultipartFile(image, filename: 'cover.png'),
  //       });
    
  //       Response response = await post(
  //         ApiEndPoints.authEndPoints.profils, 
  //         form,
  //         headers: headers,
  
  //       );

  //       print(response.body);
    
  //       if (response.statusCode == 200) {
  //         return response.body;
  //       }else{
  //         return response.body;
  //       }
  //     }catch (e) {
  //       return Response(statusCode: 1, statusText: e.toString());
  //     }

  // }

  Future<Response<dynamic>> updateImage(String image, String imageName, int id) async {
     try {
       Map<String, String> headers = {
          //'Content-Type': 'multipart/form-data',
          "X-Requested-With": "XMLHttpRequest",
          "Authorization": 'Bearer ${box.read('token')}',
        };

        final form = FormData({
          'image': MultipartFile(File(image), filename: imageName, contentType:'multipart/form-data'),
          // 'firstname':data['firstname'] ? data['firstname'] : null ,
          // 'lastname':data['lastname'] ? data['lastname'] : null,
          //'otherFile': MultipartFile(image, filename: 'cover.png'),
        });
    
        Response response = await post(
          ApiEndPoints.authEndPoints.profils+'${id}?_method=PUT', 
          form,
          headers: headers,
  
        );

        print(ApiEndPoints.authEndPoints.profils+'${id}?_method=PUT');

        print(response.body);
    
        if (response.statusCode == 200) {
          return response.body;
        }else{
          return response.body;
        }
      }catch (e) {
        return Response(statusCode: 1, statusText: e.toString());
      }

  }

  Future<Map<String, dynamic>> verifyImge() async {

     try {
       Map<String, String> headers = {
          //'Content-Type': 'multipart/form-data',
          "X-Requested-With": "XMLHttpRequest",
          "Authorization": 'Bearer ${box.read('token')}',
        };
    
        Response response = await get(
          ApiEndPoints.authEndPoints.verifyImge, 
          headers: headers,
        );

        print(response.body);

        Map<String, dynamic> map  = {
          'status': response.body['status'],
          'id': response.body['id'],
        };
    
        if (response.statusCode == 200) {
          return map;
        }else{
          return map;
        }
      }catch (e) {
        return {
          'error': e.toString(),
        };//Response(statusCode: 1, statusText: e.toString());
      }

  }

}

