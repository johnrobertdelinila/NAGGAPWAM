

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show TargetPlatform;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class PageRouting {
  final TargetPlatform platform;
  PageRouting(this.platform);

  PageRoute<dynamic> pageRoute({Widget nextScreen}) {
    if(kIsWeb) {
      return PageRouteBuilder(pageBuilder: (context, animation1, animation2) => nextScreen, transitionDuration: Duration(seconds: 0),);
    }else {
      if(platform == TargetPlatform.iOS) {
        return CupertinoPageRoute(builder: (_) => nextScreen);
      }else {
        return MaterialPageRoute(builder: (_) => nextScreen);
      }
    }

  }

}