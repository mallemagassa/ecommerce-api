import 'package:contacts_service/contacts_service.dart';
import 'package:ecommerce/app/models/UserModel.dart';
import 'package:ecommerce/data/response/serviceApi/ConversationApi.dart';
import 'package:ecommerce/data/response/serviceApi/ImageProfilApi.dart';
import 'package:ecommerce/data/response/serviceApi/OrderApi.dart';
import 'package:ecommerce/data/response/serviceApi/UserApi.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactConfig {
  
  Future<PermissionStatus> _getContactPermission() async {
    PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.permanentlyDenied) {
      PermissionStatus permissionStatus = await Permission.contacts.request();
      return permissionStatus;
    } else {
      return permission;
    }
  }
  Future<void> loadAndgetConversation() async {
    final List<Map<String, dynamic>> conversation = [];
    final List<dynamic> usersDynamic = GetStorage().read('users') ?? [];
    final List<Map<String, dynamic>> users = List<Map<String, dynamic>>.from(usersDynamic);
    final conversations = await ConversationApi().getConversation();

    conversations.forEach((conversationData) {
      final phone = conversationData.phone;
      final matchedUser = users.firstWhere(
        (user) => user['phone'] == phone,
        orElse: () => {},
      );

      if (matchedUser != null) {
        matchedUser['conversation_id'] = conversationData.conversationId;
        matchedUser['receiver_id'] = conversationData.receiverId;
        conversation.add(matchedUser);
      }
    });

    print('conversation : $conversation');
    GetStorage().write('conversations', conversation);
    //return conversation[0]['conversation_id'];
  }

  Future<void> loadAndgetMyOders() async {
    final List<Map<String, dynamic>> order = [];
    final List<dynamic> usersDynamic = GetStorage().read('users') ?? [];
    final List<Map<String, dynamic>> users = List<Map<String, dynamic>>.from(usersDynamic);
    final orders = await OrderApi().getMyOders();

     print('My order data is $orders');

    orders.forEach((orderData) {
     // print('My order is 1 $orderData');
      final phone = orderData.phone;
      final matchedUser = users.firstWhere(
        (user) => user['phone'] == phone,
        orElse: () => {},
      );

      if (matchedUser != null) {
      //  matchedUser['conversation_id'] = conversationData.conversationId;
        order.add(matchedUser);
      }
    });

    print('My order is $order');

    GetStorage().write('orders', order);

  }


  // Charger et stocker les contacts au premier accès
  Future<void> loadAndStoreContacts() async {
    final box = GetStorage();
    // Vérifier si les contacts sont déjà stockés localement
    print('usssss ${box.read('users')}');

    if (box.read('users') == null) {
      Iterable<Contact>? contacts;
      PermissionStatus permissionStatus = await _getContactPermission();
      // Récupérer les contacts depuis ContactsService
      if (permissionStatus == PermissionStatus.granted) {
        contacts = await ContactsService.getContacts(
          withThumbnails: false,
          iOSLocalizedLabels: false,
          androidLocalizedLabels: false,
          photoHighResolution:false,
          orderByGivenName:false,
        );
      }

      // Vérifier si des contacts ont été récupérés
      if (contacts != null && contacts.isNotEmpty) {
        // Convertir les contacts en une liste utilisable pour le stockage
        List contactForBa = [];
        List<List<dynamic>> users = [];
        List<List<String>> profil = [];

        //final contactsList = contacts.map((contact) => contact.toMap()).toList();
        await UserApi().getUser().then((value) {
          //print('Value user is ${box.read('users')}');
          List<List<String>> matchingContacts = [];
          List userPhone = [];
          String phone = '';
          String? displayName = '';

          value.forEach((element) {
              phone = element.phone;
              userPhone.add(element.phone);
              users.add([element.id!.toString(), element.phone, element.isSeller, element.nameCom, element.status, element.address]);
            });

          contacts?.forEach((element) {
                displayName = element.displayName;
                
                element.phones!.forEach((element) {
                  if (!element.value!.startsWith('+')) {
                    PhoneNumber number = PhoneNumber(countryISOCode: 'ML', countryCode: '+223', number: element.value!.removeAllWhitespace);
                    String formattedNumber = number.completeNumber;
                    //print('formattedNumber :: $formattedNumber');
                    matchingContacts.add([formattedNumber, displayName ?? '']);
                    // Utilisez formattedNumber comme nécessaire
                  } else {
                    matchingContacts.add([element.value!.removeAllWhitespace, displayName ?? "",]);
                  }
                });
          });

          contactForBa = matchingContacts.where((element) => userPhone.contains(element[0])).toList();
          print('contactForBa ::: $contactForBa');
          Map<String, String> combinedMap = {};

          for (List<dynamic> item in contactForBa) {
            combinedMap[item[0]] = item[1];
          }

          for (List<dynamic> item in users) {
            if (combinedMap.containsKey(item[1])) {
              item.add(combinedMap[item[1]]);
            }
          }
      });

      await ImageProfilApi().getDataProfil().then((value){
        value.forEach((element) {
          profil.add([element.image, element.userId.toString()]);
        });
      });

    Map<int, List<dynamic>> usersMap = {};
    Map<int, List<dynamic>> imageUrlMap = {};

    // Création du Map pour les utilisateurs avec ID comme clé
    // contactForBa.where((element) => element[0] == users )
    // print('users ::: $users')


    List<List<dynamic>> result = [];

    // Création d'une Map pour stocker les numéros de téléphone et leurs occurrences dans liste1
    Map<String, int> phoneNumbersMap = {};

    // Parcours de liste1 pour enregistrer les numéros et leurs occurrences dans la Map
    for (List<dynamic> contact in contactForBa) {
      String phoneNumber = contact[0].toString();
      phoneNumbersMap[phoneNumber] = (phoneNumbersMap[phoneNumber] ?? 0) + 1;
    }

    // Parcours de liste2 pour comparer les numéros avec ceux de liste1
    for (List<dynamic> contact in users) {
      String phoneNumber = contact[1].toString();
      if (phoneNumbersMap.containsKey(phoneNumber) && phoneNumbersMap[phoneNumber]! > 0) {
        // Si le numéro de téléphone existe dans liste1, ajoutez cet élément à la liste result
        result.add(contact);
        // Décrémente le nombre d'occurrences du numéro dans liste1
        phoneNumbersMap[phoneNumber] = phoneNumbersMap[phoneNumber]! - 1;
      }
    }
    print('Result :::::::::::: $result');
    for (var user in result) {
      usersMap[int.parse(user[0])] = user.sublist(1); // Utilisation de l'ID comme clé et des données restantes comme valeurs
    }

    // Création du Map pour les images avec ID comme clé
    for (var image in profil) {
      imageUrlMap[int.parse(image[1])] = image.sublist(0, 1); // Utilisation de l'ID comme clé et de l'image comme valeur
    }

    //print('matchingContacts is $usersMap');
    List<Map<String, dynamic>> combinedList = [];
    print('usersMap :: $usersMap');
    // Fusion des données en utilisant l'ID comme référence
    
    for (var id in usersMap.keys) {
      Map<String, dynamic> combinedData = {
       "id": id,
        "name":"${usersMap[id]![5]}",
        "phone":"${usersMap[id]![0]}" ,
        "isSeller": usersMap[id]![1],
        "image": "${imageUrlMap[id]?.first}" ?? "",
        "nameCom": "${usersMap[id]![2]}",
        "status": "${usersMap[id]![3]}",
        "address": "${usersMap[id]![4]}"
      };
      combinedList.add(combinedData);
    }

    //print('Résultat fusionné : $combinedList');

    print('Utilisateurs combinés: $users');
      // Stocker les contacts localement avec GetStorage
      await box.write('users', combinedList);
      print('Contacts stockés localement avec succès');
      //print(' uuser : ${profil}');
      } else {
        print('Aucun contact récupéré');
      }
    } else {
      print('Les contacts sont déjà stockés localement');
    }
  }


Future<void> refreshContactsLocally() async {
  final box = GetStorage();
  List<dynamic>? localContacts = box.read('users');

  // Charger les contacts actuels du téléphone
  Iterable<Contact> phoneContacts = await ContactsService.getContacts(
    withThumbnails: false,
    iOSLocalizedLabels: false,
    androidLocalizedLabels: false,
    photoHighResolution:false,
    orderByGivenName:false,
  );

  //List<dynamic> updatedContacts = [];

  // Mettre à jour les données locales en fonction des contacts actuels du téléphone
  if (localContacts != null && localContacts.isNotEmpty) {
    // for (var phoneContact in phoneContacts) {
    //   updatedContacts.add(phoneContact.toMap());
    // }
    
    final contactLast = box.read('users') as List<dynamic>;
    final contactLastAsMap = contactLast.cast<Map<String, dynamic>>();
    List contactForBa = [];
    List<List<dynamic>> users = [];
    List<List<String>> profil = [];

    // updatedContacts.forEach((element) {
      
    // });
   // print('updatedContacts $updatedContacts');

    // Comparer les contacts existants avec les nouveaux contacts
    // Identifier les ajouts, suppressions et modifications
    // Mettre à jour les données locales en conséquence


    await UserApi().getUser().then((value) {
      //print('Value user is ${box.read('users')}');
      List<List<String>> matchingContacts = [];
      List userPhone = [];
      String phone = '';
      String? displayName = '';

      value.forEach((element) {
          phone = element.phone;
          userPhone.add(element.phone);
          users.add([element.id!.toString(), element.phone, element.isSeller, element.nameCom, element.status, element.address]);
        });

      phoneContacts.forEach((element) {
            displayName = element.displayName;
            
            element.phones!.forEach((element) {

              if (!element.value!.startsWith('+')) {
                PhoneNumber number = PhoneNumber(countryISOCode: 'ML', countryCode: '+223', number: element.value!.removeAllWhitespace);
                String formattedNumber = number.completeNumber;
                matchingContacts.add([formattedNumber, displayName ?? "",]);
                // Utilisez formattedNumber comme nécessaire
              } else {
                matchingContacts.add([element.value!.removeAllWhitespace, displayName ?? "",]);
              }
            });
      });

      contactForBa = matchingContacts.where((element) => userPhone.contains(element[0])).toList();

      Map<String, String> combinedMap = {};

      for (List<dynamic> item in contactForBa) {
        combinedMap[item[0]] = item[1];
      }

      for (List<dynamic> item in users) {
        if (combinedMap.containsKey(item[1])) {
          item.add(combinedMap[item[1]]);
        }
      }

      // print('Contact Accutuel est : $matchingContacts');
      // print('User Accutuel : $users');
      // print('User Accutuel : $users');

    });


    await ImageProfilApi().getDataProfil().then((value){
      value.forEach((element) {
        profil.add([element.image, element.userId.toString()]);
      });
    });

    Map<int, List<dynamic>> usersMap = {};
    Map<int, List<dynamic>> imageUrlMap = {};

     List<List<dynamic>> result = [];

    // Création d'une Map pour stocker les numéros de téléphone et leurs occurrences dans liste1
    Map<String, int> phoneNumbersMap = {};

    // Parcours de liste1 pour enregistrer les numéros et leurs occurrences dans la Map
    for (List<dynamic> contact in contactForBa) {
      String phoneNumber = contact[0].toString();
      phoneNumbersMap[phoneNumber] = (phoneNumbersMap[phoneNumber] ?? 0) + 1;
    }

    // Parcours de liste2 pour comparer les numéros avec ceux de liste1
    for (List<dynamic> contact in users) {
      String phoneNumber = contact[1].toString();
      if (phoneNumbersMap.containsKey(phoneNumber) && phoneNumbersMap[phoneNumber]! > 0) {
        // Si le numéro de téléphone existe dans liste1, ajoutez cet élément à la liste result
        result.add(contact);
        // Décrémente le nombre d'occurrences du numéro dans liste1
        phoneNumbersMap[phoneNumber] = phoneNumbersMap[phoneNumber]! - 1;
      }
    }
    print('Result :::::::::::: $result');
    for (var user in result) {
      usersMap[int.parse(user[0])] = user.sublist(1); // Utilisation de l'ID comme clé et des données restantes comme valeurs
    }

    // Création du Map pour les images avec ID comme clé
    for (var image in profil) {
      imageUrlMap[int.parse(image[1])] = image.sublist(0, 1); // Utilisation de l'ID comme clé et de l'image comme valeur
    }

    List<Map<String, dynamic>> combinedList = [];

    print('user is : $usersMap');

    // Fusion des données en utilisant l'ID comme référence
    for (var id in usersMap.keys) {
      Map<String, dynamic> combinedData = {
        "id": id,
        "name":"${usersMap[id]![5]}",
        "phone":"${usersMap[id]![0]}" ,
        "isSeller": usersMap[id]![1],
        "image": "${imageUrlMap[id]?.first}" ?? "",
        "nameCom": "${usersMap[id]![2]}",
        "status": "${usersMap[id]![3]}",
        "address": "${usersMap[id]![4]}"
      };
      combinedList.add(combinedData);
    }

   
    if (!compareUsers(combinedList, contactLastAsMap)) {
      await box.write('users', combinedList);
    }
    print('Contacts locaux mis à jour');
  } 
 
}


  bool compareUsers(List<Map<String, dynamic>> list1, List<Map<String, dynamic>> list2) {
    return list1.toString() == list2.toString();
  }

}