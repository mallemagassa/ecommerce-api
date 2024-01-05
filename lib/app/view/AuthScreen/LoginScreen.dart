import 'package:ecommerce/app/controllers/RegisterController.dart';
import 'package:ecommerce/app/view/AuthScreen/LoginOtpScreen.dart';
import 'package:ecommerce/data/response/serviceApi/UserApi.dart';
import 'package:ecommerce/utils/DefaultTitle.dart';
import 'package:ecommerce/utils/Logo.dart';
import 'package:ecommerce/utils/SizeHeigth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  //RxBool loading = false.obs;
  //final phoneNumber = TextEditingController();

  RegisterController registerController = Get.find();

  RxBool loading = false.obs;
  String phoneNumber = '';
  void sendOtpCode() async {
    loading.value = true;
    final _auth = FirebaseAuth.instance;
    if (phoneNumber.isNotEmpty) {
      var phone = {
        'phone': phoneNumber
      };
      var res = await UserApi().verifyNumberAuth(phone);
      print('status  ${res['status']}');
      loading.value = true;
      if (!res['status']) {
        Get.snackbar('Erreur'
          , res['message']);
        loading.value = false;
       }else{
        registerController.authWithPhoneNumber(phoneNumber, 
        onCodeSend: (verificationId, v) {
          loading.value = true;
          Get.offAll(() => LoginOtpScreen(
                    verificationId: verificationId,
                    phoneNumber: phoneNumber,
                  ));
        }, 
        onAutoVerify: (v) async {
          // var phone = {
          //   'phone': phoneNumber
          // };
          // var res = await UserApi().verifyNumberAuth(phone);
          //print(res['message']);
          await _auth.signInWithCredential(v);
          Get.offAll(() => LoginOtpScreen()); //Navigator.of(context).pop();
        }, onFailed: (e) {
          loading.value = false;
          //setState(() {});
          print("Le code est erroné");
        }, autoRetrieval: (v) {});
       }
    }
  }

  // void sendOtpCode(){
  //   final _auth = FirebaseAuth.instance;

  //   if (phoneNumber.isNotEmpty) {   
  //     registerController.authWithPhoneNumber(
  //       phoneNumber.value, 
  //       onCodeSend: (verificationId, v){
  //         Get.offAllNamed('/otp');
  //       }, 
  //       onAutoVerify: (v) async{
  //        await _auth.signInWithCredential(v);
  //       }, 
  //       onFailed: (v){
  //         print('Le code est errone');
  //       }, 
  //       autoRetrieval: (v){

  //       }
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> _formKey = GlobalKey();

    FocusNode focusNode = FocusNode();
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
      child: Center(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              child: Row(children: [const Logo()]),
            ),
            Sized().sizedHeigth(5),
            Container(
              child: Column(children: [
                DefautText().defautTitle("e-commerce"),
                DefautText()
                    .defautTitle2("Commerce en ligne avec des contacts"),
              ]),
            ),
            Sized().sizedHeigth(100),
            Container(
              child: const Column(children: [
                Text(
                  "Entrer votre numéro mobile",
                  style: TextStyle(
                    color: Color.fromARGB(255, 161, 159, 159),
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                Icon(
                  Icons.arrow_drop_down,
                  color: Colors.grey,
                )
              ]),
            ),
            Sized().sizedHeigth(40),
            Container(
              child: Padding(
                padding: EdgeInsets.all(20),
                child:
                  Obx((){
                    return
                   Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        IntlPhoneField(
                          // controller: phoneNumber,
                          focusNode: focusNode,
                          decoration: const InputDecoration(),
                          languageCode: "en",
                          initialCountryCode: 'ML',
                          disableAutoFillHints: true,
                          searchText: 'Choisis votre pays',
                          invalidNumberMessage: "Numéro de téléphone",
                          onChanged: (phone) {
                            //registerController.verifyPhone('+223'+phoneNumber.text);
                            phoneNumber = phone.completeNumber;
                            //Get.to(LoginOtpScreen());
                          },
                          onCountryChanged: (country) {
                            print('Country changed to: ' + country.name);
                          },
                        ),
                        Sized().sizedHeigth(5),
                        Stack(
                          children: [
                            Align(
                                alignment: AlignmentDirectional.bottomEnd,
                                child: TextButton(
                                  onPressed:loading.value? null : (){
                                    _formKey.currentState?.validate();
                                    sendOtpCode();
                                  } ,
                                  //(){
                                    //Get.toNamed('/otp');
                                 // }, //loading.value ? null : sendOtpCode,
                                  child: //const Text('Suivant')
                                  loading.value
                                    ? const CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation(Colors.greenAccent),
                                      )
                                    : const Text('Suivant'),
                                )),
                          ],
                        )
                      ],
                    ),
                    );
                  }),
              ),
            )
          ],
        ),
      ),
    ));
  }
}
