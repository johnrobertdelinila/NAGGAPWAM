
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covidcapstone/services/constants.dart';
import 'package:covidcapstone/widgets/action_sheet_adaptive.dart';
import 'package:covidcapstone/widgets/alertdialog_adaptive.dart';
import 'package:covidcapstone/widgets/buttons/text_button_adaptive.dart';
import 'package:covidcapstone/widgets/scrollbar_adaptive.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';
import 'package:stacked/stacked.dart';
import 'package:toast/toast.dart';

import 'confirm_report_view_model.dart';

import 'package:flutter/foundation.dart' as foundation;

bool get isIosss => foundation.defaultTargetPlatform == foundation.TargetPlatform.iOS;

class ConfirmReportView extends StatefulWidget {
  ConfirmReportViewState createState() => ConfirmReportViewState();
}


class ConfirmReportViewState extends State<ConfirmReportView> {

  File selectedImage;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
      builder: (context, model, child) => MaterialApp(
        builder: (context, widget) {

          Future getImageFromCamera() async {
            File image = await ImagePicker.pickImage(
                source: ImageSource.camera, imageQuality: 30);
            setState(() {
              selectedImage = image;
            });
            Navigator.pop(context);
          }

          Future getImageFromGallery() async {
            File image = await ImagePicker.pickImage(
                source: ImageSource.gallery, imageQuality: 30);
            setState(() {
              selectedImage = image;
            });
            Navigator.pop(context);
          }

          return Scaffold(
            appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0.0,
                leading: Builder(
                  builder: (BuildContext context) {
                    return IconButton(
                      icon: FaIcon(
                        FontAwesomeIcons.virus,
                        color: appColor,
                      ),
                    );
                  },
                ),
                actions: <Widget>[
                  // action button
                  IconButton(
                    icon: Icon(isIosss ? CupertinoIcons.clear : Icons.close),
                    color: Color(0xFF686868),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ]),
            body: ScrollbarAdaptive(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 40,
                      ),
                      Text(
                        'Have you tested positive for COVID-19?',
                        textAlign: TextAlign.left,
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Container(
                        padding: EdgeInsets.all(15.0),
                        decoration: BoxDecoration(
                            border: Border.all(color: appColor),
                            borderRadius: BorderRadius.circular(5.0)),
                        child: Column(
                          children: <Widget>[
                            Text(
                              'Please confirm your test results',
                              textAlign: TextAlign.left,
                              style: Theme.of(context).textTheme.headline6,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              'This report is completely anonymous and the community relies on you to be truthful and responsible. Depending on anoymous interaction logs, other Naggapwam users may get notified to self-quarantine and get tested.',
                              textAlign: TextAlign.left,
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              'COVID-19 Test',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'POSITIVE',
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4
                                  .apply(color: Colors.red[400]),
                            ),
                            SizedBox(
                              height: 10,
                            ),

                            TextButtonAdaptive(
                              text: 'UPLOAD MEDICAL CERTIFICATE',
                              tapEvent: () {

                                final title = "Document upload";
                                final message = "Upload proof that your are indeed positive of COVID-19.";
                                final msg = Text(message);
                                final buttons = [
                                  {
                                    "text": "Camera",
                                    "action": (){
                                      // Navigator.pop(context);
                                      getImageFromCamera();
                                    }
                                  },
                                  {
                                    "text": "Photo Library",
                                    "action": (){
                                      // Navigator.pop(context);
                                      getImageFromGallery();
                                    }
                                  },
                                ];

                                ActionSheetAdaptive(
                                  title: title,
                                  message: message,
                                  isIncludeCancel: true,
                                  buttons: buttons,
                                ).show(context);
                              },
                            ),

                            (selectedImage != null
                              ? Container(
                                height: 100.0,
                                width: 150.0,
                                decoration: new BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: new BorderRadius.all(
                                      Radius.circular(15.0),
                                    )),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: new Image.file(selectedImage, fit: BoxFit.cover)))
                            : Container()),

                            SizedBox(
                              height: 40,
                            ),
                            ConfirmationSlider(
                              //width: double.maxFinite,
                              backgroundShape: BorderRadius.circular(5.0),
                              foregroundShape: BorderRadius.circular(5.0),
                              foregroundColor: appColor,
                              onConfirmation: () async {
                                if(selectedImage != null) {

                                  AlertDialogAdaptive(
                                    title: "Please wait",
                                    barrierDismissible: false,
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text("....."),
                                        Padding(
                                          padding: EdgeInsets.only(top: 15),
                                          child: (isIosss ? CupertinoActivityIndicator(
                                            animating: true,
                                            radius: 20,
                                          ) : CircularProgressIndicator()),
                                        )
                                      ],
                                    ),
                                    buttons: [],
                                  ).show(context);

                                  String value = await getStringValuesSF("token");
                                  String uid = await getStringValuesSF("id_number");
                                  if(value != null && uid != null) {
                                    FirebaseFirestore.instance.collection("exposure").doc(uid).set({
                                      "exception": value,
                                      "status": "Suspected"
                                    })
                                        .then((val) async {
                                          final Reference ref = FirebaseStorage.instance.ref().child('images').child(uid);
                                          final UploadTask uploadTask = ref.putFile(selectedImage);
                                          final TaskSnapshot taskSnapshot = await uploadTask;
                                          final url = await taskSnapshot.ref.getDownloadURL();
                                          FirebaseFirestore.instance.collection("exposure").doc(uid).set({
                                            "url": url
                                          }, SetOptions(merge: true));
                                          Navigator.of(context).pushNamedAndRemoveUntil("/confirmSuccess", (route) => false);
                                        })
                                        .catchError((onError) => print(onError));
                                  }
                                }else {
                                  Toast.show("Upload documents for your medical certificate.", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                                }
                              },
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            ButtonTheme(
                              minWidth: double.maxFinite,
                              height: 58.0,
                              child: OutlineButton(
                                onPressed: () {
                                  Navigator.of(context).pushNamedAndRemoveUntil("/homePage", (route) => false);
                                },
                                borderSide: new BorderSide(
                                    width: 1.0, color: Color(0xFF686868)),
                                shape: new RoundedRectangleBorder(
                                    borderRadius: new BorderRadius.circular(5.0)),
                                child: Text(
                                  "Cancel".toUpperCase(),
                                  style: Theme.of(context).textTheme.button.apply(
                                    color: Color(0xFF686868),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
      viewModelBuilder: () => ConfirmReportViewModel(),
    );
  }
}
