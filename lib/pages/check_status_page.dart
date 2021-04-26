

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covidcapstone/models/citizen.dart';
import 'package:covidcapstone/models/status.dart';
import 'package:covidcapstone/pages/qr_registration_page.dart';
import 'package:covidcapstone/services/constants.dart';
import 'package:covidcapstone/widgets/alertdialog_adaptive.dart';
import 'package:covidcapstone/widgets/buttons/filled_button_adaptive.dart';
import 'package:covidcapstone/widgets/custom_scrollview_adaptive.dart';
import 'package:covidcapstone/widgets/inputs/date_picker_adaptive.dart';
import 'package:covidcapstone/widgets/inputs/text_field_adaptive.dart';
import 'package:covidcapstone/widgets/scaffold_adaptive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';

bool get isIos => foundation.defaultTargetPlatform == foundation.TargetPlatform.iOS;

class CheckStatusPage extends StatefulWidget {
  CheckStatusPageState createState() => CheckStatusPageState();
}

class CheckStatusPageState extends State<CheckStatusPage> {

  final _formKey = GlobalKey<FormState>();
  final Status _status = Status();

  @override
  Widget build(BuildContext context) {
    final firestoreReference = FirebaseFirestore.instance;
    final citizens = firestoreReference.collection("citizens");

    void callbackDate(DateTime datePicked) {
      setState(() => this._status.birthday = datePicked);
    }

    Widget myForm() {
      return Wrap(
        alignment: WrapAlignment.center,
        children: [
          Container(
            constraints: BoxConstraints(maxWidth: 500),
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Check Individual QR Pass Status", style: kSubtitleStyle,),
                  SizedBox(height: 10,),
                  Text("(Provided when you submitted your registration)", style: TextStyle(color: navColor),),
                  SizedBox(height: 5,),
                  TextFieldAdaptive(
                      placeHolder: "Naggapwam ID number",
                      textInputType: TextInputType.text,
                      validator: (value) => (value.isEmpty ? "This must not be empty" : null),
                      selectedValue: _status.id,
                      onSaved: (val) => setState(() => _status.id = val)
                  ),
                  SizedBox(height: 30,),
                  DatePickerAdaptive(
                    placeHolder: "Birthday",
                    buildContext: context,
                    selectedDate: this._status.birthday,
                    onDateTimeChanged: (date) => callbackDate(date),
                    onDateTimeChangedAndroid: callbackDate,
                  ),
                  SizedBox(height: 15,),
                  TextFieldAdaptive(
                      placeHolder: "Mobile Number",
                      prefix: Text("+63"),
                      maxLength: 10,
                      textInputType: TextInputType.number,
                      validator: (value) => (value.isEmpty ? "This must not be empty" : null),
                      selectedValue: _status.phoneNumber,
                      onSaved: (val) => setState(() => _status.phoneNumber = val)
                  ),
                  SizedBox(height: 15,),
                  FilledButtonAdaptive(color: buttonColor, text: "Submit Form", tapEvent: () async {

                    if(isIos && _status.notComplete()) {
                      AlertDialogAdaptive(
                        title: "Incomplete",
                        content: Text("Please make sure to complete the Form to proceed."),
                        buttons: [
                          {
                            "text": "Cancel",
                            "action": (){
                              Navigator.pop(context);
                            }
                          },
                        ],
                      ).show(context);
                      return false;
                    }

                    if (_formKey.currentState.validate()) {
                      AlertDialogAdaptive(
                        title: "Please wait",
                        barrierDismissible: false,
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("Checking the status of QR Pass ID."),
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
                      final DocumentSnapshot snapshot = await citizens.doc(isDeveloping ? "0joqQosr7VjMHlklYtk3" : _status.id).get();
                      Navigator.of(context).pop();
                      if(!snapshot.exists) {
                        AlertDialogAdaptive(
                          title: "Not found",
                          content: Text("The user does not exist yet."),
                          buttons: [
                            {
                              "text": "Okay",
                              "action": (){
                                Navigator.pop(context);
                              }
                            },
                          ],
                        ).show(context);
                        return false;
                      }
                      final Citizen _citizen = Citizen();
                      _citizen.fromSnapshot(snapshot);
                      Navigator.of(context).pushNamed("/successPage", arguments: {
                        "name": capitalize(_citizen.firstname) + " " +
                            capitalize(_citizen.middlename.substring(0, 1)) + ". " +
                            capitalize(_citizen.lastname),
                        "address": _citizen.barangay,
                        "id_number": _citizen.id,
                        "isChecking": true
                      });
                    }

                  })

                ],
              ),
            ),
          )
        ],
      );
    }

    return ScaffoldAdaptive(
      isIncludeBottomBarAndroid: false,
      child: CustomScrollviewAdaptive(
        icon: SizedBox(),
        title: "QR Pass Status",
        widgets: [
          SizedBox(height: 20,),
          myForm()
        ]
      )
    );
  }
  
}