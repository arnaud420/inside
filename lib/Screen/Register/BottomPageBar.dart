import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:inside/Config/colors.dart';
import 'package:inside/Widget/RoundedButton.dart';

class BottomPagerBar extends StatelessWidget {
  final PageController step;
  final double currentStep;
  final formKey;
  final Function validateForm;

  BottomPagerBar(
      {this.step, this.currentStep, this.formKey, this.validateForm});

  _goToPreviousPage() {
    step.previousPage(
        curve: Curves.linearToEaseOut, duration: Duration(milliseconds: 400));
  }

  _goToNextPage() {
    if (formKey.currentState.validate()) {
      if (currentStep != 4) {
        if (validateForm()) {
          step.nextPage(
            curve: Curves.linearToEaseOut,
            duration: Duration(milliseconds: 400),
          );
        }
      } else {
        validateForm();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20, left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: (currentStep > 0
                ? RoundedButton(
                    title: 'Précédent',
                    backgroundColor: InsideColors.pink,
                    action: () => _goToPreviousPage(),
                  )
                : SizedBox()),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: DotsIndicator(
                dotsCount: 4,
                position: currentStep.toInt(),
                decorator: DotsDecorator(
                  color: Colors.grey[300],
                  spacing: EdgeInsets.all(5.0),
                  activeColor: InsideColors.brownie,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: RoundedButton(
              title: currentStep < 3 ? 'Suivant' : 'Valider',
              backgroundColor: InsideColors.lightBlue,
              action: () => _goToNextPage(),
            ),
          ),
        ],
      ),
    );
  }
}
