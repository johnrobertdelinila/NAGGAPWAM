
// Uncomment this when building web

// import 'dart:html';
// import 'dart:ui' as ui;

import 'package:covidcapstone/services/constants.dart';
import 'package:covidcapstone/widgets/alertdialog_adaptive.dart';
import 'package:covidcapstone/widgets/scaffold_adaptive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';


class QrScanPage extends StatefulWidget {
  @override
  QRScanPageState createState() => QRScanPageState();
}

class QRScanPageState extends State<QrScanPage> {

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final String keyCamWeb = 'hello-world-html';

  QRViewController controller;
  Barcode result;

  Widget forMobile() {

    var scanArea = (MediaQuery.of(context).size.width < 400 ||
        MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;

    return FutureBuilder(
      future: requestPermission(Permission.camera),
      builder: (context, snapshot) {
        if(snapshot.hasError) {
          print(snapshot.error);
          return Center(child: Text("Something went wrong."));
        }else if(snapshot.hasData) {
          if(snapshot.data == true) {
            return QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
                overlay: QrScannerOverlayShape(
                    borderColor: Colors.red,
                    borderRadius: 10,
                    borderLength: 30,
                    borderWidth: 10,
                    cutOutSize: scanArea)
            );
          }else {
            AlertDialogAdaptive(
              title: "Scanning Unavailable",
              barrierDismissible: true,
              content: Text("This app does not have permission to access the camera"),
              buttons: [
                {
                  "text": "Okay",
                  "action": () {
                    Navigator.pop(context);
                  }
                },
              ],
            ).show(context);
            return Center(child: Text("Please allow the Camera permission to scan QR Code."));
          }
        }else {
          return Center(child: (isIos ? CupertinoActivityIndicator(
            animating: true,
            radius: 20,
          ) : CircularProgressIndicator()));
        }
      },
    );
  }

  Widget forWeb() {
    // Uncomment this when building in web

    // ui.platformViewRegistry.registerViewFactory(
    //     keyCamWeb,
    //         (int viewId) => IFrameElement()
    //       ..width = '640'
    //       ..height = '360'
    //       ..src = "https://naggapwam-qr-scanner.web.app/"
    //       ..allow = "camera"
    //       ..style.border = 'none');

    return HtmlElementView(viewType: keyCamWeb);
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldAdaptive(
      isIncludeBottomBarAndroid: false,
      child: kIsWeb ? forWeb() : forMobile(),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      // setState(() {
      //   result = scanData;
      // });

      Navigator.of(context).pushNamedAndRemoveUntil("/", (route) => false);
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    if(!kIsWeb) {
      controller?.dispose();
    }
    super.dispose();
  }

}