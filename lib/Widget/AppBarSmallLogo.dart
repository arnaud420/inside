import 'package:flutter/material.dart';
import 'package:align_positioned/align_positioned.dart';

class AppBarSmallLogo extends StatelessWidget {
  final Image iconRight;
  final Image iconLeft;
  final Function iconLeftAction;
  final Function iconRightAction;

  AppBarSmallLogo(
      {this.iconRight,
      this.iconLeft,
      this.iconLeftAction,
      this.iconRightAction});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: Stack(
        children: <Widget>[
          AlignPositioned(
            dx: -5,
            dy: -10,
            child: Image.asset('assets/inside_logo_small.png'),
            alignment: Alignment.center,
          ),
          AlignPositioned(
            child: FlatButton(
              child: iconRight,
              onPressed: () => iconRightAction(),
            ),
            dy: 25,
            alignment: Alignment.topRight,
          ),
          AlignPositioned(
            child: FlatButton(
              child: iconLeft,
              onPressed: () => iconLeftAction(),
            ),
            dy: 25,
            alignment: Alignment.topLeft,
          ),
        ],
      ),
    );
  }
}
