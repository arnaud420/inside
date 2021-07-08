import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inside/Config/validationMessages.dart';
import 'package:inside/Interfaces/InputInterface.dart';
import 'package:inside/Widget/Forms/FloatingTextField.dart';

class DateInput extends StatefulWidget {
  final String label;
  final TextEditingController controller;

  DateInput({this.label, @required this.controller});

  @override
  _DateInputState createState() => new _DateInputState();
}

class _DateInputState extends State<DateInput> implements Input {
  String _initialValue;

  @override
  void initState() {
    super.initState();
    _initialValue = widget.controller.text;
  }

  @override
  Widget build(BuildContext context) {
    return FloatingTextField(
        label: widget.label,
        onTap: (context) => onTap(context),
        validation: (String value) => _validate(value),
        isDateField: true,
        initialValue: _initialValue,
        controller: widget.controller,
        );
  }

  onTap(context) {
    FocusScope.of(context).requestFocus(FocusNode());
    showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return Container(
            height: MediaQuery.of(context).copyWith().size.height / 3,
            child: CupertinoDatePicker(
              initialDateTime: DateTime.now().subtract(Duration(days: (365 * 18 + 4))),
              onDateTimeChanged: (DateTime newDate) {
                setState(() {
                  _initialValue = (newDate.day.toString() + '/' + newDate.month.toString() + '/' + newDate.year.toString());
                });
              },
              maximumDate: DateTime.now().subtract(Duration(days: (365 * 18 + 4))),
              minimumYear: 1900,
              maximumYear: DateTime.now().subtract(Duration(days: (365 * 18 + 4))).year, // Actual date minus 18 years
              mode: CupertinoDatePickerMode.date,
            ));
      },
    );
  }

  String _validate(String value) {
    if (value.length == 0) {
      return ValidationMessage.mandatoryField;
    }

    return null;
  }
}
