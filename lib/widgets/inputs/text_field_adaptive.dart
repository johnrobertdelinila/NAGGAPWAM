
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show TargetPlatform;
import 'package:flutter/foundation.dart' show kIsWeb;

class TextFieldAdaptive extends StatelessWidget {

  final String placeHolder;
  final Widget prefix, suffix;
  final int maxLength;
  final TextInputType textInputType;
  final FormFieldValidator validator;

  final bool isNotInput;
  final List<String> array;
  final BuildContext  buildContext;
  final Function(int) selectedItemChanged;
  final Function(DateTime) onDateTimeChanged;
  final ValueChanged<DateTime> onDateTimeChangedAndroid;
  final dynamic selectedValue;
  final Function(dynamic) onSaved;
  final TextEditingController preController;
  final GlobalKey fieldKey;

  const TextFieldAdaptive({Key key, @required this.placeHolder, @required this.textInputType, this.prefix, this.maxLength, this.validator, this.suffix, this.isNotInput,
    this.array, this.buildContext, this.selectedItemChanged, this.selectedValue, this.onDateTimeChanged, this.onDateTimeChangedAndroid, @required this.onSaved, this.preController,
    this.fieldKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var platform = Theme.of(context).platform;
    Map<Object, Object> data = {
      "placeHolder": placeHolder,
      "prefix": prefix,
      "suffix": suffix,
      "isNotInput": isNotInput == null ? false : isNotInput,
      "maxLength": maxLength,
      "textInputType": textInputType,
      "validator": validator,
      "context": buildContext,
      "selectedItemChanged": selectedItemChanged,
      "selectedValue": selectedValue,
      "onSaved": onSaved,
      "onDateTimeChanged": onDateTimeChanged,
      "onDateTimeChangedAndroid": onDateTimeChangedAndroid,
      "key": fieldKey
    };

    if(this.preController == null) {
      TextEditingController controller = TextEditingController();
      controller.text = (data["selectedValue"] is String ? data["selectedValue"] : (data["selectedValue"] is DateTime ? data["selectedValue"].toString().replaceAll("00:00:00.000", "") : ""));
      controller.selection = TextSelection.fromPosition(TextPosition(offset: controller.text.length));
      data["controller"] = controller;
    }else {
      data["controller"] = this.preController;
    }

    return platform == TargetPlatform.iOS ?
    IosInput(data: data, array: array,) :
    AndroidInput(data: data, onDateTimeChangedAndroid: onDateTimeChangedAndroid);

  }

}
class WebInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: Theme.of(context).cursorColor,
      decoration: InputDecoration(
        labelText: 'Label text',
        labelStyle: TextStyle(
          color: Color(0xFF6200EE),
        ),
        helperText: 'Helper text',
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(),
        ),
      ),
    );

  }

}

class AndroidInput extends StatelessWidget {

  final Map<Object, Object> data;
  final ValueChanged<DateTime> onDateTimeChangedAndroid;

  const AndroidInput({Key key, this.data, this.onDateTimeChangedAndroid}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);

    DateTime now = DateTime.now();
    return TextFormField(
      cursorColor: Theme.of(context).cursorColor,
      maxLength: data["maxLength"],
      decoration: new InputDecoration(
        labelText: data["placeHolder"],
        fillColor: Colors.white,
        prefix: data["prefix"],
        border: new OutlineInputBorder(
          borderSide: new BorderSide(),
        ),
        suffix: data["suffix"]
      ),
      obscureText: data["placeHolder"].toString().toLowerCase().contains("password") ? true : false,
      keyboardType: data["textInputType"],
      validator: data["validator"],
      textCapitalization: TextCapitalization.words,
      onEditingComplete: () => node.nextFocus(),
      onChanged: data["onSaved"],
      key: data["key"],

      enableInteractiveSelection: data["isNotInput"] ? false : true,
      readOnly: data["isNotInput"] ? true : false,
      controller: data["controller"],
      onTap: !data["isNotInput"] ? null : () async {
        final DateTime datePicked = await showDatePicker(
          context: data["context"],
          initialDate: data["selectedValue"],
          firstDate: DateTime(now.year - 100, now.month, now.day), // Required
          lastDate: DateTime.now(),  // Required
          helpText: "Select " + data["placeHolder"].toString().toLowerCase(),
          cancelText: "Not now",
          confirmText: "Done"
        );
        if(datePicked != null && datePicked != data["selectedValue"]) {
          onDateTimeChangedAndroid(datePicked);
        }

      },
    );
  }

}

class IosInput extends StatelessWidget {

  final Map<Object, Object> data;
  final List<String> array;

  const IosInput({Key key, this.data, this.array}) : super(key: key);

  List<Widget> texts() {
    List<Widget> output = [];
    array.forEach((value) {
      output.add(Text(value));
    });
    return output;
  }

  Widget showPicker() {
    return CupertinoPicker(
        backgroundColor: CupertinoColors.white,
        itemExtent: 30,
        scrollController: FixedExtentScrollController(initialItem: array.indexOf(data["selectedValue"])),
        children: texts(),
        onSelectedItemChanged: data["selectedItemChanged"]
    );
  }

  Widget showDatePicker() {
    return CupertinoDatePicker(
      backgroundColor: CupertinoColors.white,
      initialDateTime: data["selectedValue"],
      onDateTimeChanged: data["onDateTimeChanged"],
      maximumDate: DateTime.now(),
      minimumYear: DateTime.now().year - 100,
      maximumYear: DateTime.now().year,
      minuteInterval: 1,
      mode: CupertinoDatePickerMode.date,
    );
  }

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(padding: EdgeInsets.only(bottom: 4), child: Text(data["placeHolder"], style: TextStyle(color: Colors.black87, fontSize: 16),),),
        CupertinoTextField(
          obscureText: data["placeHolder"].toString().toLowerCase().contains("password") ? true : false,
          cursorColor: Theme.of(context).cursorColor,
          placeholder: "Type here",
          padding: EdgeInsets.fromLTRB(2, 16, 8, 17),
          keyboardType: data["textInputType"],
          prefix: Padding(
            padding: EdgeInsets.only(left: 8),
            child: data["prefix"],
          ),
          suffix: Padding(
            padding: EdgeInsets.only(right: 8),
            child: data["suffix"],
          ),
          maxLength: data["maxLength"],
          textCapitalization: (data["textInputType"] == TextInputType.emailAddress || data["textInputType"] == TextInputType.visiblePassword ? TextCapitalization.none : TextCapitalization.words),
          onEditingComplete: () => node.nextFocus(),
          onSubmitted: data["onSaved"],
          onChanged: data["onSaved"],
          key: data["key"],

          enableInteractiveSelection: data["isNotInput"] ? false : true,
          readOnly: data["isNotInput"] ? true : false,
          controller: data["controller"],
          onTap: !data["isNotInput"] ? null : () {
            showCupertinoModalPopup(
                context: data["context"],
                builder: (_) => Container(
                  height: MediaQuery.of(context).copyWith().size.height / (array != null && array.length < 4 ? 5 : 4),
                  child: array != null ? showPicker() : showDatePicker(),
                )
            );
          },
        )
      ],
    );
  }

}