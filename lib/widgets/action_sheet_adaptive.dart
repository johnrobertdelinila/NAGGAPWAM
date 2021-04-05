
import 'package:covidcapstone/services/constants.dart';
import 'package:covidcapstone/widgets/buttons/text_button_adaptive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' as foundation;

bool get isIos => foundation.defaultTargetPlatform == foundation.TargetPlatform.iOS;

class ActionSheetAdaptive extends StatelessWidget {

  final String title, message;
  final List<Map<String, dynamic>> buttons;
  final bool isIncludeCancel;

  const ActionSheetAdaptive({Key key, @required this.title, @required this.message, @required this.buttons, @required this.isIncludeCancel}) : super(key: key);


  void show(BuildContext context) {
    if(isIos) {
      showCupertinoModalPopup(
          context: context,
          builder: (BuildContext context) => buildDialog(context)
      );
    }else {
      showModalBottomSheet(
          context: context,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))
          ),
          builder: (BuildContext context) => buildDialog(context)
      );
    }
  }

  Widget buildDialog(BuildContext context) {
    List<Widget> actions = [];
    if(buttons != null && buttons.length > 0) {
      for (var button in buttons) {
        if(isIos) {
          actions.add(
            CupertinoActionSheetAction(
                child: Text(button["text"]),
                onPressed: button["action"]
            ),
          );
        }else {
          actions.add(TextButtonAdaptive(text: button["text"], tapEvent: button["action"]));
        }
      }
    }

    if(isIos) {
      return CupertinoActionSheet(
        title: Text(title),
        message: Text(message),
        cancelButton: (isIncludeCancel ? CupertinoActionSheetAction(
          child: const Text('Cancel'),
          isDefaultAction: true,
          onPressed: () {
            Navigator.pop(context, 'Cancel');
          },
        ) : null),
        actions: actions
      );
    }else {
      return Container(
        padding: EdgeInsets.all(20),
        height: 170,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontSize: 16, color: kTextColor, fontWeight: FontWeight.w600)),
            SizedBox(height: 5,),
            Text(message, style: TextStyle(fontSize: 14, color: kTextColor)),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: actions
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox();
  }

}