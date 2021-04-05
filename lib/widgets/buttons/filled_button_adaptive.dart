

import 'package:covidcapstone/Services/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show TargetPlatform;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_spinkit/flutter_spinkit.dart';

class FilledButtonAdaptive extends StatelessWidget {

  final String text;
  final GestureTapCallback tapEvent;
  final Color color;
  final bool isLoading;

  const FilledButtonAdaptive({Key key, @required this.text, @required this.tapEvent, this.color, this.isLoading}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    TargetPlatform platform = Theme.of(context).platform;

    Map<Object, Object> data = {
      "text": text,
      "tapEvent": tapEvent,
      "color": color,
      "isLoading": isLoading
    };

    if(kIsWeb) {
      return webBtn(data);
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

  Widget webBtn(Map<Object, Object> data) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: TextButton(
        onPressed: data["tapEvent"],
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(data["color"]),
          padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 35, vertical: 18))
        ),
        child: data["isLoading"] != null && data["isLoading"] ? SpinKitThreeBounce(
          color: Colors.white,
          size: 25.0,
        ) : Text(
          data["text"].toString().toUpperCase(),
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600
          ),
        ),
      ),
    );
  }

  Widget androidTxtBtn(Map<Object, Object> data) {
    return MaterialButton(
      elevation: 0,
      padding: EdgeInsets.symmetric(vertical: 14.0),
      shape: RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(borderRadius),
      ),
      color: data["color"],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          (data["isLoading"] != null && data["isLoading"] ? SpinKitThreeBounce(
            color: Colors.white,
            size: 25.0,
          ) : Text(
            data["text"],
            style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.w500),
          )),
          SizedBox(
            width: 20,
          ),
        ],
      ),
      onPressed: data["tapEvent"],
    );
  }

  Widget iosTxtBtn(Map<Object, Object> data) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: CupertinoButton(
        padding: EdgeInsets.symmetric(vertical: 14.0),
        color: data["color"],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            (data["isLoading"] != null && data["isLoading"] ? SpinKitThreeBounce(
              color: Colors.white,
              size: 25.0,
            ) : Text(
              data["text"],
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500),
            )),
            SizedBox(
              width: 20,
            ),
          ],
        ),
        onPressed: data["tapEvent"],
      ),
    );
  }

}