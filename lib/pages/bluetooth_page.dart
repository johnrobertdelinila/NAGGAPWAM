
import 'dart:ui';

import 'package:covidcapstone/Widgets/custom_scrollview_adaptive.dart';
import 'package:covidcapstone/Widgets/icons.dart';
import 'package:covidcapstone/services/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'Bluetooth_components/ct_common_header.dart';

bool get isIos => foundation.defaultTargetPlatform == foundation.TargetPlatform.iOS;

class BluetoothPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return CustomScrollviewAdaptive(
      icon: GestureDetector(child: notifOut, onTap: () => Navigator.of(context).pushNamed("/notification"),),
      title: navigations[0],
      widgets: [
        CTCoronaTraceCommonHeader(),
        bluetoothControl(context),
        howCanHelp(),
        shareApp(),
        washRemember(),
        SizedBox(height: 25,)
      ],
    );

  }

  Widget buttonBluetooth() {
    var text = Text("Click and turn on\nBluetooth", style: TextStyle(fontSize: 17),);
    return Row(
      children: [
        isIos ? CupertinoButton(child: text, onPressed: (){}, padding: EdgeInsets.only(left: 0),) : TextButton(onPressed: (){}, child: text,),
        SizedBox(width: 28,),
        Icon((isIos ? CupertinoIcons.right_chevron : Icons.arrow_forward), size: 17, color: (!isIos ? Colors.blue : CupertinoColors.activeBlue),)
      ],
    );
  }

  Widget bluetoothControl(BuildContext context) {
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
                Text("inactive", style: TextStyle(color: (!isIos ? Colors.red : CupertinoColors.destructiveRed), fontWeight: FontWeight.w600, fontSize: 22.0,),),
                SizedBox(height: 12,),
                Text("Anonymous log", style: kMainTextStyle),
                SizedBox(height: 2,),
                Text("requires Bluetooth", style: kMainTextStyle),
                SizedBox(height: 12,),
                buttonBluetooth()
              ],
            ),
            Container(
              child: Lottie.asset('assets/lotties/bluetooth_off.json'),
              width: MediaQuery.of(context).size.width*0.4,
              height: MediaQuery.of(context).size.height * 0.3,
            ),
          ],
        ),
      ),
    );
  }

  Widget shareApp() {
    return Card(
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
            Text("Turn on Anonymous log especially in meetings, public spaces, and public transport.", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300, color: kTextColor),),
            SizedBox(height: 10,),
          ],
        ),
      ),
    );
  }

}