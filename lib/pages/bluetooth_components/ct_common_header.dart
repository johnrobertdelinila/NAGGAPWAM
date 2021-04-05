
import 'package:covidcapstone/services/constants.dart';
import 'package:flutter/material.dart';

import 'ct_header_tile.dart';

class CTCoronaTraceCommonHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: Stack(
        alignment: Alignment.centerRight,
        children: <Widget>[
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  child: Text(
                    appName,
                    style: TextStyle(
                        color: Colors.black, fontSize: 14),
                  ),
                  padding: EdgeInsets.only(top: 10, bottom: 2, left: 15),
                ),
                CTHeaderTile(tagline + ".", subTagline + "."),
              ],
            ),
            margin: EdgeInsets.only(top: 20, right: 20),
          ),
          Image.asset(
            "assets/images/oval_notification.png",
          ),
        ],
      ),
    );
  }
}
