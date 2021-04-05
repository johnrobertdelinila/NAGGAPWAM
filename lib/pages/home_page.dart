
import 'package:covidcapstone/Pages/bluetooth_page.dart';
import 'package:covidcapstone/Pages/qr_page.dart';
import 'package:covidcapstone/Services/constants.dart';
import 'package:covidcapstone/Widgets/navigation_bar_items.dart';
import 'package:covidcapstone/Widgets/scaffold_adaptive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';

import 'more_page.dart';

class HomePage extends StatefulWidget {
  bool get isIos => foundation.defaultTargetPlatform == foundation.TargetPlatform.iOS;
  _HomePageState createState() => _HomePageState();

}

class _HomePageState extends State<HomePage> {

  Widget androidPlatform() {
    return BluetoothPage();
  }

  Widget iosPlatform() {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        backgroundColor: appColor,
        iconSize: 30,
        activeColor: selectedItemColor,
        inactiveColor: Colors.white24,
        items: NavigationBarItems().items()
      ),
      tabBuilder: (context, index) {
        switch (index) {
          case 0:
            // return CupertinoTabView(builder: (context) => BluetoothPage(), );
            return BluetoothPage();
            break;
          case 1:
            // return CupertinoTabView(builder: (context) => QrPage(),);
            return QrPage();
            break;
          case 2:
            // return CupertinoTabView(builder: (context) => UserInfoCollectorScreen(),);
            return MorePage();
            break;
          default:
            // return CupertinoTabView(builder: (context) => BluetoothPage(),);
            return BluetoothPage();
            break;
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    FlutterStatusbarcolor.setStatusBarColor(backgroundColor);
    FlutterStatusbarcolor.setNavigationBarColor(navColor);

    return ScaffoldAdaptive(
      child: widget.isIos ? iosPlatform() : androidPlatform(),
      isIncludeBottomBarAndroid: widget.isIos ? false : true,
    );
  }

}