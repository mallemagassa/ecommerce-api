import 'package:contacts_service/contacts_service.dart';
import 'package:ecommerce/app/view/addContact/AddContactScreen.dart';
import 'package:ecommerce/contactConfig/ContactConfig.dart';
import 'package:ecommerce/utils/InputWidget.dart';
import 'package:ecommerce/utils/MainButton.dart';
import 'package:ecommerce/utils/NamePageSecondary.dart';
import 'package:ecommerce/utils/SizeHeigth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class FormContac extends StatelessWidget {
  FormContac({super.key});

  final  _formKey = GlobalKey<FormBuilderState>();
  String phoneNumber = '';
  FocusNode focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: NamePageSecondary(title: "Nouveau Contact"),
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
                    child: Container(
                      decoration:  BoxDecoration(
                        border:Border.all(
                          color: Color.fromARGB(255, 223, 222, 222),
                          width:1),
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Sized().sizedHeigth(20),
                            InputWidget(
                              textAlign:TextAlign.left,
                              name: 'firstname',
                              decoration:const  InputDecoration(
                                contentPadding: EdgeInsets.all(10),
                                label: Text("Nom"),
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
                            ]),),
                            Sized().sizedHeigth(20),
                           InputWidget(
                              textAlign:TextAlign.left,
                              name: 'lastname',
                              decoration:const  InputDecoration(
                                contentPadding: EdgeInsets.all(10),
                                label: Text("Nom de famille"),
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
                            ]),),
                            Sized().sizedHeigth(20),
                            IntlPhoneField(
                              //controller: phoneNumber,
                              focusNode: focusNode,
                              decoration: const InputDecoration(
                                labelStyle: TextStyle(
                                     fontWeight: FontWeight.w600,
                                    color: Colors.blue),
                                contentPadding: EdgeInsets.all(10),
                                label: Text("Numéro de Téléphone"),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color.fromRGBO(224, 224, 224, 1))),
                              ),
                              languageCode: "en",
                              initialCountryCode: 'ML',
                              disableAutoFillHints: true,
                              searchText: 'Choisis votre pays',
                              invalidNumberMessage: "Numéro de téléphone",
                              onChanged: (phone) {
                                //registerController.verifyPhone('+223'+phoneNumber.text);
                                phoneNumber = phone.completeNumber;
                                //Get.to(OtpScreen());
                              },
                              onCountryChanged: (country) {
                                print('Country changed to: ' + country.name);
                              },
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
                                              onTap: () async{
                                               
                                                if (_formKey.currentState?.saveAndValidate() ?? false) {
                                                  debugPrint(_formKey.currentState?.value
                                                      .toString());
                                                  debugPrint('validation');
                                                 
                                                  final map = _formKey.currentState!.value;
                                                
                                                  Contact newContact = Contact(
                                                    givenName: map['firstname'], // Set contact's first name
                                                    familyName: map['lastname'], // Set contact's last name
                                                    phones: [Item(label: 'mobile', value: phoneNumber)],
                                                  );

                                                  await ContactsService.addContact(newContact);
                                                  await ContactConfig().refreshContactsLocally();
                                                  await ContactConfig().loadAndgetConversation();
                                                  Get.snackbar(
                                                    '',
                                                    '',
                                                   
                                                    duration: const Duration(seconds: 3),
                                                    messageText: const Text(
                                                    'Contact est ajouter avec succes',
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 24
                                                      ),
                                                    ),
                                                    titleText: const Icon(Icons.check, color: Colors.green, size: 32,),
                                                  
                                                  );

                                                  Get.to(AddContactScreen());
                                                          
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
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}