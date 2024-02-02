
import 'dart:convert';
import 'dart:io';

import 'package:ecommerce/app/models/UserModel.dart';
import 'package:ecommerce/managerCache/CacheManager.dart';
import 'package:ecommerce/managerCache/CacheSeller.dart';
import 'package:ecommerce/utils/ApiEndPoints.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get_connect/connect.dart';
import 'package:get_storage/get_storage.dart';

  // List<UserModel> parseUserAuth(String responseBody) {
  //   //debugPrint(responseBody);
  //   final parsed =
  //       jsonDecode(responseBody)['data'].cast<Map<String, dynamic>>();
  //   return parsed
  //       .map<UserModel>((json) => UserModel.fromJson(json))
  //       .toList();
  // }

  List<UserModel> parseSeller(String responseBody) {
    //debugPrint( responseBody.replaceAll(RegExp(r'\\'), '').substring(0,1));
    String decodedText = formateUtf8(responseBody);

    String jsonsDataString = decodedText.replaceAll(RegExp(r'\\'), '');
    //debugPrint('seller  $jsonsDataString');
    final parsed =
        jsonDecode(jsonsDataString.substring(1, jsonsDataString.length - 1)).cast<Map<String, dynamic>>();
    return parsed
        .map<UserModel>((json) => UserModel.fromJson(json))
        .toList();
  }

class UserApi extends GetConnect {



  var box = GetStorage();

  Future<dynamic> register(Map data) async {
    try {
        Response response = await post(
          ApiEndPoints.authEndPoints.register, 
          data,
        );

        //print('response is : ${response.body} ');   
        UserModel userModel = UserModel.fromJson(response.body['info_user']);

        // ||| ${userModel.id}

        box.write('info_user', <String, dynamic>{
          "id": userModel.id,
          "phone": userModel.phone,
          "nameCom": userModel.nameCom,
          "status": userModel.status,
          "address": userModel.address,
          "isSeller": userModel.isSeller,
        });

        if (response.statusCode == 200) {
          //print('response is : ${response.body}');
          return response.body;
        }else{
          return response.body;
        }
      }catch (e) {
        return Response(statusCode: 1, statusText: e.toString());
      }
    //print(response.body['message']);
  } 

  Future<dynamic> login(Map data) async {
    try {
        Response response = await post(
          ApiEndPoints.authEndPoints.auth, 
          data,
        );

        UserModel userModel = UserModel.fromJson(response.body['info_user']);

        box.write('info_user', <String, dynamic>{
          "id": userModel.id,
          "phone": userModel.phone,
          "nameCom": userModel.nameCom,
          "status": userModel.status,
          "address": userModel.address,
          "isSeller": userModel.isSeller,
        });

        // debugPrint(box.read('info_user'));

       
        if (response.statusCode == 200) {
         
          return response.body;
        }else{
          return response.body;
        }
      }catch (e) {
        return Response(statusCode: 1, statusText: e.toString());
      }
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
          print('boody ${file.statusCode}');
          return file.statusCode;
          //Response(body:compute(parseProduct, jsonEncode(res).toString()), statusCode:200);
        }
      print('boody ${file.body}');
      return file.statusCode;
  }



  Future<dynamic> verifyNumber(Map data) async {

    try {
      
        if (data.containsKey('phone')) {
          //String phone = data['phone'];
          Response response = await post(
            '${ApiEndPoints.authEndPoints.verifyNumber}?phone=${data['phone']}', 
            data,
          );

          print('status  ${response.body}');
          if (response.statusCode == 200) {
            return response.body;
          } else {
            return response.body;
          }
        } else {
          return "Phone number not provided"; // Gérer le cas où 'phone' n'est pas présent dans 'data'
        }

      }catch (e) {
        return Response(statusCode: 1, statusText: e.toString());
      }
    //print(response.body['message']);
  }

  Future<dynamic> verifyNumberAuth(Map data) async {
   
    try {
          if (data.containsKey('phone')) {
          String phone = data['phone'];
          Response response = await post(
            '${ApiEndPoints.authEndPoints.verifyNumberAuth}?phone=$phone',
            data,
          );

          print('status  ${response.body}');
          if (response.statusCode == 200) {
            return response.body;
          } else {
            return response.body;
          }
        } else {
          return "Phone number not provided"; // Gérer le cas où 'phone' n'est pas présent dans 'data'
        }
      }catch (e) {
        return Response(statusCode: 1, statusText: e.toString());
      }
    //print(response.body['message']);
  }

  Future<List<UserModel>> sellerFiles() async{
    CacheManager instance = CacheSeller.instance;
      await getDataSeller();
     final res = await instance.getFileFromCache(
      'cacheseller',
      ignoreMemCache:true,
     );

     if (res != null && await res.file.exists()) {
          var ress = await res.file.readAsString();
          print(ress);
          return compute(parseSeller, jsonEncode(ress).toString());
          //Response(body:compute(parseProduct, jsonEncode(res).toString()), statusCode:200);
        }
      return compute(parseSeller, jsonEncode({}).toString());

  }

  
  Future<List<UserModel>> getUser() async{
    CacheManager instance = MyCacheManager.instance;

    var file = await instance.getSingleFile(ApiEndPoints.authEndPoints.users,
          key:'cacheseller' ,
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
          print("KSDDDDDDDDDDDDDDD ${res}");
          return compute(parseSeller, jsonEncode(res).toString());
          //Response(body:compute(parseProduct, jsonEncode(res).toString()), statusCode:200);
        }
      return compute(parseSeller, jsonEncode({}).toString());
  }

  Future<List<UserModel>> getDataSeller() async{

    CacheManager instance = MyCacheManager.instance;

    var file = await instance.getSingleFile(ApiEndPoints.authEndPoints.sellers,
          key:'cacheseller' ,
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
          print("KSDDDDDDDDDDDDDDD ${res}");
          return compute(parseSeller, jsonEncode(res).toString());
          //Response(body:compute(parseProduct, jsonEncode(res).toString()), statusCode:200);
        }
      return compute(parseSeller, jsonEncode({}).toString());
  }

  

  Future<Map<String, dynamic>> createCompteSeller(UserModel userModel) async {
     try {
       Map<String, String> headers = {
          "Content-Type": "application/json",
          "X-Requested-With": "XMLHttpRequest",
          "Authorization": 'Bearer ${box.read('token')}',
        };
        var data = jsonEncode(<String, dynamic>{
          'nameCom': userModel.nameCom,
          'status': userModel.status,
          'address': userModel.address,
        });

        Response response = await post(
          ApiEndPoints.authEndPoints.sellerCompte, 
          data,
          headers: headers,
        );    
        if (response.statusCode == 200) {
          //print(response.body);
          return response.body;
        }else{
          return response.body;
        }
      }catch (e) {
        return throw Exception(e.toString());
      }

  }

  Future<bool> setTokens(String fcmToken) async {
     try {
       Map<String, String> headers = {
          "Content-Type": "application/json",
          "X-Requested-With": "XMLHttpRequest",
          "Authorization": 'Bearer ${box.read('token')}',
        };
        var data = jsonEncode(<String, dynamic>{
          'fcm_token': fcmToken,
        });

        Response response = await post(
          ApiEndPoints.authEndPoints.setToken, 
          data,
          headers: headers,
        );    
        print(response.body);
        if (response.statusCode == 200) {
          print(response.body);
          return true;//response.body;
        }else{
          return false;//response.body;
        }
      }catch (e) {
        return throw Exception(e.toString());
      }

  }

  Future<bool> setToken(String fcmToken) async {
    try {
     Map<String, String> headers = {
          "Content-Type": "application/json",
          "X-Requested-With": "XMLHttpRequest",
          "Authorization": 'Bearer ${box.read('token')}',
        };
        var data = jsonEncode(<String, dynamic>{
          'fcm_token': fcmToken,
        });

      Response response = await post(
        ApiEndPoints.authEndPoints.setToken, 
        data,
        headers: headers,
      );    

      if (response.statusCode == 301) {
        // Si la redirection est reçue, vous pouvez extraire la nouvelle URL
        String redirectUrl = response.headers!['location'] ?? '';
        // Vous pouvez utiliser cette nouvelle URL pour effectuer une nouvelle requête
        // ou effectuer toute autre action nécessaire.
        // Assurez-vous de gérer la redirection de manière appropriée ici.
        
        // Exemple pour une nouvelle requête vers la nouvelle URL
        Response redirectedResponse = await post(redirectUrl, data, headers: headers);
        print(redirectedResponse.body);
        
        // Vous pouvez gérer la réponse et le statut de la redirection ici
        if (redirectedResponse.statusCode == 200) {
          print(redirectedResponse.body);
          return true;
        } else {
          return false;
        }
      } else if (response.statusCode == 200) {
        print(response.body);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false; // Gérez les erreurs de manière appropriée ici
    }
  }

  Future<dynamic> logout() async {
   
    try {
        Response response = await get(
          ApiEndPoints.authEndPoints.logout,
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer ${box.read('token')}',
          }
        );
        if (response.statusCode == 200) {
          return response.body;
        }else{
          return response.body;
        }
      }catch (e) {
        return Response(statusCode: 1, statusText: e.toString());
      }
    //print(response.body['message']);
  } 



}
String formateUtf8(String input) {
  RegExp exp = RegExp(r"\\u[0-9a-fA-F]{4}");
  return input.replaceAllMapped(exp, (Match m) {
    String hex = m.group(0)!.substring(2); // Récupère les caractères hexadécimaux après '\u'
    int code = int.parse(hex, radix: 16); // Convertit en valeur numérique
    return String.fromCharCode(code); // Renvoie le caractère correspondant
  });
}

