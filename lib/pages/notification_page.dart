
import 'package:covidcapstone/Widgets/custom_scrollview_adaptive.dart';
import 'package:covidcapstone/Widgets/icons.dart';
import 'package:covidcapstone/Widgets/scaffold_adaptive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return ScaffoldAdaptive(
      isIncludeBottomBarAndroid: false,
      child: CustomScrollviewAdaptive(
        icon: notifIn,
        title: "Notification",
        widgets: [],
      )
    );
  }

}