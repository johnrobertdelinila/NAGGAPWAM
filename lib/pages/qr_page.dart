
import 'package:covidcapstone/Widgets/custom_scrollview_adaptive.dart';
import 'package:covidcapstone/Widgets/icons.dart';
import 'package:covidcapstone/services/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Landing_components/qr_code_entry.dart';

class QrPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var shortestSide = MediaQuery.of(context).size.shortestSide;

    final bool isMobileLayout = shortestSide < 500;
    return CustomScrollviewAdaptive(
      icon: GestureDetector(child: notifOut, onTap: () => Navigator.of(context).pushNamed("/notification"),),
      title: navigations[1],
      widgets: [
        Jumbotron(isMobile: isMobileLayout, isTablet: !isMobileLayout,)
      ],
    );
  }

}