

import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covidcapstone/services/constants.dart';
import 'package:covidcapstone/widgets/alertdialog_adaptive.dart';
import 'package:covidcapstone/widgets/buttons/filled_button_adaptive.dart';
import 'package:covidcapstone/widgets/scaffold_adaptive.dart';
import 'package:covidcapstone/widgets/scrollbar_adaptive.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:url_launcher/url_launcher.dart';

bool get isIos => foundation.defaultTargetPlatform == foundation.TargetPlatform.iOS;

class SuccessPage extends StatefulWidget {

  final Object arguments;

  const SuccessPage({Key key, @required this.arguments}) : super(key: key);

  SuccessPageState createState() => SuccessPageState(arguments);
}

class SuccessPageState extends State<SuccessPage> {
  final Object arguments;
  SuccessPageState(this.arguments);

  final GlobalKey _globalKey = new GlobalKey();
  String fileName = "_Pass_ID.png";

  bool loading = false, isDownloaded = false;
  Uint8List qrCache;

  @override
  Widget build(BuildContext context) {
    if(!kIsWeb) {
      FlutterStatusbarcolor.setStatusBarColor(appColor);
      FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
    }

    Map<String, dynamic> finalArguments = this.arguments;

    if(finalArguments["isChecking"] == null || finalArguments["isChecking"] == false) {
      addStringToSF("id_number", finalArguments["id_number"].toString());
    }
    fileName = finalArguments["id_number"].toString() + "_Pass_ID.png";

    Widget cBorder({bool top = false, bool left = false, bool bottom = false, bool right = false}) {
      Color color = mainColor;
      double width = 3;
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          height: 20,
          width: 20,
          decoration: BoxDecoration(
            border: Border(
              top: top ? BorderSide(
                color: color,
                width: width
              ) : BorderSide(
                color: Colors.transparent
              ),
              left: left ? BorderSide(
                color: color,
                width: width
              ) : BorderSide(color: Colors.transparent),
              bottom: bottom ? BorderSide(
                color: color,
                width: width
              ) : BorderSide(color: Colors.transparent),
              right : right ? BorderSide(
                color: color,
                width: width
              ): BorderSide(color: Colors.transparent)
            ),
          ),
        ),
      );
    }

    Future<Uint8List> _captureQRPass() async {
      try {
        RenderRepaintBoundary boundary =
        _globalKey.currentContext.findRenderObject();
        ui.Image image = await boundary.toImage(pixelRatio: 3.0);
        ByteData byteData =
        await image.toByteData(format: ui.ImageByteFormat.png);
        Uint8List pngBytes = byteData.buffer.asUint8List();
        print('png done');
        return pngBytes;
      } catch (e) {
        print(e);
        return null;
      }
    }

    Future<bool> _saveNetworkImage(String url) async {

      bool allow = await (Platform.isAndroid ? requestPermission(Permission.storage) : requestPermission(Permission.photos));
      if(!allow) {
        AlertDialogAdaptive(
          title: "Download Failed",
          barrierDismissible: true,
          content: Text("Please allow the photo permission for Naggapwam App in the Settings."),
          buttons: [
            {
              "text": "Okay",
              "action": () {
                Navigator.pop(context);
              }
            },
          ],
        ).show(context);
        return false;
      }
      var imageId = await ImageDownloader.downloadImage(url);
      if (imageId == null) {
        print('IMAGE IS NOT SAVED');
        return false;
      }else {
        print("Image is saved");
        return true;
      }
    }

    Future<bool> downloadFile(String url, String file_name) async {
      bool downloaded = await _saveNetworkImage(url);
      if (downloaded) {
        print("File Downloaded");
        return true;
      } else {
        print("Problem Downloading File");
        return false;
      }
    }

    Future<String> uploadFile(Uint8List finalImage) async {
      final Reference ref = FirebaseStorage.instance.ref().child('images').child(fileName);
      final UploadTask uploadTask = ref.putData(finalImage);
      final TaskSnapshot taskSnapshot = await uploadTask;
      final url = await taskSnapshot.ref.getDownloadURL();
      print("Done: $url");

      final firestoreReference = FirebaseFirestore.instance;
      final citizens = firestoreReference.collection("citizens");
      await citizens.doc(finalArguments["id_number"].toString()).update({
        "qr_pass_url": url
      });

      return url;
    }

    Future<bool> finalUpload() async {
      if(loading) {
        String downloadUrl = await uploadFile(qrCache);
        bool result = false;
        if(kIsWeb) {
          launch(downloadUrl);
          result = true;
        }else {
          result = await downloadFile(downloadUrl, fileName);
        }

        if(result) {
          setState(() {
            loading = false;
            qrCache = null;
            isDownloaded = true;
            Navigator.of(context).pop();
            AlertDialogAdaptive(
              title: "Done",
              barrierDismissible: true,
              content: Text("QR code successfully downloaded. Your QR Pass ID has been saved in "+ (kIsWeb ? 'Downloads' : 'Photos') +"."),
              buttons: [
                {
                  "text": "Okay",
                  "action": () {
                    Navigator.pop(context);
                  }
                },
              ],
            ).show(context);
          });
        }
        return result;

      }else {
        return false;
      }
    }

    Widget qrPass() {
      return RepaintBoundary(
        key: _globalKey,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: EdgeInsets.all(15),
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(finalArguments["name"], style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w600)),
                Text(finalArguments["address"], style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w300)),
                SizedBox(height: 30,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    cBorder(top: true, left: true),
                    cBorder(top: true, right: true)
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: QrImage(
                    data: finalArguments["id_number"].toString(),
                    version: QrVersions.auto,
                    size: 250,
                    gapless: false,
                    embeddedImage: AssetImage('assets/images/logo.png'),
                    embeddedImageStyle: QrEmbeddedImageStyle(
                      size: Size(80, 80),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    cBorder(left: true, bottom: true),
                    cBorder(right: true, bottom: true)
                  ],
                ),
                SizedBox(height: 15,),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("NAGGAPWAM QR PASS ID", style: TextStyle(color: navColor, fontSize: 17,
                          fontWeight: FontWeight.w700),),
                      Text(tagline)
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Image(image: AssetImage('assets/images/la_union_logo.png')),
                        width: 80,
                        height: 70,
                      ),
                      Container(
                        child: Image(image: AssetImage('assets/images/doh_logo.png')),
                        width: 80,
                        height: 70,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }

    void downloadQrPass() async {
      AlertDialogAdaptive(
        title: "Please wait",
        barrierDismissible: false,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Downloading you a NAGGAPWAM QR Pass ID."),
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

      var cache = await _captureQRPass();
      setState(() {
        qrCache = cache;
        loading = true;
      });
    }

    if(loading && qrCache != null) {
      finalUpload();
    }

    bool isNumeric(String s) {
      if (s == null) {
        return false;
      }
      return double.tryParse(s) != null;
    }

    String convertFirestoreId(String firestoreId) {
      String result = "";
      firestoreId.substring(0, 4).split('').forEach((element) {
        if(isNumeric(element)) {
          result += element;
        }else {
          result += (element.codeUnitAt(0)).toString();
        }
      });
      return result;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return ScaffoldAdaptive(
          backgroundColor: appColor,
          isIncludeBottomBarAndroid: false,
          child: ScrollbarAdaptive(
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: (isIos? 10 : 20),),
                      (finalArguments["isChecking"] == null ? Icon((isIos ? CupertinoIcons.checkmark_circle : Icons.check_circle_outline_outlined),
                        color: (isIos ? CupertinoColors.activeGreen : Colors.green), size: 100,) :
                      SizedBox()),
                      SizedBox(height: 10,),
                      Text(finalArguments["isChecking"] == null ? "Registration Successful!" : "Status", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800), textAlign: TextAlign.center,),
                      SizedBox(height: 10,),
                      Text("NAGGAPWAM ID Number:", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(convertFirestoreId(finalArguments["id_number"].toString()), style: TextStyle(color: darkColor, fontSize: 16, fontWeight: FontWeight.w500),),
                          IconButton(icon: Icon(isIos ? CupertinoIcons.doc_on_clipboard : Icons.copy), color: mainColor, onPressed: () {
                            Clipboard.setData(new ClipboardData(text: convertFirestoreId(finalArguments["id_number"].toString())));
                            AlertDialogAdaptive(
                              title: "Naggapwam ID",
                              content: Text("ID Copied to clipboard"),
                              buttons: [
                                {
                                  "text": "Done",
                                  "action": () => Navigator.pop(context)
                                },
                              ],
                            ).show(context);
                          })
                        ],
                      ),
                      SizedBox(height: 25,),
                      Wrap(
                        alignment: WrapAlignment.center,
                        children: [
                          Container(
                            constraints: BoxConstraints(maxWidth: 400, minWidth: 300),
                            child: qrPass(),
                          )
                        ],
                      ),
                      SizedBox(height: 10,),
                      Container(
                        width: kIsWeb ? 270 : double.infinity,
                        child: OutlinedButton(
                          onPressed: () async {
                            if(isDownloaded) {
                              AlertDialogAdaptive(
                                title: "Downloaded",
                                barrierDismissible: false,
                                content: Text("You've already download your QR pass ID. Are you sure you want to download again?"),
                                buttons: [
                                  {
                                    "text": "Cancel",
                                    "action": () {
                                      Navigator.pop(context);
                                    }
                                  },
                                  {
                                    "text": "Yes",
                                    "action": () {
                                      Navigator.pop(context);
                                      downloadQrPass();
                                    }
                                  },
                                ],
                              ).show(context);
                            }else {
                              downloadQrPass();
                            }
                          },
                          child: Text(!kIsWeb ? "Download QR Pass" : "Download QR Pass".toUpperCase(), style: TextStyle(color: darkColor, fontSize: 18),),
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            side: BorderSide(width: 2, color: darkColor),
                          ),
                        ),
                      ),
                      SizedBox(height: 10,),
                      FilledButtonAdaptive(text: "Done", tapEvent: () async {

                        if(finalArguments["isChecking"] == null) {
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

                          await uploadFile(qrCache == null ? await _captureQRPass() : qrCache);
                        }

                        if(kIsWeb) {
                          Navigator.of(context).pushNamedAndRemoveUntil('/landing', (route) => false);
                        }else {
                          Navigator.of(context).pushNamedAndRemoveUntil('/homePage', (route) => false);
                        }
                      }, color: mainColor,),
                      SizedBox(height: 15,),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }
    );
  }

}