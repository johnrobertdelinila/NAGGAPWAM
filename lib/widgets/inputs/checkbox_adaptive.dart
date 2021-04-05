
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show TargetPlatform;
import 'package:flutter/material.dart';

class CheckboxAdaptive extends StatelessWidget {

  final bool isOn;
  final Function(bool) onChanged;
  final Function() onTap;
  final String title;

  const CheckboxAdaptive({Key key, this.isOn, this.onChanged, this.onTap, @required this.title}) : super(key: key);

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
            title: Text(title, style: TextStyle(color: Colors.black54, fontSize: 14),),
            leading: CupertinoSwitch(
              value: isOn,
              onChanged: onChanged,
            ),
            onTap: onTap,
          ),
        ),
      );
    }else {

      return MergeSemantics(
        child: ListTile(
            title: Text(title, style: TextStyle(color: Colors.black54, fontSize: 14),),
            leading: Checkbox(
              value: isOn,
              onChanged: onChanged
            ),
            onTap: onTap
        ),
      );
    }
  }
  
}