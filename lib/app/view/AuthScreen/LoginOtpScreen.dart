import 'package:ecommerce/app/controllers/RegisterController.dart';
import 'package:ecommerce/utils/DefaultTitle.dart';
import 'package:ecommerce/utils/InputWidget.dart';
import 'package:ecommerce/utils/Logo.dart';
import 'package:ecommerce/utils/SizeHeigth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class LoginOtpScreen extends StatelessWidget {

  final String verificationId;
  final String phoneNumber;

  LoginOtpScreen({super.key,
    this.verificationId = '',
    this.phoneNumber = '',
  });

  final otp = TextEditingController();

  RegisterController registerController = Get.find();

  @override
  Widget build(BuildContext context) {
  registerController.verificationId = verificationId;
  registerController.phoneNumber = phoneNumber;

  GlobalKey<FormState> _formKey = GlobalKey();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  child: const Row(children: [
                    Logo()
                  ]),
                ),
                Sized().sizedHeigth(5),
                Container(
                  child: Column(children: [
                    DefautText().defautTitle("e-commerce"),
                    DefautText().defautTitle2("Commerce en ligne avec des contacts"),
                  ]),
                ),
                Sized().sizedHeigth(100),
                Container(
                  child:  Column(children: [
                    Text("Entrer le code envoyé au ${registerController.phoneNumber}", style: const TextStyle(
                      color: Color.fromARGB(255, 161, 159, 159),
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                    ),),
                    const Icon(
                      Icons.arrow_drop_down,
                      color:Colors.grey
                      ,
                    )
                  ]),
                ),
                Sized().sizedHeigth(40),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Obx(() {
                      return
                    FormBuilder(
                        key: _formKey, 
                        child: Column(
                          children: [
                            InputWidget(
                                textAlign:TextAlign.center,
                                decoration:InputDecoration(
                              ),
                              controller: otp,
                              keyboardType: TextInputType.number,
                              onChanged: (value){
                                registerController.smsCode.value = value!;
                              },
                              name:'otp'),
                            Stack(
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: TextButton(
                                    onPressed: !registerController.resend.value ? null : registerController.onResendSmsCode,
                                    child: Obx((){
                                      return
                                    Text(!registerController.resend.value
                                        ? "00:${registerController.count.value.toString().padLeft(2, "0")}"
                                        : "resend code");
                                    }),
                                    
                                  ),
                                ),
                              ],
                            ),

                            Stack(
                              children: [
                                Align(
                                    alignment: AlignmentDirectional.bottomEnd,
                                    child: TextButton(
                                      // child: registerController.loading.value //const Text('Suivant'),
                                      //     ? const CircularProgressIndicator(
                                      //         valueColor: AlwaysStoppedAnimation(Colors.greenAccent),
                                      //       )
                                         //  : 
                                      onPressed: 
                                       // Get.toNamed('/imageProfilScreen');
                                      registerController.smsCode.value.length < 6 || registerController.loading.value
                                            ? null
                                            :
                                              registerController.onVerifySmsCodeAuth,
                                      
                                      child: registerController.loading.value ?
                                         CircularProgressIndicator(
                                              valueColor: AlwaysStoppedAnimation(Colors.greenAccent),
                                            )
                                        : 
                                        const Text('Suivant'),

                                      // () {
                                      //   // registerController.verifyOtp(otp.text);
                                      //   // Get.toNamed("/imageProfilScreen");
                                      //   // _formKey.currentState?.validate();
                                      // },
                                    )),
                              ],
                            )
                          
                          ]
                        ),);
                    })
                  ),
                )
              ],
            )
          ,),
      )
    );
  }
}