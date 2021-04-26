
import 'dart:ui';

import 'package:bluetooth_enable/bluetooth_enable.dart';
import 'package:covidcapstone/Widgets/custom_scrollview_adaptive.dart';
import 'package:covidcapstone/Widgets/icons.dart';
import 'package:covidcapstone/services/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:system_setting/system_setting.dart';
import 'Bluetooth_components/ct_common_header.dart';

bool get isIos => foundation.defaultTargetPlatform == foundation.TargetPlatform.iOS;

class BluetoothPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return StreamBuilder<BluetoothState>(
      stream: FlutterBlue.instance.state,
      builder: (c, snapshot) {
        final state = snapshot.data;
        bool isBlOn = false;
        if (state == BluetoothState.on) {
          print("BLUETOOTH IS ON");
          isBlOn = true;
        }
        return CustomScrollviewAdaptive(
          icon: GestureDetector(child: notifOut, onTap: () => Navigator.of(context).pushNamed("/notification"),),
          title: navigations[0],
          widgets: [
            CTCoronaTraceCommonHeader(),
            bluetoothControl(context, isBlOn),
            report(context),
            howCanHelp(),
            shareApp(),
            washRemember(),
            SizedBox(height: 25,)
          ],
        );
      }
    );

  }

  Future<void> customEnableBT(BuildContext context) async {
    if(isIos) {
      SystemSetting.goto(SettingTarget.BLUETOOTH);
    }else {
      String dialogTitle = "Bluetooth Permission";
      bool displayDialogContent = true;
      String dialogContent = "Naggapwam app requires Bluetooth to enable Exposure Notification.";
      //or
      // bool displayDialogContent = false;
      // String dialogContent = "";
      String cancelBtnText = "Cancel";
      String acceptBtnText = "Agree";
      double dialogRadius = 10.0;
      bool barrierDismissible = true; //

      BluetoothEnable.customBluetoothRequest(context, dialogTitle, displayDialogContent, dialogContent, cancelBtnText, acceptBtnText, dialogRadius, barrierDismissible).then((result) {
        if (result == "true"){
          print("Bluetooth has been enabled");
        }
      });
    }

  }

  Widget buttonBluetooth(BuildContext context) {
    var text = Text("Click and  turn on\nBluetooth", style: TextStyle(fontSize: 17),);
    return Row(
      children: [
        isIos ? CupertinoButton(child: text, onPressed: (){
          customEnableBT(context);
        }, padding: EdgeInsets.only(left: 0),) : TextButton(onPressed: (){
          customEnableBT(context);
        }, child: text,),
        SizedBox(width: 28,),
        Icon((isIos ? CupertinoIcons.right_chevron : Icons.arrow_forward), size: 17, color: (!isIos ? Colors.blue : CupertinoColors.activeBlue),)
      ],
    );
  }

  Widget bluetoothControl(BuildContext context, bool blOn) {
    return Container(
      padding: EdgeInsets.only(top: 10, bottom: 10),
      decoration: BoxDecoration(
        // borderRadius: BorderRadius.circular(10),
        color: mainColor.withOpacity(0.1),
        // boxShadow: [
        //   BoxShadow(color: mainColor.withOpacity(0.1), spreadRadius: 0.1),
        // ],
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("The application is", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 22.0,),),
                SizedBox(height: 4,),
                Text(blOn ? "active" : "inactive", style: TextStyle(color: (!isIos ? (blOn ? Colors.green : Colors.red) : (blOn ? CupertinoColors.activeGreen : CupertinoColors.destructiveRed)), fontWeight: FontWeight.w600, fontSize: 22.0,),),
                SizedBox(height: 12,),
                Text("Exposure Notification", style: kMainTextStyle),
                SizedBox(height: 2,),
                Text("requires Bluetooth", style: kMainTextStyle),
                SizedBox(height: 12,),
                buttonBluetooth(context)
              ],
            ),
            Container(
              child: Lottie.asset('assets/lotties/bluetooth_off.json'),
              width: MediaQuery.of(context).size.width*0.3,
              height: MediaQuery.of(context).size.height * 0.2,
            ),
          ],
        ),
      ),
    );
  }

  Widget shareApp() {
    return GestureDetector(
      onTap: () {
        onShareWithEmptyOrigin();
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        elevation: 1,
        color: mainColor.withOpacity(0.1),
        shadowColor: mainColor.withOpacity(0.1),
        margin: EdgeInsets.only(left: 10, right: 10, top: 18),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Icon(isIos ?  CupertinoIcons.share : Icons.share, size: 16,),
                SizedBox(width: 10,),
                Text("Share this app", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: navColor),)
              ],),
              SizedBox(height: 5,),
              Text("Ask friend and family to help.", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300, color: kTextColor),),
            ],
          ),
        ),
      ),
    );
  }

  Widget report(BuildContext context) {

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      elevation: 1,
      color: (isIos ? CupertinoColors.systemBlue : Colors.blue).withOpacity(0.1),
      shadowColor: (isIos ? CupertinoColors.systemBlue : Colors.blue).withOpacity(0.3),
      margin: EdgeInsets.only(left: 10, right: 10, top: 18),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: Image.asset("assets/covid_test.png"),
              width: MediaQuery.of(context).size.width*0.2,
              height: MediaQuery.of(context).size.height * 0.2,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("You have been tested", style: TextStyle(color: Colors.yellowAccent, fontWeight: FontWeight.w500, fontSize: 18.0,),),
                SizedBox(height: 4,),
                Text("positive for COVID-19?", style: TextStyle(color: Colors.yellowAccent, fontWeight: FontWeight.w500, fontSize: 18.0,),),
                SizedBox(height: 6),
                Row(
                  children: [
                    isIos ? CupertinoButton(child: Text("Help Warn Others"), onPressed: () => Navigator.of(context).pushNamed("/report"), padding: EdgeInsets.only(left: 0),) : TextButton(onPressed: ()
                      => Navigator.of(context).pushNamed("/report"), child: Text("Warn Others"),),
                    SizedBox(width: 28,),
                    Icon((isIos ? CupertinoIcons.right_chevron : Icons.arrow_forward), size: 17, color: (!isIos ? Colors.blue : CupertinoColors.activeBlue),)
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );

  }

  Widget washRemember() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      elevation: 1,
      color: (isIos ? CupertinoColors.systemYellow : Colors.yellow).withOpacity(0.1),
      shadowColor: (isIos ? CupertinoColors.systemYellow : Colors.yellow).withOpacity(0.1),
      margin: EdgeInsets.only(left: 10, right: 10, top: 18),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Remember to wash your hands", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: navColor),),
            SizedBox(height: 5,),
            Text("Wash often. Use soap. 20 seconds. Then dry. This kills the virus by bursting its protective bubble.", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300, color: kTextColor),),
          ],
        ),
      ),
    );
  }

  Widget howCanHelp() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 3,
      margin: EdgeInsets.only(left: 10, right: 10, top: 30),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("How can you help stop the spread of COVID-19", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black),),
            SizedBox(height: 20,),
            Text("Turn on Exposure Notification especially in meetings, public spaces, and public transport.", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300, color: kTextColor),),
            SizedBox(height: 10,),
          ],
        ),
      ),
    );
  }

}