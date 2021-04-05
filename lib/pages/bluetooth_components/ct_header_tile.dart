import 'package:covidcapstone/Services/constants.dart';
import 'package:flutter/material.dart';

import '../../Services/constants.dart';

class CTHeaderTile extends StatelessWidget {
  final String title;
  final String subtitle;

  CTHeaderTile(this.title, this.subtitle);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: kSubtitleStyle,
      ),
      subtitle: Padding(
        child: Text(
          subtitle,
          style:
          TextStyle(color: navColor, fontSize: 14),
        ),
        padding: EdgeInsets.only(top: 20, bottom: 30),
      ),
    );
  }
}
