import 'package:flutter/cupertino.dart';
import 'package:inside/Interfaces/InputInterface.dart';
import 'package:inside/Widget/Forms/FloatingTextField.dart';

class PasswordInput extends StatelessWidget implements Input {
  final int passwordMinLength = 8;
  final TextEditingController controller;

  PasswordInput({@required this.controller});

  @override
  Widget build(BuildContext context) {
    return FloatingTextField(
        label: 'Mot de passe',
        controller: controller,
        keyboardType: TextInputType.text,
        validation: (String value) => _validate(value),
        isPassword: true,
    );
  }

  String _validate(String value) {
    if (value.isEmpty) {
      return 'Ce champ est obligatoire';
    }

    if (value.length < passwordMinLength) {
      return 'Minimum $passwordMinLength caractères';
    }

    return null;
  }
}