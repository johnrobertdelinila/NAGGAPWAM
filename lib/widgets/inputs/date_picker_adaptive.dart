
import 'package:covidcapstone/widgets/inputs/text_field_adaptive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DatePickerAdaptive extends StatelessWidget {

  final String placeHolder;
  final BuildContext buildContext;
  final Function(DateTime) onDateTimeChanged;
  final ValueChanged<DateTime> onDateTimeChangedAndroid;
  final DateTime selectedDate;

  const DatePickerAdaptive({Key key, @required this.placeHolder, @required this.buildContext, @required this.onDateTimeChanged, this.selectedDate, this.onDateTimeChangedAndroid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var platform = Theme.of(context).platform;
    Map<String, Object> data = {
      "placeHolder": placeHolder,
      "onDateTimeChanged": onDateTimeChanged,
      "onDateTimeChangedAndroid": onDateTimeChangedAndroid,
      "context": buildContext,
      "selectedDate": selectedDate
    };


    return platform == TargetPlatform.iOS ? IosInput(data: data) : AndroidInput(data: data);
  }

}

class AndroidInput extends StatelessWidget {

  final Map<Object, Object> data;

  const AndroidInput({Key key, this.data}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return TextFieldAdaptive(
      placeHolder: data["placeHolder"],
      textInputType: TextInputType.text,
      suffix: Icon(Icons.calendar_today_rounded, color: Colors.black54,),
      isNotInput: true,
      buildContext: data["context"],
      selectedValue: data["selectedDate"],
      onDateTimeChangedAndroid: data["onDateTimeChangedAndroid"],
    );
  }

}

class IosInput extends StatelessWidget {

  final Map<Object, Object> data;

  const IosInput({Key key, this.data}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return TextFieldAdaptive(
      placeHolder: data["placeHolder"],
      textInputType: TextInputType.text,
      suffix: Icon(CupertinoIcons.calendar),
      isNotInput: true,
      buildContext: data["context"],
      selectedValue: data["selectedDate"],
      onDateTimeChanged: data["onDateTimeChanged"],
    );
  }

}