

import 'package:covidcapstone/pages/landing_components/header.dart';
import 'package:covidcapstone/services/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show TargetPlatform;
import 'package:flutter/material.dart';
import '../../main.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class TextButtonAdaptive extends StatelessWidget {

  final String text;
  final GestureTapCallback tapEvent;
  final Color color;

  const TextButtonAdaptive({Key key, @required this.text, @required this.tapEvent, this.color}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    TargetPlatform platform = Theme.of(context).platform;
    Map<Object, Object> data = {
      "text": text,
      "tapEvent": tapEvent,
      "color": color,
    };

    if(kIsWeb) {
      return webTxtBtn(data);
    }else {
      return platform == TargetPlatform.iOS ? iosTxtBtn(data) : androidTxtBtn(data);
    }
  }

  void onPressedBtn(BuildContext context, String namedRoute, bool willReturn) {
    NavigatorState state = Navigator.of(context);
    if(willReturn) {
      state.pushNamed(namedRoute);
    }else {
      state.pushNamedAndRemoveUntil(namedRoute, (_) => false);
    }
  }

  Widget webTxtBtn(Map<Object, Object> data) {
    return GestureDetector(
      onTap: data["tapEvent"],
      child: Padding(
        padding: EdgeInsets.only(bottom: 8),
        child: NavItem(
          title: data["text"].toString().toUpperCase(),
          tapEvent: data["tapEvent"],
        ),
      ),
    );
  }

  Widget androidTxtBtn(Map<Object, Object> data) {
    return TextButton(
      child: Text(
        data["text"],
        style: TextStyle(fontSize: 18),
      ),
      onPressed: data["tapEvent"],
    );
  }

  Widget iosTxtBtn(Map<Object, Object> data) {
    return CupertinoButton(
      child: Text(
        data["text"],
        style: TextStyle(fontSize: 18),
      ),
      onPressed: data["tapEvent"],
    );
  }

}