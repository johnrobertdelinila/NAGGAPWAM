
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covidcapstone/models/citizen.dart';
import 'package:covidcapstone/services/constants.dart';
import 'package:covidcapstone/widgets/alertdialog_adaptive.dart';
import 'package:covidcapstone/widgets/buttons/filled_button_adaptive.dart';
import 'package:covidcapstone/widgets/inputs/date_picker_adaptive.dart';
import 'package:covidcapstone/widgets/inputs/input_dropdown_adaptive.dart';
import 'package:covidcapstone/widgets/inputs/text_field_adaptive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/foundation.dart' as foundation;

bool get isIos => foundation.defaultTargetPlatform == foundation.TargetPlatform.iOS;

class CitizenFormPage extends StatefulWidget {
  final Citizen citizen;
  final formKey;

  const CitizenFormPage({Key key, @required this.citizen, @required this.formKey}) : super(key: key);
  @override
  CitizenFormPageState createState() => CitizenFormPageState(this.citizen, this.formKey);

}

class CitizenFormPageState extends State<CitizenFormPage> {

  final _formKey;
  Citizen _citizen;
  CitizenFormPageState(this._citizen, this._formKey);
  bool isShown = false;

  void callbackDate(DateTime datePicked) {
    setState(() => this._citizen.birthday = datePicked);
  }

  @override
  Widget build(BuildContext context) {

    if(this._citizen.birthday == null) {
      DateTime now = DateTime.now();
      this._citizen.birthday = DateTime(now.year, now.month, now.day);
    }

    Future.delayed(Duration(milliseconds: 700), () {
      if(!isShown) {
        AlertDialogAdaptive(
          title: "Notice",
          barrierDismissible: true,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(isIos ? CupertinoIcons.info_circle : Icons.info_outline, size: 30,),
              Text(disclaimer_registration.replaceAll(" and wait to get verified", "")),
            ],
          ),
          buttons: [
            {
              "text": "Okay",
              "action": () {
                Navigator.pop(context);
              }
            },
          ],
        ).show(context);
        setState(() {
          isShown = true;
        });
      }
    });

    List<Widget> first() {
      return [
        TextFieldAdaptive(
            placeHolder: "Last Name",
            textInputType: TextInputType.text,
            validator: (value) => (value.isEmpty ? "This must not be empty" : null),
            selectedValue: _citizen.lastname,
            onSaved: (val) => setState(() => _citizen.lastname = val)
        ),
        TextFieldAdaptive(
            placeHolder: "First Name",
            textInputType: TextInputType.text,
            validator: (value) => (value.isEmpty ? "This must not be empty" : null),
            selectedValue: _citizen.firstname,
            onSaved: (val) => setState(() => _citizen.firstname = val)
        ),
        TextFieldAdaptive(
            placeHolder: "Middle Name",
            textInputType: TextInputType.text,
            validator: (value) => (value.isEmpty ? "This must not be empty" : null),
            selectedValue: _citizen.middlename,
            onSaved: (val) => setState(() => _citizen.middlename = val)
        ),
      ];
    }

    List<Widget> second() {
      return [
        InputDropdownAdaptive(
          placeHolder: "Gender",
          array: genders,
          context: context,
          validator: (value) => (value == null || value.isEmpty ? "This must not be empty" : null),
          selectedValue: this._citizen.gender,
          onChanged: (value) => setState(() => this._citizen.gender = value),
          selectedItemChanged: (value) => setState(() => this._citizen.gender = genders[value]),
        ),
        DatePickerAdaptive(
          placeHolder: "Birthday",
          buildContext: context,
          selectedDate: this._citizen.birthday,
          onDateTimeChanged: (date) => callbackDate(date),
          onDateTimeChangedAndroid: callbackDate,
        ),
      ];
    }

    List<Widget> third() {
      return [
        TextFieldAdaptive(
            placeHolder: "Phone Number",
            prefix: Text("+63"),
            maxLength: 10,
            textInputType: TextInputType.number,
            validator: (value) => (value.isEmpty ? "This must not be empty" : null),
            selectedValue: _citizen.phoneNumber,
            onSaved: (val) => setState(() => _citizen.phoneNumber = val)
        ),
        TextFieldAdaptive(
            placeHolder: "Email Address",
            textInputType: TextInputType.emailAddress,
            validator: (value) => (value.isEmpty ? "This must not be empty" : null),
            selectedValue: _citizen.email,
            onSaved: (val) => setState(() => _citizen.email = val)
        ),
        InputDropdownAdaptive(
          placeHolder: "Barangay",
          array: barangays,
          context: context,
          validator: (value) => (value == null || value.isEmpty ? "This must not be empty" : null),
          selectedValue: this._citizen.barangay,
          onChanged: (value) => setState(() => this._citizen.barangay = value),
          selectedItemChanged: (value) => setState(() => this._citizen.barangay = barangays[value]),
        ),
      ];
    }

    List<Widget> fourth() {
      return [
        TextFieldAdaptive(
            placeHolder: "Contact Person",
            textInputType: TextInputType.text,
            validator: (value) => (value.isEmpty ? "This must not be empty" : null),
            selectedValue: _citizen.contact_person,
            onSaved: (val) => setState(() => _citizen.contact_person = val)
        ),
        InputDropdownAdaptive(
          placeHolder: "Relationship",
          array: relationships,
          context: context,
          selectedValue: this._citizen.relationship,
          onChanged: (value) => setState(() => this._citizen.relationship = value),
          selectedItemChanged: (value) => setState(() => this._citizen.relationship = relationships[value]),
        ),
        TextFieldAdaptive(
            placeHolder: "Contact Person mobile number",
            prefix: Text("+63"),
            maxLength: 10,
            textInputType: TextInputType.number,
            validator: (value) => (value.isEmpty ? "This must not be empty" : null),
            selectedValue: _citizen.contact_person_number,
            onSaved: (val) => setState(() => _citizen.contact_person_number = val)
        ),
      ];
    }

    List<Widget> fifth() {
      return [
        TextFieldAdaptive(
            placeHolder: "Contact Person Address",
            textInputType: TextInputType.text,
            validator: (value) => (value.isEmpty ? "This must not be empty" : null),
            selectedValue: _citizen.contact_person_address,
            onSaved: (val) => setState(() => _citizen.contact_person_address = val)
        ),
      ];
    }

    Widget layout(BoxConstraints constraints, List<Widget> widgets) {
      if(constraints.maxWidth <= 600) {
        // Mobile layout
        return Column(
          children: List<Widget>.generate(widgets.length, (index) {
            return Padding(padding: EdgeInsets.only(bottom: 15), child: widgets[index],);
          }),
        );
      }else {
        return Row(
          children: List<Widget>.generate(widgets.length, (int index) {
            return Expanded(
              flex: 1,
              child: Padding(padding: EdgeInsets.only(left: 8, right: 8, bottom: 15), child: widgets[index]),
            );
          }),
        );
      }
    }

    Widget form(BoxConstraints constraints) {
      return Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Registration Form", style: kSubtitleStyle,),
            SizedBox(height: 25,),
            layout(constraints, first()),
            layout(constraints, second()),
            layout(constraints, third()),
            layout(constraints, fourth()),
            layout(constraints, fifth()),
            (!kIsWeb ?
              Padding(
                padding: EdgeInsets.only(top: 25),
                child: Center(
                  child: FilledButtonAdaptive(color: buttonColor, text: "Continue", tapEvent: () async {

                    if(isIos && _citizen.notComplete()) {
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
                      
                      CollectionReference citizens = FirebaseFirestore.instance.collection("citizens");
                      QuerySnapshot query = await citizens
                        .where("firstname", isEqualTo: _citizen.firstname)
                        .where("middlename", isEqualTo: _citizen.middlename)
                        .where("lastname", isEqualTo: _citizen.lastname)
                        .get();

                      Navigator.of(context).pop();

                      if(query.size > 0) {
                        AlertDialogAdaptive(
                          title: "Duplicate Registration",
                          barrierDismissible: true,
                          content: Text("Existing registration found. Please contact the NAGGAPWAM HOTLINE or send your queries to NAGGAPWAM FB page."),
                          buttons: [
                            {
                              "text": "Okay",
                              "action": () {
                                Navigator.pop(context);
                              }
                            },
                          ],
                        ).show(context);
                      }else {
                        Navigator.of(context).pushNamed("/healthDeclaration", arguments: _citizen);
                      }
                    }

                  }),
                ),
              ) : SizedBox())
          ],
        ),
      );
    }

    return LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            margin: EdgeInsets.symmetric(vertical: 15, horizontal: constraints.maxWidth >= 600 ? 30 : 20 ),
            child: constraints.maxWidth >= 600 ? Card(
              elevation: 1,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                child: form(constraints),
              ),
            ) : form(constraints),
          );
        }
    );
  }

}