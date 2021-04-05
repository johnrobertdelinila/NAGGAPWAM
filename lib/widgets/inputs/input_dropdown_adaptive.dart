
import 'package:covidcapstone/widgets/inputs/text_field_adaptive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show TargetPlatform;

class InputDropdownAdaptive extends StatelessWidget {

  final String placeHolder;
  final List<String> array;
  final String selectedValue;
  final Function(String) onChanged;
  final Function(int) selectedItemChanged;
  final BuildContext context;
  final FormFieldValidator validator;

  const InputDropdownAdaptive({Key key, this.placeHolder, this.array, this.selectedValue, this.onChanged, this.context, this.selectedItemChanged, @required this.validator}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var platform = Theme.of(context).platform;
    Map<String, Object> data = {
      "placeHolder": placeHolder,
      "selectedValue": selectedValue,
      "onChanged": onChanged,
      "selectedItemChanged": selectedItemChanged,
      "context": this.context,
      "validator": validator
    };


    return platform == TargetPlatform.iOS ?
    IosInput(data: data, array: array) :
    AndroidInput(data: data, array: array);

  }

}

class AndroidInput extends StatelessWidget {

  final Map<Object, Object> data;
  final List<String> array;

  const AndroidInput({Key key, this.data, this.array}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    return FormField<String>(
      onSaved: (_bool) => node.nextFocus(),
      // validator: data["validator"],
      builder: (FormFieldState<String> state) {
        return InputDecorator(
          decoration: InputDecoration(
            labelText: data["placeHolder"],
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
          isEmpty: data["selectedValue"] == '' || data["selectedValue"] == null,
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: data["selectedValue"] == null ? null : data["selectedValue"],
              isDense: true,
              onChanged: data["onChanged"],
              items: array.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        );
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

  @override
  Widget build(BuildContext context) {

    return TextFieldAdaptive(
      placeHolder: data["placeHolder"],
      textInputType: TextInputType.text,
      suffix: Icon(CupertinoIcons.chevron_down),
      isNotInput: true,
      array: array,
      buildContext: data["context"],
      selectedValue: data["selectedValue"],
      selectedItemChanged: data["selectedItemChanged"]
    );

  }

}