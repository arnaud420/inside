import 'package:flutter/material.dart';
import 'package:inside/Widget/AppBar/AppBarBigLogo.dart';
import 'package:inside/Widget/Texts/BigTitle.dart';

import 'BottomPageBar.dart';

class PagerContainer extends StatelessWidget {
  final Widget stepWidget;
  final PageController step;
  final double currentStep;
  final formKey;
  final Function validateForm;

  PagerContainer(
      {this.stepWidget,
      this.step,
      this.currentStep,
      this.formKey,
      this.validateForm});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        AppBarBigLogo(hasArrowBack: true),
        Center(
          child: BigTitle(title: "Inscription"),
        ),
        stepWidget,
        BottomPagerBar(
            step: step,
            currentStep: currentStep,
            formKey: formKey,
            validateForm: validateForm),
      ],
    );
  }
}