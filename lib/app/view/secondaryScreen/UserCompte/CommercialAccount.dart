import 'package:ecommerce/app/models/UserModel.dart';
import 'package:ecommerce/app/view/secondaryScreen/UserCompte/ProfilUserScreen.dart';
import 'package:ecommerce/data/response/serviceApi/UserApi.dart';
import 'package:ecommerce/utils/InputWidget.dart';
import 'package:ecommerce/utils/MainButton.dart';
import 'package:ecommerce/utils/NamePageSecondary.dart';
import 'package:ecommerce/utils/SizeHeigth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class CommercialAccount extends StatelessWidget {
  CommercialAccount({super.key});
  final _formKey = GlobalKey<FormBuilderState>();
  @override
  Widget build(BuildContext context) {

  var box = GetStorage();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: NamePageSecondary(title: "compte commercial"),
      ),
      body: SingleChildScrollView(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FormBuilder(
                key: _formKey,
                child: Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 16, right: 16),
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Sized().sizedHeigth(50),
                        InputWidget(
                          name: 'nameCom',
                          initialValue: box.read('info_user')['isSeller'] ? box.read('info_user')['nameCom'] : "",
                          decoration:const InputDecoration(
                            contentPadding: EdgeInsets.all(10),
                            label: Text("Nom commercial"),
                            labelStyle: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.blue),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromRGBO(224, 224, 224, 1))),
                          ),
                          valideType: FormBuilderValidators.compose([
                             FormBuilderValidators.required(
                              errorText: "Cette champ est obligatoire"
                             ),
                          ]),
                        ),
                        Sized().sizedHeigth(50),
                        InputWidget(
                          name: 'status',
                          initialValue: box.read('info_user')['isSeller'] ? box.read('info_user')['status'] : "",
                          decoration:const InputDecoration(
                            contentPadding: EdgeInsets.all(10),
                            label: Text("Statut commercial"),
                            labelStyle: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.blue),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromRGBO(224, 224, 224, 1))),
                          ),
                          minLines: 4,
                          valideType: FormBuilderValidators.compose([
                             FormBuilderValidators.required(
                              errorText: "Cette champ est obligatoire"
                             ),
                          ]),
                        ),
                        Sized().sizedHeigth(50),
                        InputWidget(
                          name: 'address',
                          initialValue: box.read('info_user')['isSeller'] ? box.read('info_user')['status'] : "",
                          decoration: const InputDecoration(
                            labelStyle: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.blue),
                            contentPadding: EdgeInsets.all(10),
                            label: Text("Adresse commercial"),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromRGBO(224, 224, 224, 1))),
                          ),
                          valideType: FormBuilderValidators.compose([
                             FormBuilderValidators.required(
                              errorText: "Cette champ est obligatoire"
                             ),
                          ]),
                        ),
                        Sized().sizedHeigth(50),
                        Stack(
                          children: [
                            Align(
                              alignment: AlignmentDirectional.bottomCenter,
                              child: Stack(
                                children: [
                                  Align(
                                      alignment:
                                          AlignmentDirectional.bottomCenter,
                                      child: MainButton(
                                          onTap: () async {
                                            if (_formKey.currentState?.saveAndValidate() ?? false) {
                                              debugPrint(_formKey.currentState?.value
                                                  .toString());
                                              debugPrint('validation');
                                              // FocusScope.of(context).requestFocus(FocusNode());
                                              final map = _formKey.currentState!.value;
                                              final newMap = {
                                                ...map,
                                                'phone': "00000000",
                                                'isSeller': true,
                                              };
                                              UserModel seller = UserModel.fromMap(newMap);
                                              //print(seller.phone);
                                              
                                              Map<String, dynamic> res = await UserApi().createCompteSeller(seller);
                                              Get.snackbar(
                                                '',
                                                '',
                                                //icon: const Icon(Icons.check, color: Colors.green,),
                                                //backgroundColor:Colors.white,
                                                duration: const Duration(seconds: 3),
                                                messageText: Text(
                                                 res["message"],
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 24
                                                  ),
                                                ),
                                                titleText: const Icon(Icons.check, color: Colors.green, size: 32,),
                                              
                                              );

                                              // box.listenKey('key', (value){
                                              //  value['phone'] = '+22392683269';
                                              //  value['nameCom'] = map['nameCom'];
                                              //  value['status'] = map['status'];
                                              //  value['address'] = map['address'];
                                              //  value['isSeller'] = true;
                                              // });
                                              box.write('info_user', <String, dynamic>{
                                                "id":GetStorage().read('info_user')['id'].toString(),
                                                "phone": GetStorage().read('info_user')['phone'].toString(),
                                                "nameCom": map['nameCom'],
                                                "status":  map['status'],
                                                "address":  map['address'],
                                                "isSeller": true,
                                              });
                                              Get.off(ProfilUserScreen());
                                                      
                                            } else {
                                              debugPrint(_formKey.currentState?.value
                                                  .toString());
                                              debugPrint('validation échoue');
                                            }
                                          },
                                          icon: Icons.check,
                                          color: Colors.black)),
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
