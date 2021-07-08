import 'package:flutter/cupertino.dart';
import 'package:inside/Config/validationMessages.dart';
import 'package:inside/Interfaces/InputInterface.dart';
import 'package:inside/Widget/Forms/FloatingTextField.dart';

class EmailInput extends StatelessWidget implements Input {
  final TextEditingController controller;

  EmailInput({@required this.controller});

  @override
  Widget build(BuildContext context) {
    return FloatingTextField(
        label: 'Email',
        controller: controller,
        keyboardType: TextInputType.emailAddress,
        validation: (String value) => _validate(value)
    );
  }

  String _validate(String value) {
    if (value.isEmpty) {
      return ValidationMessage.mandatoryField;
    }

    RegExp emailRegex = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9-]+\.[a-zA-Z]+");

    if (!emailRegex.hasMatch(value)) {
      return 'Format d\'email invalide';
    }

    return null;
  }
}