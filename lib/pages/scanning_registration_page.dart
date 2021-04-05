
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covidcapstone/models/scanning_point.dart';
import 'package:covidcapstone/services/constants.dart';
import 'package:covidcapstone/widgets/alertdialog_adaptive.dart';
import 'package:covidcapstone/widgets/buttons/filled_button_adaptive.dart';
import 'package:covidcapstone/widgets/custom_scrollview_adaptive.dart';
import 'package:covidcapstone/widgets/inputs/input_dropdown_adaptive.dart';
import 'package:covidcapstone/widgets/inputs/text_field_adaptive.dart';
import 'package:covidcapstone/widgets/scaffold_adaptive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' as foundation;

bool get isIos => foundation.defaultTargetPlatform == foundation.TargetPlatform.iOS;


class ScanningRegistrationPage extends StatefulWidget {
  ScanningRegistrationPageState createState() => ScanningRegistrationPageState();
}

class ScanningRegistrationPageState extends State<ScanningRegistrationPage> {

  final ScanningPoint _scanningPoint = ScanningPoint();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

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

    List<Widget> first() {
      return [
        InputDropdownAdaptive(
          placeHolder: "Category",
          array: categories,
          context: context,
          validator: (value) => (value == null || value.isEmpty ? "This must not be empty" : null),
          selectedValue: _scanningPoint.category,
          onChanged: (value) => setState(() => _scanningPoint.category = value),
          selectedItemChanged: (value) => setState(() => _scanningPoint.category = categories[value]),
        ),
        TextFieldAdaptive(
            placeHolder: "Establishment/Office",
            textInputType: TextInputType.text,
            validator: (value) => (value.isEmpty ? "This must not be empty" : null),
            selectedValue: _scanningPoint.establishment,
            onSaved: (val) => setState(() => _scanningPoint.establishment = val)
        ),
        TextFieldAdaptive(
            placeHolder: "Telephone Number",
            textInputType: TextInputType.text,
            validator: (value) => (value.isEmpty ? "This must not be empty" : null),
            selectedValue: _scanningPoint.telephone,
            onSaved: (val) => setState(() => _scanningPoint.telephone = val)
        ),
        TextFieldAdaptive(
            placeHolder: "Email address",
            textInputType: TextInputType.emailAddress,
            validator: (value) => (value.isEmpty ? "This must not be empty" : null),
            selectedValue: _scanningPoint.email,
            onSaved: (val) => setState(() => _scanningPoint.email = val)
        ),
      ];
    }

    List<Widget> second() {
      return [
        TextFieldAdaptive(
            placeHolder: "Street/Building Address",
            textInputType: TextInputType.text,
            validator: (value) => (value.isEmpty ? "This must not be empty" : null),
            selectedValue: _scanningPoint.address,
            onSaved: (val) => setState(() => _scanningPoint.address = val)
        ),
        InputDropdownAdaptive(
          placeHolder: "Barangay",
          array: barangays,
          context: context,
          validator: (value) => (value == null || value.isEmpty ? "This must not be empty" : null),
          selectedValue: _scanningPoint.barangay,
          onChanged: (value) => setState(() => _scanningPoint.barangay = value),
          selectedItemChanged: (value) => setState(() => _scanningPoint.barangay = barangays[value]),
        ),
      ];
    }

    List<Widget> third() {
      return [
        TextFieldAdaptive(
            placeHolder: "Last Name",
            textInputType: TextInputType.text,
            validator: (value) => (value.isEmpty ? "This must not be empty" : null),
            selectedValue: _scanningPoint.lastName,
            onSaved: (val) => setState(() => _scanningPoint.lastName = val)
        ),
        TextFieldAdaptive(
            placeHolder: "First Name",
            textInputType: TextInputType.text,
            validator: (value) => (value.isEmpty ? "This must not be empty" : null),
            selectedValue: _scanningPoint.firstName,
            onSaved: (val) => setState(() => _scanningPoint.firstName = val)
        ),
        TextFieldAdaptive(
            placeHolder: "Middle Name",
            textInputType: TextInputType.text,
            validator: (value) => (value.isEmpty ? "This must not be empty" : null),
            selectedValue: _scanningPoint.middleName,
            onSaved: (val) => setState(() => _scanningPoint.middleName = val)
        ),
        TextFieldAdaptive(
            placeHolder: "Mobile Number",
            prefix: Text("+63"),
            maxLength: 10,
            textInputType: TextInputType.number,
            validator: (value) => (value.isEmpty ? "This must not be empty" : null),
            selectedValue: _scanningPoint.mobileNumber,
            onSaved: (val) => setState(() => _scanningPoint.mobileNumber = val)
        ),
      ];
    }

    List<Widget> fourth() {
      return [
        TextFieldAdaptive(
            placeHolder: "Username",
            textInputType: TextInputType.text,
            validator: (value) => (value.isEmpty ? "This must not be empty" : null),
            selectedValue: _scanningPoint.username,
            onSaved: (val) => setState(() => _scanningPoint.username = val)
        ),
        TextFieldAdaptive(
            placeHolder: "Password",
            textInputType: TextInputType.visiblePassword,
            validator: (value) => (value.isEmpty ? "This must not be empty" : null),
            selectedValue: _scanningPoint.password,
            onSaved: (val) => setState(() => _scanningPoint.password = val)
        ),
        TextFieldAdaptive(
            placeHolder: "Confirm Password",
            textInputType: TextInputType.visiblePassword,
            validator: (value) => (value.isEmpty ? "This must not be empty" : null),
            selectedValue: _scanningPoint.confirmPassword,
            onSaved: (val) => setState(() => _scanningPoint.confirmPassword = val)
        ),
      ];
    }

    void insert() async {
      final firestoreReference = FirebaseFirestore.instance;
      final scanningPoints = firestoreReference.collection("scanning_points");

      DocumentReference refScanning = await scanningPoints.add(_scanningPoint.toJson());
      Navigator.of(context).pop();

      AlertDialogAdaptive(
        title: "Registration",
        content: Text("Your registration has been successful. We will send you email for the Admin confirmation. Thank you"),
        buttons: [
          {
            "text": "Okay",
            "action": (){
              Navigator.pop(context);
              if(kIsWeb) {
                Navigator.of(context).pushNamedAndRemoveUntil("/landing", (route) => false);
              }else {
                Navigator.of(context).pushNamedAndRemoveUntil("/homePage", (route) => false);
              }
            }
          },
        ],
      ).show(context);

    }

    Widget myForm(BoxConstraints constraints) {
      return Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("QR Scanning Point", style: kSubtitleStyle,),
            SizedBox(height: 25,),
            layout(constraints, first()),
            layout(constraints, second()),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                color: Colors.black38,
                height: 0.5,
              ),
            ),
            SizedBox(height: 10,),
            layout(constraints, third()),
            SizedBox(height: 25,),
            Divider(
              color: Colors.black38,
              height: 0.5,
            ),
            SizedBox(height: 15,),
            Text("Account Information", style: kSubtitleStyle,),
            SizedBox(height: 25,),
            layout(constraints, fourth()),
            SizedBox(height: 15,),
            Center(
              child: FilledButtonAdaptive(color: buttonColor, text: "Submit Form", tapEvent: () {
                if (_formKey.currentState.validate()) {
                  if(isIos && _scanningPoint.notComplete()) {
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

                  if(_scanningPoint.password != _scanningPoint.confirmPassword) {
                    AlertDialogAdaptive(
                      title: "Invalid",
                      content: Text("Password does not match."),
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

                  AlertDialogAdaptive(
                    title: "Please wait",
                    barrierDismissible: false,
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Signing you up for QR Scanning Point."),
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

                  insert();

                }
              }),
            ),
          ],
        ),
      );
    }

    return ScaffoldAdaptive(
      isIncludeBottomBarAndroid: false,
      child: CustomScrollviewAdaptive(
        icon: SizedBox(),
        title: "Scanning Registration",
        widgets: [
          LayoutBuilder(
            builder: (context, constraints) {
              return Wrap(
                alignment: WrapAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 15, horizontal: constraints.maxWidth >= 600 ? 30 : 20 ),
                    constraints: BoxConstraints(maxWidth: 1250),
                    child: constraints.maxWidth >= 600 ? Card(
                      elevation: 1,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                        child: myForm(constraints),
                      ),
                    ) : myForm(constraints),
                  )
                ],
              );
            },
          )
        ]
      )
    );
  }

}