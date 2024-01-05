import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:bubble/bubble.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce/app/ChatMessagesStorage.dart';
import 'package:ecommerce/app/CombinedMessage.dart';
import 'package:ecommerce/app/models/CartModel.dart';
import 'package:ecommerce/app/models/MessageModel.dart';
import 'package:ecommerce/contactConfig/ContactConfig.dart';
import 'package:ecommerce/contactConfig/OneSignal/OneSignal.dart';
import 'package:ecommerce/data/response/serviceApi/MessageApi.dart';
import 'package:ecommerce/data/response/serviceApi/UserApi.dart';
import 'package:ecommerce/websoketConfig/PusherConfig.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pusher_client_fixed/pusher_client_fixed.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';
//import 'package:pusher_client/pusher_client.dart';

class ChatScreen extends StatefulWidget {
  //final Key conversationKey; // Clé de la conversation
  ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final box = GetStorage();
  final argumentData = Get.arguments;
  final conversations = GetStorage().read('conversations');
  //final StreamController<List<MessageModel>> _streamController = StreamController();
  final _user = types.User(id: GetStorage().read('info_user')['id'].toString());
  final StreamController<List<types.Message>> _messagesController = StreamController<List<types.Message>>.broadcast();
  //final List<types.Message> _messages = [];
  final chatStorage = ChatMessagesStorage();
  List<MessageModel> converList = [];
  final conv = GetStorage().read('conversations').where((element) => element['id'] == Get.arguments['id']).toList(); 

  // Future<void> setupOneSignal(int userId) async {
  //   await initOneSignal();
  //   registerOneSignalEventListener(
  //     onOpened: onOpened,
  //     onReceivedInForeground: onReceivedInForeground,
  //   );
  //   promptPolicyPrivacy(userId);
  // }

  // void onOpened(OSNotificationClickEvent result) {
  //   print('NOTIFICATION OPENED HANDLER CALLED WITH: ${result}');
  //   print(
  //       "Opened notification: \n${result.notification.jsonRepresentation().replaceAll("\\n", "\n")}");

  //   try {
  //     final data = result.notification.additionalData;
  //     if (data != null) {
  //       final chatId = (data['data']['chatId'] as int);
  //       final chatBloc = context.read<ChatBloc>();
  //       final selectedChat = chatBloc.state.selectedChat;

  //       if (chatId != selectedChat?.id) {
  //         chatBloc.add(ChatNotificationOpened(chatId));
  //         Navigator.of(context).pushNamed(ChatScreen.routeName);
  //       }
  //     }
  //   } catch (_) {}
  // }

  // void onReceivedInForeground(OSNotificationWillDisplayEvent event) {
  //   print(
  //       "Notification received in foreground notification: \n${event.notification.jsonRepresentation().replaceAll("\\n", "\n")}");
  //   //final chatBloc = context.read<ChatBloc>();
  //   try {
  //     final data = event.notification.additionalData;
  //     //final selectedChat = chatBloc.state.selectedChat;

  //     if (argumentData['conversation_id'] != null && data != null) {
  //       print(data);
  //       final chatId = (data['data']['conversation_id'] as int);

  //       if (argumentData['conversation_id'] == chatId) {
  //         event.notification. //complete(null);
  //         return;
  //       }
  //     }
  //     //chatBloc.add(const ChatStarted());
  //     event.complete(event.notification);

  //     print(data);
  //   } catch (_) {
  //     event.complete(null);
  //   }
  // }

  // Future<void> promptPolicyPrivacy(int userId) async {
  //   final oneSignalShared = OneSignal.Debug;

  //   bool userProvidedPrivacyConsent =
  //       await oneSignalShared.userProvidedPrivacyConsent();

  //   if (userProvidedPrivacyConsent) {
  //     sendUserTag(userId);
  //   } else {
  //     bool requiresConsent = await oneSignalShared.requiresUserPrivacyConsent();

  //     if (requiresConsent) {
  //       final accepted =
  //           await oneSignalShared.promptUserForPushNotificationPermission();
  //       if (accepted) {
  //         await oneSignalShared.consentGranted(true);
  //         sendUserTag(userId);
  //       }
  //     } else {
  //       sendUserTag(userId);
  //     }
  //   }
  // }

  void listenChatChannel() {
    print('conversation_id : ${argumentData['conversation_id'].runtimeType} ${conv}');
    LaravelEcho.instance.private('conversation.${conv.isNotEmpty ? conv[0]['conversation_id'] ?? 0 :0}').listen('.message.posted',
        (e) {
      if (e is PusherEvent) {
        if (e.data != null) {
          debugPrint(jsonDecode(e.data!).toString());
          _handleNewMessage(jsonDecode(e.data!));
        }
      }
    }).error((err) {
      debugPrint(err.toString());
    });
  }

  void listenUserIsOnlineChannel() {
    LaravelEcho.instance.private('user.${GetStorage().read('info_user')['id']}').listen('.user.joined.channel',
        (e) {
      if (e is PusherEvent) {
        if (e.data != null) {
          debugPrint(jsonDecode(e.data!).toString());
          _handleNewMessage(jsonDecode(e.data!));
        }
      }
    }).error((err) {
      debugPrint(err.toString());
    });
  }

  void leaveChatChannel() {
    try {
      LaravelEcho.instance.leave('conversation.${ conv.isNotEmpty ? conv[0]['conversation_id'] ?? 0 :0}');
    } catch (err) {
      debugPrint(err.toString());
    }
  }


  @override
  void initState() {
    super.initState();
    LaravelEcho.init(token: box.read('token'));
    listenChatChannel();
    LaravelEcho.instance.connect();
    listenUserIsOnlineChannel();
    getMessageStreamForConversation(conv.isNotEmpty ? conv[0]['conversation_id'] ?? 0 :0, argumentData['id']);
    // var va = await ContactConfig().loadAndgetConversation();
    // if (conv.isNotEmpty && conv[0]['conversation_id'] != null) {
    //   getMessageStreamForConversation(conv.isNotEmpty ? conv[0]['conversation_id'] ?? 0 :va, argumentData['id']);
    //   print('Last conversation_id is ${conv[0]["conversation_id"]}');
    //   if (conv[0]['receiver_id'] == argumentData['id']) {
    //     getMessageStreamForConversation(va, argumentData['id']);
    //   }
    // }

      //print('message.data______ ${argumentData['message']}');

    if (argumentData['products'] != null) {
      //print('argumentData[products] ${argumentData['products']}');
      setState(() {
          _addMessageOrder(argumentData['products']);
      });
        //print('hahahaha ${argumentData['products'].runtimeType}');//first.product['image']
    }
    setState(() {

    });
  }

  void _handleNewMessage(Map<String, dynamic> data) {
    List<types.TextMessage> updatedMessages = [];
    List<types.ImageMessage> updatedImageMessages = [];
    final chatMessage = MessageModel.fromJson(data['message']);
    List<MessageModel> me = [chatMessage];
      me.forEach((element) async {
        if (element.media != null && element.media!.isNotEmpty) {
              updatedImageMessages.add(
                types.ImageMessage(
                  author: types.User(id: element.senderId.toString()),
                  id: element.id.toString(),
                  uri: element.media.toString(),
                  name: element.media.toString(),
                  size: element.size ?? 0, // Taille du fichier
                  createdAt: DateTime.now().millisecondsSinceEpoch,
                ),
              );

          } else {
            updatedMessages.add(
              types.TextMessage(
                author: types.User(id: element.senderId.toString()),
                id: element.id.toString(),
                text: element.text.toString(),
                createdAt: DateTime.now().millisecondsSinceEpoch,
              ),
            );
          }
        });

        setState(() {
          _messagesController.add(updatedMessages); 
          _messagesController.add(updatedImageMessages);
          //print(_messages);
        });
  }

  Stream<List<types.Message>> getMessageStreamForConversation(int conversationId, int receiverId) async* {
    StreamController<List<types.Message>> controller = StreamController();

    await for (final element in MessageApi().selectconver(conversationId, receiverId)) {
      if (element is FileInfo) {
        print('File is ${element.file.readAsStringSync()}');
        List<MessageModel> me = parseMessage(jsonEncode(element.file.readAsStringSync()).toString());
        List<MessageModel> converList = me.where((element) => element.conversationId == conversationId).toList();

        List<types.Message> messages = [];

        for (final element in converList) {
          if (element.media != null && element.media!.isNotEmpty && element.text == null) {
            final Directory appDir = await getApplicationDocumentsDirectory();
            final String localPath = '${appDir.path}/${element.media.toString().substring(29)}';
            final File imgFile = File(localPath);
            final Uint8List? response = await MessageApi().downloadAndDisplayImage('https://ecommerce.doucsoft.com/api/v1/getImageMessage/${element.media?.substring(29)}');
                          
            if (response != null) {
              await imgFile.writeAsBytes(response);
              int? fileSize = await imgFile.length();
              element.size = fileSize;
              //print('zeeeeeeeeeeeeeeeeeee ${ await imgFile.length()}');
              messages.add(
                types.ImageMessage(
                  author: types.User(id: element.senderId.toString(), lastName: argumentData['name']),
                  id: element.id.toString(),
                  uri: localPath,
                  name: element.media!.substring(29),
                  size: element.size ?? 0,
                  createdAt: DateTime.now().millisecondsSinceEpoch,
                ),
              );
            }
          } else if(element.media != null && element.media!.isNotEmpty && element.text != null && element.text!.isNotEmpty){
            final Directory appDir = await getApplicationDocumentsDirectory();
            final String localPath = '${appDir.path}/${element.media.toString().substring(29)}';
            //final File imgFile = File(localPath);
            final Uint8List? response = await MessageApi(). downloadAndDisplayImage('https://ecommerce.doucsoft.com/api/v1/getImageMessage/${element.media?.substring(29)}');
                          
            if (response != null) {
                messages.add(
                  CombinedMessage(
                      messageId:element.id.toString() ,
                      authorId: types.User(id: element.senderId.toString(), ),
                      type: types.MessageType.unsupported,
                      text: types.TextMessage(
                              author: types.User(id: element.senderId.toString(), ),
                              id:element.id.toString(),
                              text: element.text.toString(),
                              createdAt: DateTime.now().millisecondsSinceEpoch,
                            ) ,
                      image:  types.ImageMessage(
                            author: types.User(id: element.senderId.toString(), ),
                            id: element.id.toString(),
                            uri: localPath,
                            name: element.media!.substring(29),
                            size: element.size ?? 0,
                            createdAt: DateTime.now().millisecondsSinceEpoch,
                        ),
                      createdAt: DateTime.now(),
                )
                );
              }
          }

          else {
            messages.add(
              types.TextMessage(
                author: types.User(id: element.senderId.toString(), lastName: argumentData['name']),
                id: element.id.toString(),
                text: element.text.toString(),
                createdAt: DateTime.now().millisecondsSinceEpoch,
              ),
            );
          }
        }

        controller.add(messages);
      }
    }

    controller.close();
    yield* controller.stream;
  }

  bool isVisible = false;
  bool isSelected = false;
  List<String> messageId = [];
 

  Future<void> dispose() async {
    super.dispose();
    LaravelEcho.instance.disconnect();
    leaveChatChannel();
    //fetchMessages();
    listenUserIsOnlineChannel();
    _messagesController.close;
    await UserApi().disconnect(GetStorage().read('info_user')['id']);
    //connect();
    //print('La taille du message ${_messages.length}');
  }
  late Stream<List<types.Message>> currentConversationStream;

 
  @override
  Widget build(BuildContext context) {
  currentConversationStream = getMessageStreamForConversation(conv.isNotEmpty ? conv[0]['conversation_id'] ?? 0 :0, argumentData['id']);


    return Scaffold(
        //key:, //ValueKey(),
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          leadingWidth: 5,
          actions: [
            isVisible ?
            IconButton(
                onPressed: () {
                  Get.defaultDialog(
                      title: 'Voulez-vous vraiment supprimer ?',
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () async {
                              setState(() {
                                isVisible = false;
                              });
                              messageId.forEach((element) async {
                                await MessageApi().deleteMessage(int.parse(element));
                                _messagesController;
                                setState(() {
                                  
                                });
                              });
                              Get.back();
                              messageId.clear();
                            },
                            child: const Text('Oui', style: TextStyle(fontSize: 20)),
                          ),
                          TextButton(
                            onPressed: () {
                              Get.back(); // Fermer le dialogue sans supprimer
                            },
                            child: const Text('Non', style: TextStyle(fontSize: 20)),
                          ),
                        ],
                      ),
                    );
                  
                  
                },
                icon: const Icon(Icons.delete), color: Colors.redAccent,)
              : const Text('')
          ],
          title: GFListTile(
            avatar: GFAvatar(
              backgroundColor: Color.fromARGB(255, 228, 224, 224),
              child:  SizedBox(
                width: 160,
                height: 160,
                child:
                CachedNetworkImage(
                    imageUrl: Get.arguments['url'] != null && Get.arguments['url'].isNotEmpty? "${Get.arguments['url']}": "defaultAvatar.jpg",
                    width: 160,
                    height: 160,
                    //cacheKey:"profil",
                    fadeOutDuration: Duration(seconds: 1),
                    fadeInDuration:Duration(seconds: 1),
                    httpHeaders: {
                              "Authorization":
                                  "Bearer ${box.read('token')}"
                            },
                    progressIndicatorBuilder: (context, url, downloadProgress) => 
                            CircularProgressIndicator(value: downloadProgress.progress),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(70),
                      image: DecorationImage(
                        image:imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
              ))
          
            ),
          titleText: argumentData['name'],
          subTitleText: argumentData['phone'],
          
          onTap: () {
            Get.toNamed('/detailProfilUserScreen', arguments: <String, dynamic>{
                  'url': argumentData['url'],
                  'phone': argumentData['phone'],
                  'name': argumentData['name'],
                  'isSeller': argumentData['isSeller'],
                  'nameCom': argumentData['nameCom'],
                  'status': argumentData['status'],
                  'address': argumentData['address'],
            });
          },
        ),
         
        ),
        body: StreamBuilder<List<types.Message>>(
        //key: currentConversationKey,//ValueKey(argumentData['conversation_id']),
        stream: currentConversationStream,//MessageApi().selectconver(argumentData['conversation_id'], argumentData['id']),//MessageApi().selectconver(idCon, idRece),//_messages.reversed.toList(),
        builder: (BuildContext context, AsyncSnapshot<List<types.Message>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child:CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.network_check, weight: 100, size: 50,),
                              Text("Une erreur s'est produite lors de la connexion. Veuillez vérifier votre connexion Internet et réessayer.",
                              style: TextStyle(
                                fontSize: 16
                              ),
                              textAlign: TextAlign.center,
                              )
                            ],
                          )
                        ) ; //Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No messages available.'));
          }
          else {
          
            return Chat(
              key: ValueKey(conv.isNotEmpty ? conv[0]['conversation_id'] ?? 0 :0,),
              emojiEnlargementBehavior: EmojiEnlargementBehavior.multi,
              messages: snapshot.data!.reversed.toList(),
              onMessageTap: (context, p1) {
                if (isVisible) {
                  setState(() {
                    if (messageId.contains(p1.id)) {
                      messageId.remove(p1.id);
                      
                    }else{
                      messageId.add(p1.id);
                    }
                  });
                  print('length message is ${messageId}');
                }
              },
              onMessageLongPress: (context, message){
                  setState(() {
                    messageId.add(message.id);
                    isVisible = true;
                  });
              },
              // customMessageBuilder:(p0, {required messageWidth}) {
              //   return Text();
              // },
              onAttachmentPressed: _handleImageSelection,
              onSendPressed: _handleSendPressed,
              showUserAvatars: true,
              showUserNames: true,
              inputOptions: const InputOptions(
                sendButtonVisibilityMode: SendButtonVisibilityMode.always,
                autocorrect: true,
              ),
              user: _user,
              bubbleBuilder: _bubbleBuilder,
              l10n: const ChatL10nEn(
                inputPlaceholder: 'Tapez votre message ici',
                emptyChatPlaceholder:"Aucun Message Envoyé"
              ),
            );
          }
        },
      ),
     
       );
  }


  Widget _bubbleBuilder(
  Widget child, {
  required message,
  required nextMessageInGroup,
}) {

    if (message.type == types.MessageType.unsupported) {
      ///print(' message.author.id  ${ message.author.id}');
      CombinedMessage combinedMessage = message as CombinedMessage;
      return GestureDetector(
        onTap: (){
          if (!isVisible) {

           if ( _user.id != message.author.id) {
               Get.toNamed('/detailCartOwnerScreen', arguments: <String, dynamic>{
                'id': argumentData['id'],
                'url': argumentData['url'],
                'phone': argumentData['phone'],
                'name': argumentData['name'],
              },
            
            );
           }else{
             Get.toNamed('/detailCartScreen', arguments: <String, dynamic>{
                'id': argumentData['id'],
                'url': argumentData['url'],
                'phone': argumentData['phone'],
                'name': argumentData['name'],
              },
            
            );
           }
            // print(' message.author.id  ${ message.id}');
          }else{
            setState(() {
              if (messageId.contains(message.id)) {
                messageId.remove(message.id);
                
              }else{
                messageId.add(message.id);
              }
            });
          }
        },
        child: ZoomTapAnimation(
          child: Bubble(
            color: _user.id != message.author.id 
              ? isVisible && messageId.contains(message.id) ? Colors.grey :const Color(0xfff5f5f7) 
              : isVisible && messageId.contains(message.id) ? Colors.grey : const Color(0xff6f61e8),
              margin: nextMessageInGroup
              ? const BubbleEdges.symmetric(horizontal: 6)
              : null,
              nip: nextMessageInGroup
              ? BubbleNip.no
              : _user.id != message.author.id  ||
              message.type == types.MessageType.unsupported
              ? BubbleNip.leftBottom
              : BubbleNip.rightBottom,
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (combinedMessage.image != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Image.file(File(combinedMessage.image!.uri))
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                '${combinedMessage.text.text}',
                style:  TextStyle(
                  color: _user.id != message.author.id && message.type == types.MessageType.unsupported ?
                   Colors.black : Colors.white ,
                  fontSize: 16,
                  fontWeight: FontWeight.w700
                ),
              ),
            ],
          )
          ),
        ),
      );
    }
    return Bubble(
      child: child,
      color: _user.id != message.author.id ||
              message.type == types.MessageType.image
          ? isVisible && messageId.contains(message.id) ? Colors.grey : const Color(0xfff5f5f7) : isVisible && messageId.contains(message.id) ? Colors.grey : const Color(0xff6f61e8),
      margin: nextMessageInGroup
          ? const BubbleEdges.symmetric(horizontal: 6)
          : null,
      nip: nextMessageInGroup
          ? BubbleNip.no
          : _user.id != message.author.id 
              ? BubbleNip.leftBottom
              : BubbleNip.rightBottom,
    );

}

 Future<void> _addMessage(types.TextMessage message) async {
  await MessageApi().sendMessage(
    MessageModel(
      senderId: int.parse(message.author.id),
      receiverId: argumentData['id'],
      type: message.type.toString(),
      text: message.text,
    ),
  );
  // Mettre à jour la conversation sans bloquer l'interface utilisateur
  _updateConversation();
}

Future<void> _updateConversation() async {
  await ContactConfig().loadAndgetConversation();
  setState(() {
    MessageApi().selectconver(conv.isNotEmpty ? conv[0]['conversation_id'] ?? 0 : 0, argumentData['id']);
    _messagesController;
  });
}

  Future<void> _addMessageOrder(List<Map<String, dynamic>> map) async{
     if (map.first['image'] != null && map.first['image']!.isNotEmpty) {
          final Directory appDir = await getApplicationDocumentsDirectory();
          final String localPath = '${appDir.path}/${map.first['image'].toString()}';
          final Uint8List? response = await MessageApi().downloadAndDisplayImage('https://ecommerce.doucsoft.com/api/v1/getImageProductM${map.first['image']}');//.substring(29)

          if (response != null) {
            await MessageApi().sendMessage(MessageModel(senderId: 1, receiverId: argumentData['id'], type: 'unsupported', text:'Votre commande est passe avec succes, cliquez pour voir la détails de la commande', media:localPath ), fileName: localPath.substring(29));
          }

          setState(() {
            MessageApi().selectconver(conv.isNotEmpty ? conv[0]['conversation_id'] ?? 0 :0, argumentData['id']);
            _messagesController;
          });
     }
 
  }

  Future<void> _addImageMessage(types.ImageMessage message) async{
    await MessageApi().sendMessage(MessageModel(senderId: int.parse(message.author.id), receiverId: argumentData['id'], type: message.type.toString(), media: message.uri), fileName: message.name);
    await ContactConfig().loadAndgetConversation();
    setState(() {
      _messagesController;
    });
  }


  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: '',
      text: message.text,
    );

    _addMessage(textMessage);
  }

 void _handleImageSelection() async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    if (result != null) {
      final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);

      final message = types.ImageMessage(
        author: _user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        height: image.height.toDouble(),
        id: '',
        name: result.name,
        size: bytes.length,
        uri: result.path,
        width: image.width.toDouble(),
      );

      _addImageMessage(message);
    }
  }

  List<MessageModel> parseMessage(String responseBody) {
  //debugPrint( responseBody.replaceAll(RegExp(r'\\'), '').substring(0,1));

  String decodedText = _decodeUtf8(responseBody);
  //debugPrint(decodedText);
  String jsonsDataString = decodedText.replaceAll(RegExp(r'\\'), '');
  final parsed =
      jsonDecode(jsonsDataString.substring(1, jsonsDataString.length - 1)).cast<Map<String, dynamic>>();
  return parsed
      .map<MessageModel>((json) => MessageModel.fromJson(json))
      .toList();
  }

  String _decodeUtf8(String input) {
    RegExp exp = RegExp(r"\\u[0-9a-fA-F]{4}");
    return input.replaceAllMapped(exp, (Match m) {
      String hex = m.group(0)!.substring(2); // Récupère les caractères hexadécimaux après '\u'
      int code = int.parse(hex, radix: 16); // Convertit en valeur numérique
      return String.fromCharCode(code); // Renvoie le caractère correspondant
    });
  }


  Future<List<File>> getAllImagesInDirectory() async {
      List<File> images = [];
      Directory appDocDir = await getApplicationDocumentsDirectory();
      List<FileSystemEntity> entities = appDocDir.listSync(recursive: false, followLinks: false);

      for (var entity in entities) {
        if (entity is File && entity.path.contains('.jpg')) {
          // Vérifie si le fichier est une image (vous pouvez ajuster les critères selon vos besoins)
          images.add(entity);
        }
      }

    return images;
  }
  
}