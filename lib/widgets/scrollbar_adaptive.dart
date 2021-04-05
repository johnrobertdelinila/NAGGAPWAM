

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show TargetPlatform;
import 'package:flutter/material.dart';

class ScrollbarAdaptive extends StatelessWidget {

  final Widget child;

  const ScrollbarAdaptive({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    var platform = Theme.of(context).platform;

    if(platform == TargetPlatform.iOS) {
      return CupertinoScrollbar(child: child);
    }else {
      return Scrollbar(child: child);
    }

  }

}