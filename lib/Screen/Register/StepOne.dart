import 'package:flutter/widgets.dart';
import 'package:inside/Widget/Forms/FloatingTextField.dart';
import 'package:inside/Widget/Forms/DateInput.dart';
import 'package:inside/Widget/Forms/EmailInput.dart';
import 'package:inside/Widget/Forms/PasswordInput.dart';
import 'package:inside/Config/validationMessages.dart';

class StepOne extends StatefulWidget {
  final formKey;
  final TextEditingController firstnameController,
      lastnameController,
      dateOfBirthController,
      emailController,
      passwordController;
  final bool hasPassword, hasEmail;

  StepOne({
    @required this.formKey,
    @required this.firstnameController,
    @required this.lastnameController,
    @required this.dateOfBirthController,
    this.emailController,
    this.passwordController,
    this.hasPassword = true,
    this.hasEmail = true,
  });

  @override
  _StepOneState createState() => new _StepOneState();
}

class _StepOneState extends State<StepOne> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Form(
        key: widget.formKey,
        child: Column(
          children: <Widget>[
            FloatingTextField(
              label: 'Prénom',
              validation: (String value) => _validateBasic(value),
              controller: widget.firstnameController,
            ),
            FloatingTextField(
              label: 'Nom',
              validation: (String value) => _validateBasic(value),
              controller: widget.lastnameController,
            ),
            DateInput(
              label: 'Date de naissance',
              controller: widget.dateOfBirthController,
            ),
            widget.hasEmail
                ? EmailInput(
                    controller: widget.emailController,
                  )
                : SizedBox(),
            widget.hasPassword
                ? PasswordInput(
                    controller: widget.passwordController,
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }

  String _validateBasic(String val) {
    if (val.length == 0) {
      return ValidationMessage.mandatoryField;
    } else if (val.length < 2) {
      return ValidationMessage.minimumOneCharacter;
    }

    return null;
  }
}
