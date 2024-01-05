import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce/app/view/AuthScreen/ConditionScreen.dart';
import 'package:ecommerce/app/view/AuthScreen/ImageProfilScreen.dart';
import 'package:ecommerce/app/view/HomeScreen.dart';
import 'package:ecommerce/app/view/welcomeScreen/WelcomeScreen.dart';
import 'package:ecommerce/data/response/serviceApi/ImageProfilApi.dart';
import 'package:ecommerce/data/response/serviceApi/UserApi.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';

class RegisterController extends GetxController {

  var authState = ''.obs;
  String verificationId = '';
  RxString smsCode = "".obs;
  RxBool loading = false.obs;
  RxBool resend = false.obs;
  RxInt count = 30.obs;
  String phoneNumber = '';
  RxBool imageIsDefine = false.obs;
  var auth = FirebaseAuth.instance;
  var box = GetStorage();
  RxBool isLogged = false.obs;
  RxString token = ''.obs;

 
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    decompte();
    print(box.read('token'));
    token.value = box.read('token') ?? '';
    if (token.isNotEmpty) {
      isLogged.value = true;
      print('Ok');
    }else{
      
      print(isLogged.value);

    }
  }

  RxString imagePath = ''.obs;
  RxString imageName = ''.obs;
  RxString key = 'https://ecommerce.doucsoft.com/api/v1/getProfilImage/'.obs;

  Future<void> getImageCamera() async {
    final ImagePicker _picker = ImagePicker();
    final image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      imagePath.value = image.path.toString();
      imageName.value = image.name.toString();
      var data = {};
      debugPrint(imageName.value);
      Map res = await ImageProfilApi().verifyImge();
      debugPrint(res.toString());
      // ignore: unrelated_type_equality_checks
      if (res['status']) {
        imageIsDefine.value = true;
        print('Ok');
        await ImageProfilApi().updateImage(imagePath.value, imageName.value, res['id']);
        String url = "https://ecommerce.doucsoft.com/api/v1/getProfilImage/";
        await CachedNetworkImage.evictFromCache(url, cacheKey: key.value);
        imageCache!.clear();
        imageCache!.clearLiveImages();
        key.value = 'https://ecommerce.doucsoft.com/api/v1/getProfilImage/${DateTime.now().microsecondsSinceEpoch}';

      }else{
        imageIsDefine.value = true;
        print('No');
        await ImageProfilApi().addImage(imagePath.value, imageName.value, data);
      }
    }
  }
  Future getImageGallery() async {
    final ImagePicker _picker = ImagePicker();
    final image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      imagePath.value = image.path.toString();
      imageName.value = image.name.toString();
      var data = {};
      debugPrint(imageName.value);
      Map res = await ImageProfilApi().verifyImge();
      debugPrint(res.toString());
      // ignore: unrelated_type_equality_checks
      if (res['status']) {
        print('Ok');
        await ImageProfilApi().updateImage(imagePath.value, imageName.value, res['id']);
        String url = "https://ecommerce.doucsoft.com/api/v1/getProfilImage/";
        await CachedNetworkImage.evictFromCache(url);
        imageCache!.clear();
        imageCache!.clearLiveImages();
      }else{
        print('No');
        await ImageProfilApi().addImage(imagePath.value, imageName.value, data);
      }
    }
  }



  late Timer timer;

  final _auth = FirebaseAuth.instance;

  void decompte() {
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (count.value < 1) {
        timer.cancel();
        count.value = 30;
        resend.value = true;
        //setState(() {});
        return;
      }
      count.value--;
    });
  }

  void onResendSmsCode() {
    resend.value = false;
    authWithPhoneNumber(phoneNumber, onCodeSend: (verificationId, v) {
      loading.value = false;
      decompte();
    }, onAutoVerify: (v) async {
      await _auth.signInWithCredential(v);
      Get.back();
    }, onFailed: (e) {
      loading.value = false;
      print("Le code est erroné");
    }, autoRetrieval: (v) {});
  }

  Future<void> onVerifySmsCode() async {
    loading.value = true;
    bool validOtp = await validateOtp(smsCode.value, verificationId);

    if(validOtp){
      loading.value = true;
      Get.offAll(() => const ConditionScreen());
      Get.snackbar(
      'Succès', 
      'Vérification éfectué avec succès',
      backgroundColor:Colors.greenAccent,
      colorText:Colors.white,
      );
      print("Vérification éfectué avec succès");

    }else{
      Get.snackbar(
        'Erreur', 
        'Code de Vérification Invalide',
        backgroundColor:Colors.red,
        colorText:Colors.white,
        );
    }
  }
  Future<void> onVerifySmsCodeAuth() async {
    loading.value = true;
    bool validOtp = await validateOtpAuth(smsCode.value, verificationId);

    if(validOtp){
      loading.value = true;
      Get.offAll(() => HomeScreen());
      Get.snackbar(
      'Succès', 
      'Vérification éfectué avec succès',
      backgroundColor:Colors.greenAccent,
      colorText:Colors.white,
      );
      print("Vérification éfectué avec succès");

    }else{
      Get.snackbar(
        'Erreur', 
        'Code de Vérification Invalide',
        backgroundColor:Colors.red,
        colorText:Colors.white,
        );
    }
  }

  Future<void> authWithPhoneNumber(String phone, {
    required Function(String value, int? value1) onCodeSend,
    required Function(PhoneAuthCredential value) onAutoVerify,
    required Function(FirebaseAuthException value) onFailed,
    required Function(String value) autoRetrieval,
  }) async {
     
    await FirebaseAuth.instance.verifyPhoneNumber(
      timeout:const Duration(seconds: 30),
      phoneNumber:phone,
      verificationCompleted: onAutoVerify,
      verificationFailed: onFailed,
      codeSent:onCodeSend,
      codeAutoRetrievalTimeout:autoRetrieval,
    );
  }

  Future<bool> validateOtp(String smsCode, String verificationId) async {
    RxBool otpIsTrue = false.obs;
    try {
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId, smsCode: smsCode);

      User? user = (await auth.signInWithCredential(credential)).user;

      //print(user);
      if (user != null) {
        otpIsTrue.value = true;
        Map<dynamic, dynamic> phone = {
          'phone':phoneNumber
        };
        var res = await UserApi().register(phone);
        isLogged.value = true;
        // print('token is ${res['data']}');
        token.value = res['data']['token'];
        box.write('token', token.value);
        print( isLogged.value);
        }else{
          print('Otp invalid');
      }

    } on FirebaseAuthException catch  (e) {
      print('Failed with error code: ${e.code}');
      print(e.message);
    }

    return otpIsTrue.value;
    
  }

  Future<bool> validateOtpAuth(String smsCode, String verificationId) async {
    RxBool otpIsTrue = false.obs;
    try {
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId, smsCode: smsCode);

      User? user = (await auth.signInWithCredential(credential)).user;

      //print(user);
      if (user != null) {
        otpIsTrue.value = true;
        Map<dynamic, dynamic> phone = {
          'phone':phoneNumber
        };
        var res = await UserApi().login(phone);
        isLogged.value = true;
        token.value = res['data']['token'];
        box.write('token', token.value);
        print( isLogged.value);
        }else{
          print('Otp invalid');
      }

    } on FirebaseAuthException catch  (e) {
      print('Failed with error code: ${e.code}');
      print(e.message);
    }

    return otpIsTrue.value;
    
  }

  Future<void> disconnect() async {
    await auth.signOut();
    Get.offAll(() => WelcomeScreen());
    loading.value = false;
    return;
  }

  User? get user => auth.currentUser;
}
