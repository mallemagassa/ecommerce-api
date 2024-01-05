
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:ecommerce/app/models/MessageModel.dart';
import 'package:ecommerce/managerCache/CacheManager.dart';
import 'package:ecommerce/managerCache/CacheManagerMessages.dart';
import 'package:ecommerce/utils/ApiEndPoints.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_cache_manager/src/cache_manager.dart';
import 'package:get/get_connect/connect.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

List<MessageModel> parseMessage(String responseBody) {
  //debugPrint( responseBody.replaceAll(RegExp(r'\\'), '').substring(0,1));

  String jsonsDataString = responseBody.replaceAll(RegExp(r'\\'), '');
  debugPrint(jsonsDataString);
  final parsed =
      jsonDecode(jsonsDataString.substring(1, jsonsDataString.length - 1)).cast<Map<String, dynamic>>();
  return parsed
      .map<MessageModel>((json) => MessageModel.fromJson(json))
      .toList();
  }

  Stream<List<MessageModel>> parseMessages(String responseBody) {
  //debugPrint( responseBody.replaceAll(RegExp(r'\\'), '').substring(0,1));

  String jsonsDataString = responseBody.replaceAll(RegExp(r'\\'), '');
  final parsed =
      jsonDecode(jsonsDataString.substring(1, jsonsDataString.length - 1)).cast<Map<String, dynamic>>();
  debugPrint('dddddddddddddddddd ${parsed
      .map<MessageModel>((json) => MessageModel.fromJson(json))
      .toList()}');
  return parsed
      .map<MessageModel>((json) => MessageModel.fromJson(json))
      .toList();
  }
class MessageApi extends GetConnect {

  // final StreamController<List<MessageModel>> _streamController = StreamController();
  var box = GetStorage();


  Future<List<MessageModel>> getData() async{

    CacheManager instance = MyCacheManager.instance;

    var file = await instance.getSingleFile(ApiEndPoints.authEndPoints.messages,
          key:'customCacheKey' ,
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
          return compute(parseMessage, jsonEncode(res).toString());
          //Response(body:compute(parseMessage, jsonEncode(res).toString()), statusCode:200);
        }
      return compute(parseMessage, jsonEncode({}).toString());
  }

  // Future<Stream<List<MessageModel>>> getDatass(int idCon, int idRece) async {

  // CacheManager instance = CacheManagerMessages.instance;
  // Stream<FileResponse> file = instance.getFileStream('${ApiEndPoints.authEndPoints.selectconver}$idCon/$idRece',
  //       key:'messges' ,
  //       headers: {
  //         //'Content-Type': 'multipart/form-data',
  //         'cache-control': 'private, max-age=2',
  //         "X-Requested-With": "XMLHttpRequest",
  //         HttpHeaders.authorizationHeader: 'Bearer ${box.read('token')}',
  //       },
  //     );
      
  //  // FileInfo fileInfo;
  //   String uer = '';
  //   file.forEach((element) async {
  //     FileInfo fileInfo = element as FileInfo;
  //     if (fileInfo.file != null && await fileInfo.file.exists()) {
  //       uer = fileInfo.file.readAsStringSync();
        
  //       //uer = compute(parseMessages, jsonEncode(res).toString());
  //       //print(compute(parseMessages, jsonEncode(res).toString()));
  //       //Response(body:compute(parseMessage, jsonEncode(res).toString()), statusCode:200);
  //     print('llllllllllllllllllllllllll ${uer}');
  //     }
  //   });

    

  //   return compute(parseMessages, jsonEncode('[{"id":2,"sender_id":1,"receiver_id":1,"type":"media","text":null,"media":"public\/images\/messages\/media\/No59ZDsvC3HoLXozCvthgKv2JGo2yIAS5AcOOhwS.jpg","video":null,"document":null,"conversation_id":2},{"id":3,"sender_id":1,"receiver_id":1,"type":"media","text":null,"media":"public\/images\/messages\/media\/grujgFDotueijV7EEpY2jbLWlJFHgty024ACORhs.jpg","video":null,"document":null,"conversation_id":2},{"id":4,"sender_id":1,"receiver_id":1,"type":"text","text":"Eyurttyjjv","media":null,"video":null,"document":null,"conversation_id":2},{"id":5,"sender_id":1,"receiver_id":1,"type":"media","text":null,"media":"public\/images\/messages\/media\/85XuZhm5QzQCfxNVv1GjNg6eiGeqeI7eLtJMq1xH.jpg","video":null,"document":null,"conversation_id":2},{"id":22,"sender_id":1,"receiver_id":3,"type":"text","text":"Bonjour papa foune","media":null,"video":null,"document":null,"conversation_id":2}]').toString()); //compute(parseMessage as ComputeCallback<String, Stream<List<MessageModel>>>, jsonEncode({}).toString());
  // }

  Stream<FileResponse> selectconver(int idCon, int idRece) {

    CacheManager instance = CacheManagerMessages.instance;

    var file = instance.getFileStream('${ApiEndPoints.authEndPoints.selectconver}$idCon/$idRece',
          //key:'message' ,
          headers: {
            'Content-Type': 'application/json',
            'cache-control': 'private, max-age=120',
            "X-Requested-With": "XMLHttpRequest",
            HttpHeaders.authorizationHeader: 'Bearer ${box.read('token')}',
          },
        );
       // FileInfo fileInfo = file as FileInfo;
       // if (fileInfo.file != null &&  fileInfo.file.exists()) {
         // var res =  fileInfo.file.readAsString();
          //compute(parseMessage, jsonEncode(res).toString());
          
          return file;
          //Response(body:compute(parseMessage, jsonEncode(res).toString()), statusCode:200);
       // }
      //return file; //compute(parseMessage, jsonEncode({}).toString());
  }


   Future<Uint8List?> downloadAndDisplayImage(String imageUrl) async {
    try {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String fileName = imageUrl.split('/').last; // Récupère le nom du fichier à partir de l'URL
      String filePath = '${appDocDir.path}/$fileName'; // Chemin local du fichier

      File imageFile = File(filePath);
      if (imageFile.existsSync()) {
      //print('fillllllllllllle ${await imageFile.readAsBytes()}');
        return imageFile.readAsBytes(); // Retourne les données de l'image si elle existe localement
      }

      var url = Uri.parse(imageUrl);
      var response = await http.get(
        url,
        headers: {
          "X-Requested-With": "XMLHttpRequest",
          "Authorization": "Bearer ${box.read('token')}"
        },
      );

      if (response.statusCode == 200) {
        var imageData = response.bodyBytes;
        imageFile.writeAsBytesSync(imageData); // Écrit les données de l'image dans le fichier local
        return Uint8List.fromList(imageData); // Retourne les données de l'image
      } else {
        print('Erreur lors du téléchargement de l\'image : ${response.statusCode}');
        return null; // Retourne null en cas d'erreur
      }
    } catch (e) {
      print('Erreur lors du téléchargement de l\'image : $e');
      return null; // Retourne null en cas d'erreur
    }
  }

  
  Future<List<MessageModel>> getMessage() async{

    CacheManager instance = CacheManagerMessages.instance;

    var file = await instance.getSingleFile(ApiEndPoints.authEndPoints.messages,
          key:'messgesss' ,
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
          return compute(parseMessage, jsonEncode(res).toString());
          //Response(body:compute(parseMessage, jsonEncode(res).toString()), statusCode:200);
        }
      return compute(parseMessage, jsonEncode({}).toString());
  }


  // Future<List<MessageModel>> fetchProduct() async {
  //   try {
  //       Map<String, String> headers = {
  //         //'Content-Type': 'multipart/form-data',
  //         "X-Requested-With": "XMLHttpRequest",
  //         HttpHeaders.authorizationHeader: 'Bearer ${box.read('token')}',
  //       };

  //       Response response = await get(
  //         ApiEndPoints.authEndPoints.products,
  //         headers: headers,

  //       );

  //       debugPrint(jsonEncode(response.body).toString());

  //       if (response.statusCode == 200) {
  //         //debugPrint(jsonEncode(response.body));
  //         return compute(parseMessage, jsonEncode(response.body).toString());
  //       }else{
  //         //debugPrint(jsonEncode(response.body) );
  //         return response.body;
  //       }
  //     }catch (e) {
  //       return throw Exception(e.toString());
  //     }
  //   //print(response.body['message']);
  // } 


  //  Future<dynamic> sendMessage(MessageModel message, {String fileName = ''}) async {
  //   try {
  //       final form = FormData({
  //         'sender_id':message.senderId,
  //         'receiver_id':message.receiverId,
  //         'type':(message.type == 'MessageType.text') ? 'text' : 'media',
  //         'text':message.text ?? '',
  //         'video':message.video ?? '',
  //         'document':message.document ?? '',
  //         'conversation_id':message.conversationId ?? '',
  //         if (message.media != null && message.media!.isNotEmpty)
  //           'media':  MultipartFile(File(message.media!), filename: fileName, contentType: 'image/jpeg/png'),
  //       });

  //       debugPrint(form.length as String?);
  //       Response response = await post(
  //         ApiEndPoints.authEndPoints.messages, 
  //         form,
  //         headers:  {
  //           'Content-Type': 'multipart/form-data',
  //           "X-Requested-With": "XMLHttpRequest",
  //           "Authorization": 'Bearer ${box.read('token')}',
  //         }
  //       );
  //       debugPrint(response.body.toString());

  //       if (response.statusCode == 200) {
  //         debugPrint(response.body);
  //         return response.body;
  //       }else{
  //         debugPrint(response.body);
  //         return response.body;
  //       }
  //     }catch (e) {
  //       return Response(statusCode: 1, statusText: e.toString());
  //     }
  //   //print(response.body['message']);
  // } 

  // Stream<FileResponse> downloadAndDisplayImage(String imageUrl) {
  //   try {
  //      CacheManager instance = CacheManagerMessages.instance;

  //   var file = instance.getFileStream(
  //       imageUrl,
  //       headers: {
  //         "X-Requested-With": "XMLHttpRequest",
  //         "Authorization": "Bearer ${box.read('token')}"
  //       },
  //     );
  //      FileInfo fileInfo = file as FileInfo;
  //     //if (fileInfo.file != null && fileInfo.file.()) {
  //      // var imageData = response.bodyBytes;
  //       // Afficher l'image depuis les données téléchargées
  //       //print('Données de l\'image : $imageData');
  //       return fileInfo.file.readAsBytes(); // Retourner les données de l'image
  //     // } else {
  //     //   print('Erreur lors du téléchargement de l\'image : ${response.statusCode}');
  //     //   return null; // Retourner null en cas d'erreur
  //     // }
  //   } catch (e) {
  //     print('Erreur lors du téléchargement de l\'image : $e');
  //     return null; // Retourner null en cas d'erreur
  //   }
  // }


   Future<dynamic> sendMessage(MessageModel message, {String fileName = ''}) async {
    try {
      final formData = FormData({
        'sender_id': message.senderId,
        'receiver_id': message.receiverId,
        'type': message.type == 'MessageType.text' ? 'text' : 'media',
        if (message.text != null && message.text!.isNotEmpty)
        'text': message.text ?? '',
        if (message.video != null && message.video!.isNotEmpty)
        'video': message.video ?? '',
        if (message.document != null && message.document!.isNotEmpty)
          'document': message.document ?? '',
        'conversation_id': message.conversationId ?? '',
        if (message.media != null && message.media!.isNotEmpty)
          'media': MultipartFile(File(message.media!), filename: fileName, contentType: 'image/jpeg/png'),
      });


      final response = await post(
        'https://ecommerce.doucsoft.com/api/v1/messages', // Votre URL cible
        formData,
        headers: {
          "X-Requested-With": "XMLHttpRequest",
          "Authorization": 'Bearer ${box.read('token')}',
        },
      );

      if (response.statusCode == 200) {
        return response.body;
      } else {
        print('Code de statut HTTP non géré: ${response.statusCode}');
        return null; // Ou une gestion d'erreur spécifique selon le cas
      }
    } catch (e) {
      print('Exception lors de l\'envoi du message: $e');
        return null; // Ou une gestion d'erreur spécifique selon le cas
      }
  }
  


  // Future<dynamic> sendMessage(MessageModel message, {String fileName = ''}) async {
  //   try {
  //     final formData = FormData({
  //       'sender_id': message.senderId,
  //       'receiver_id': message.receiverId,
  //       'type': message.type == 'MessageType.text' ? 'text' : 'media',
  //       if (message.text != null && message.text!.isNotEmpty)
  //       'text': message.text ?? '',
  //       if (message.video != null && message.video!.isNotEmpty)
  //       'video': message.video ?? '',
  //       if (message.document != null && message.document!.isNotEmpty)
  //         'document': message.document ?? '',
  //       'conversation_id': message.conversationId ?? '',
  //       if (message.media != null && message.media!.isNotEmpty)
  //         'media': MultipartFile(File(message.media!), filename: fileName, contentType: 'image/jpeg/png'),
  //     });

  //     final response = await post(
  //       ApiEndPoints.authEndPoints.messages,
  //       formData,
  //       headers: 
  //       {
  //           //'Content-Type': 'multipart/form-data',
  //           "X-Requested-With": "XMLHttpRequest",
  //           "Authorization": 'Bearer ${box.read('token')}',
  //         },
  //     );

  //     if (response.statusCode == 200) {
  //       return response.body;
  //     } else {
  //       print('Code de statut HTTP non géré: ${response.body}');
  //       return null; // Ou une gestion d'erreur spécifique selon le cas
  //     }
  //   } catch (e) {
  //     print('Exception lors de l\'envoi du message: $e');
  //     return null; // Ou une gestion d'erreur spécifique selon le cas
  //   }
  // }


Future<bool> deleteMessage(int id) async{
    var file = await delete(ApiEndPoints.authEndPoints.messages+id.toString(),
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
      //await selectconver();
      return true;
    }

    return false;
  }
  
  
}

