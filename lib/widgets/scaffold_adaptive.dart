

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covidcapstone/Pages/more_page.dart';
import 'package:covidcapstone/Pages/qr_page.dart';
import 'package:covidcapstone/Widgets/navigation_bar_items.dart';
import 'package:covidcapstone/pages/bluetooth_page.dart';
import 'package:covidcapstone/services/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show TargetPlatform;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'alertdialog_adaptive.dart';
import 'inputs/text_field_adaptive.dart';

bool get isIoss => foundation.defaultTargetPlatform == foundation.TargetPlatform.iOS;

class ScaffoldAdaptive extends StatefulWidget {

  final Widget child;
  final bool isIncludeBottomBarAndroid;
  final Color backgroundColor;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const ScaffoldAdaptive({Key key, @required this.child, @required this.isIncludeBottomBarAndroid,
    this.backgroundColor, this.scaffoldKey}) : super(key: key);

  _ScaffoldAdaptiveState createState() => _ScaffoldAdaptiveState();

}

class _ScaffoldAdaptiveState extends State<ScaffoldAdaptive> {

  int currentTabIndex = 0;

  onTapped(int index) {
    setState(() {
      currentTabIndex = index;
    });
  }

  List<Widget> tabs = [
    BluetoothPage(),
    QrPage(),
    MorePage(),
  ];

  @override
  Widget build(BuildContext context) {

    TextEditingController temp = TextEditingController();

    var fabTxt = "Temperature";
    var fab = FloatingActionButton.extended(
      onPressed: () {
        AlertDialogAdaptive(
          title: "Temperature",
          content: TextFieldAdaptive(
            placeHolder: "Temperature",
            textInputType: TextInputType.number,
            preController: temp,
          ),
          buttons: [
            {
              "text": "Done",
              "action": () async {
                Navigator.pop(context);
                String id_number = await getStringValuesSF("id_number");
                if(temp.text != null && temp.text.length > 1) {
                  FirebaseFirestore.instance.collection("hdf").doc(id_number).update({
                    "temperature": temp.text
                  });
                }
              }
            },
          ],
        ).show(context);
      },
      label: Text(isIoss ? fabTxt : fabTxt.toUpperCase()),
      icon: Icon(isIoss ? CupertinoIcons.thermometer : Icons.thermostat_outlined),
      backgroundColor: isIoss ? CupertinoColors.systemPurple : Colors.purple,
    );

    var platform = Theme.of(context).platform;
    if(platform == TargetPlatform.android) {
      return Scaffold(
        key: widget.scaffoldKey,
        backgroundColor: widget.backgroundColor != null ? widget.backgroundColor : null,
        body: widget.isIncludeBottomBarAndroid ? tabs[currentTabIndex] : widget.child,
        floatingActionButton: null,
        bottomNavigationBar: widget.isIncludeBottomBarAndroid == null || !widget.isIncludeBottomBarAndroid ?
          null :
          BottomNavigationBar(
            backgroundColor: navColor,
            iconSize: 30,
            selectedItemColor: selectedItemColor,
            unselectedItemColor: Colors.white24,
            showUnselectedLabels: false,
            selectedFontSize: 14,
            unselectedFontSize: 14,
            items: NavigationBarItems().items(),
            currentIndex: currentTabIndex,
            onTap: onTapped,
          )
        ,
      );
    }else {
      return Scaffold(
        key: widget.scaffoldKey,
        backgroundColor: widget.backgroundColor != null ? widget.backgroundColor : null,
        floatingActionButton: widget.isIncludeBottomBarAndroid ? FutureBuilder(
          future: getStringValuesSF("id_number"),
          builder: (context, snap) {
            if(snap.hasData && snap.data != null) {
              // return Padding(padding: const EdgeInsets.only(bottom: 60.0), child: fab);
              return SizedBox();
            }else {
              return SizedBox();
            }
          },
        ): null,
        body: SafeArea(child: widget.child, bottom: (widget.isIncludeBottomBarAndroid == null ? true : false),),
      );
    }

  }

}