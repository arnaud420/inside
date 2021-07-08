import 'package:flutter/material.dart';
import 'package:align_positioned/align_positioned.dart';

class AppBarBigLogo extends StatelessWidget {
  final bool hasArrowBack;

  AppBarBigLogo({this.hasArrowBack});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      child: Stack(children: <Widget>[
        AlignPositioned(
          child: FlatButton(
            padding: EdgeInsets.all(36.5),
            child: Image.asset('assets/arrow_left.png'),
            onPressed: () => Navigator.pop(context),
          ),
          dy: -15,
          alignment: Alignment.bottomLeft,
        ),
        hasArrowBack
          ? AlignPositioned(
              dx: -8,
              child: Image.asset('assets/small_inside_logo_with_title.png'),
              alignment: Alignment.center,
            )
          : null,
      ]),
    );
  }
}
