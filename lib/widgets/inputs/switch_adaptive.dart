
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show TargetPlatform;
import 'package:flutter/material.dart';

class SwitchAdaptive extends StatelessWidget {

  final bool isOn;
  final Function(bool) onChanged;
  final Function() onTap;
  final String title;

  const SwitchAdaptive({Key key, this.isOn, this.onChanged, this.onTap, @required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    if(Theme.of(context).platform == TargetPlatform.iOS) {
      return Theme(
        data: ThemeData(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: MergeSemantics(
          child: ListTile(
            title: Text(title),
            trailing: CupertinoSwitch(
              value: isOn,
              onChanged: onChanged
            ),
            onTap: onTap,
          ),
        ),
      );
    }else {
      return MergeSemantics(
        child: ListTile(
            title: Text(title),
            trailing: Switch(
              value: isOn,
              onChanged: onChanged
            ),
            onTap: onTap
        ),
      );
    }
  }
  
}