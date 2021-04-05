


import 'package:covidcapstone/Services/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' as foundation;

bool get isIos => foundation.defaultTargetPlatform == foundation.TargetPlatform.iOS;

var notif = Icon((isIos ? CupertinoIcons.bell_fill: Icons.notifications_rounded), color: mainColor,);
var bluetooth = Icon((isIos ? CupertinoIcons.bluetooth: Icons.bluetooth_rounded), color: mainColor,);
var notifOut = Icon(isIos ? CupertinoIcons.bell : Icons.notifications_none_rounded, color: kTextColor,);
var notifIn = Icon(isIos ? CupertinoIcons.bell_circle_fill : Icons.circle_notifications, color: kTextColor,);
var forward = Icon((!isIos ? Icons.arrow_forward : CupertinoIcons.forward), color: Colors.white);