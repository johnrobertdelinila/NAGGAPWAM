
import 'package:covidcapstone/services/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';

bool get isIos => foundation.defaultTargetPlatform == foundation.TargetPlatform.iOS;

class NavigationBarItems {

  List<BottomNavigationBarItem> items() {
    return [
      BottomNavigationBarItem(
        icon: Padding(
          padding: EdgeInsets.only(top: isIos ? 4 : 0),
          child: Icon(
              (isIos ? CupertinoIcons.home : Icons.home_rounded)),
        ),
          label: navigations[0]),
      BottomNavigationBarItem(
        icon: Padding(
          padding: EdgeInsets.only(top: isIos ? 4 : 0),
          child: Icon(
              (isIos ? CupertinoIcons.qrcode : Icons.qr_code_rounded)),
        ),
          label: navigations[1]),
      BottomNavigationBarItem(
        icon: Padding(
          padding: EdgeInsets.only(top: isIos ? 4 : 0),
          child: Icon(
              (isIos ? CupertinoIcons.info_circle : Icons.more_horiz)),
        ),
          label: navigations[2])
    ];
  }

}