import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:ecommerce/app/models/MessageModel.dart';
import 'package:ecommerce/data/response/serviceApi/MessageApi.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class ChatMessagesStorage extends GetConnect{
  final box = GetStorage();
  // late StreamController<List<MessageModel>> _messageStreamController;
  // late Timer _pollingTimer;
  // List<MessageModel> _previousMessages = [];

  //  Stream<List<MessageModel>> get messageStream => _messageStreamController.stream;

  // ChatMessagesStorage() {
  //   _messageStreamController = StreamController<List<MessageModel>>.broadcast();
  //   _startPolling();
  // }

  // void _startPolling() {
  //   const Duration pollInterval = Duration(seconds: 1);

  //   _pollingTimer = Timer.periodic(pollInterval, (_) {
  //     final List<MessageModel> currentMessages = getMessages('messages');

  //     if (!_listEquals(currentMessages, _previousMessages)) {
  //       _messageStreamController.add(currentMessages);
  //       _previousMessages = List.from(currentMessages);
  //     }
  //   });
  // }


  Future<Uint8List?> downloadAndDisplayImage(String imageUrl) async {
    try {
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
        // Afficher l'image depuis les données téléchargées
        print('Données de l\'image : $imageData');
        return Uint8List.fromList(imageData); // Retourner les données de l'image
      } else {
        print('Erreur lors du téléchargement de l\'image : ${response.statusCode}');
        return null; // Retourner null en cas d'erreur
      }
    } catch (e) {
      print('Erreur lors du téléchargement de l\'image : $e');
      return null; // Retourner null en cas d'erreur
    }
  }


  Future<void> getMessageFromApi() async {
    MessageApi(). getMessage().then((value) {
      print("Toutes sont le : ${value.length}");
      value.forEach((element) {
        saveMessage(element);
      });
    });
  }



  // Méthode pour sauvegarder un message
  Future<void> saveMessage(MessageModel message) async {
  final messageKey = 'messages';
  final dynamic messagesData = box.read(messageKey);
  List<Map<String, dynamic>> messages = [];

  if (messagesData != null && messagesData is List) {
    messages = List<Map<String, dynamic>>.from(messagesData.whereType<Map<String, dynamic>>());
  }

  // Vérifier si le message existe déjà dans la liste en se basant sur l'ID
  final existingMessage = messages.firstWhere(
    (msg) => msg['id'] == message.id,
    orElse: () => {},
  );

  if (existingMessage.isEmpty) {
    if (message.media != null && message.media!.isNotEmpty) {
      final Uint8List? response = await downloadAndDisplayImage('https://ecommerce.doucsoft.com/api/v1/getImageMessage/${message.media?.substring(29)}');

      if (response != null) {
        final Directory appDir = await getApplicationDocumentsDirectory();
        final String currentTime = DateTime.now().millisecondsSinceEpoch.toString();
        final String localPath = '${appDir.path}/$currentTime.jpg';
        final File imgFile = File(localPath);

        // Écrire les données de l'image téléchargée dans un fichier local
        await imgFile.writeAsBytes(response);
        int? fileSize = await imgFile.length();
        message.size = fileSize;
        //message.size = imgFile.length() as int?;
        
        // Enregistrez le chemin de l'image localement avec GetStorage
        final newMessage = {
          'id': message.id,
          'senderId': message.senderId,
          'receiverId': message.receiverId,
          'type': message.type,
          'media': localPath, // Enregistrez le chemin local de l'image au lieu du nom du fichier
          'text': message.text,
          'video': message.video,
          'document': message.document,
          'conversationId': message.conversationId,
          'size':message.size
        };

        messages.add(newMessage);
        await box.write(messageKey, messages);
        getMessages('messages');
      }
    }else{
       final newMessage = {
          'id': message.id,
          'senderId': message.senderId,
          'receiverId': message.receiverId,
          'type': message.type,
          'media': message.media, // Enregistrez le chemin local de l'image au lieu du nom du fichier
          'text': message.text,
          'video': message.video,
          'document': message.document,
          'conversationId': message.conversationId,
          'size':message.size
        };

        messages.add(newMessage);
        await box.write(messageKey, messages);
        getMessages('messages');
    }
  }
}


  // Méthode pour récupérer les messages pour une conversation
  // List<String> getMessages(MessageModel message) {
  //   final messageKey = 'sender_${message.senderId}_receiver_${message.receiverId}_conversation_${message.conversationId}';
  //   return box.read<List<String>>(messageKey) ?? [];
  // }

//  List<String> getMessages(String key) {
//     final messageKey = key;
//     final dynamic messagesData = box.read<List<dynamic>>(messageKey);
    
//     if (messagesData != null) {
//       // Convertir dynamiquement chaque élément en String
//       return messagesData.map<String>((dynamic item) => item.toString()).toList();
//     } else {
//       return []; // Retourner une liste vide si les données ne sont pas présentes ou null
//     }
//     // final messageKey = 'sender_${message.senderId}_receiver_${message.receiverId}_conversation_${message.conversationId}';
//     // return box.read<List<String>>(messageKey) ?? [];
//   }

//   List<MessageModel> getMessages(String key) {
//   final messageKey = key;
//   final dynamic messagesData = box.read<List<dynamic>>(messageKey);
//   List<MessageModel> messages = [];

//   if (messagesData != null && messagesData is List) {
//     messages = messagesData.map<MessageModel>((dynamic item) {
//       // Convertir chaque élément en MessageModel
//       return MessageModel(
//         id: item['id'] ?? '',
//         senderId: item['senderId'] ?? '',
//         receiverId: item['receiverId'] ?? '',
//         type: item['type'] ?? '',
//         media: item['media'] ?? '',
//         text: item['text'] ?? '',
//         video: item['video'] ?? '',
//         document: item['document'] ?? '',
//         conversationId: item['conversationId'] ?? '',
//       );
//     }).toList();
//   }

//   return messages;
// }


 List<MessageModel> getMessages(String key) {
    final dynamic messagesData = box.read<List<dynamic>>(key);
    List<MessageModel> messages = [];

    if (messagesData != null && messagesData is List) {
      messages = messagesData.map<MessageModel>((dynamic item) {
        return MessageModel(
          id: item['id'] ?? '',
          senderId: item['senderId'] ?? '',
          receiverId: item['receiverId'] ?? '',
          type: item['type'] ?? '',
          media: item['media'] ?? '',
          text: item['text'] ?? '',
          video: item['video'] ?? '',
          document: item['document'] ?? '',
          conversationId: item['conversationId'] ?? '',
        );
      }).toList();
    }

    return messages;
  }

  // void dispose() {
  //   _pollingTimer.cancel();
  //   _messageStreamController.close();
  // }

 bool _listEquals(List<MessageModel> list1, List<MessageModel> list2) {
  // Vérifier si les deux listes ont la même longueur
    if (list1.length != list2.length) {
      return false;
    }

    // Comparer chaque élément des listes en fonction de l'ID
    for (int i = 0; i < list1.length; i++) {
      if (list1[i].id != list2[i].id) {
        return false; // S'ils diffèrent, les listes ne sont pas égales
      }
    }

    // Si toutes les comparaisons ont été identiques jusqu'ici, les listes sont égales
    return true;
  }
}