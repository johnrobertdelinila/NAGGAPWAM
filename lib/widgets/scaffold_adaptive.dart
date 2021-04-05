

import 'package:covidcapstone/Pages/bluetooth_page.dart';
import 'package:covidcapstone/Pages/more_page.dart';
import 'package:covidcapstone/Pages/qr_page.dart';
import 'package:covidcapstone/Services/constants.dart';
import 'package:covidcapstone/Widgets/navigation_bar_items.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show TargetPlatform;
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';

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

    var platform = Theme.of(context).platform;
    if(platform == TargetPlatform.android) {
      return Scaffold(
        key: widget.scaffoldKey,
        backgroundColor: widget.backgroundColor != null ? widget.backgroundColor : null,
        body: widget.isIncludeBottomBarAndroid ? tabs[currentTabIndex] : widget.child,
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
        body: SafeArea(child: widget.child, bottom: (widget.isIncludeBottomBarAndroid == null ? true : false),),
      );
    }

  }

}