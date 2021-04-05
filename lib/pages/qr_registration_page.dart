

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covidcapstone/models/citizen.dart';
import 'package:covidcapstone/models/health_declaration.dart';
import 'package:covidcapstone/pages/citizen_form_page.dart';
import 'package:covidcapstone/services/constants.dart';
import 'package:covidcapstone/widgets/alertdialog_adaptive.dart';
import 'package:covidcapstone/widgets/buttons/filled_button_adaptive.dart';
import 'package:covidcapstone/widgets/custom_scrollview_adaptive.dart';
import 'package:covidcapstone/widgets/scaffold_adaptive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'health_declaration_page.dart';
import 'package:flutter/foundation.dart' as foundation;

bool get isIos => foundation.defaultTargetPlatform == foundation.TargetPlatform.iOS;

class QrRegistrationPage extends StatelessWidget {

  final _formKeyCitizen = GlobalKey<FormState>();
  final _formKeyHdf = GlobalKey<FormState>();

  final Citizen _citizen = Citizen();
  final HealthDeclaration _hdf = HealthDeclaration();

  String capitalize(String str) {
    return "${str[0].toUpperCase()}${str.substring(1)}";
  }

  void insert(Citizen citiz, HealthDeclaration hd, BuildContext context) async {
    final firestoreReference = FirebaseFirestore.instance;
    final citizens = firestoreReference.collection("citizens");
    final healthDeclarations = firestoreReference.collection("hdf");

    DocumentReference refCitizen = await citizens.add(citiz.toJson());
    await healthDeclarations.doc(refCitizen.id).set(hd.toJson());
    Navigator.of(context).pop();
    Navigator.of(context).pushNamedAndRemoveUntil("/successPage", (route) => false, arguments: {
      "name": capitalize(citiz.firstname) + " " + capitalize(citiz.middlename.substring(0, 1)) + ". " + capitalize(citiz.lastname),
      "address": citiz.barangay,
      "id_number": refCitizen.id
    });
  }

  @override
  Widget build(BuildContext context) {

    return ScaffoldAdaptive(
      isIncludeBottomBarAndroid: false,
      child: CustomScrollviewAdaptive(
        icon: SizedBox(),
        title: "QR Pass Registration",
        widgets: [
          Wrap(
            alignment: WrapAlignment.center,
            children: [
              Container(
                constraints: BoxConstraints(maxWidth: 1240),
                child: Column(
                  children: [
                    CitizenFormPage(citizen: _citizen, formKey: _formKeyCitizen,),
                    (kIsWeb ? HealthDeclarationPage(hdf: _hdf, formKey: _formKeyHdf, citizen: _citizen,) : SizedBox()),
                    (kIsWeb ? Padding(
                      padding: EdgeInsets.only(top: 25, bottom: 25),
                      child: Center(
                        child: FilledButtonAdaptive(color: buttonColor, text: "Submit Form", tapEvent: () {
                          if (_formKeyCitizen.currentState.validate() && _formKeyHdf.currentState.validate()) {
                            if(!_hdf.haveRead) {
                              AlertDialogAdaptive(
                                title: "Terms and Condition",
                                content: Text("Make sure that you've agree to the Terms, Conditions and Privacy Policy."),
                                buttons: [
                                  {
                                    "text": "Okay",
                                    "action": (){
                                      Navigator.pop(context);
                                    }
                                  },
                                ],
                              ).show(context);
                            }else {
                              AlertDialogAdaptive(
                                title: "Please wait",
                                barrierDismissible: false,
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text("Creating you a NAGGAPWAM QR Pass ID."),
                                    Padding(
                                      padding: EdgeInsets.only(top: 15),
                                      child: (isIos ? CupertinoActivityIndicator(
                                        animating: true,
                                        radius: 20,
                                      ) : CircularProgressIndicator()),
                                    )
                                  ],
                                ),
                                buttons: [],
                              ).show(context);
                              insert(_citizen, _hdf, context);
                            }
                          }
                        }),
                      ),
                    ): SizedBox())
                  ],
                ),
              )
            ]
          )
        ]
      ),
    );
  }

}