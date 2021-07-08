import 'package:flutter/material.dart';
import 'package:align_positioned/align_positioned.dart';

class AppBarSmallLogo extends StatelessWidget {
  final bool hasArrowBack;
  final Function callback;

  AppBarSmallLogo({this.hasArrowBack, this.callback});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      child: Stack(children: <Widget>[
        AlignPositioned(
          child: FlatButton(
            // padding: EdgeInsets.all(36.5),
            child: Image.asset('assets/arrow_left.png'),
            onPressed: () => callbackFct(context),
          ),
          dy: -15,
          alignment: Alignment.bottomLeft,
        ),
        hasArrowBack
          ? AlignPositioned(
              dx: -8,
              child: Image.asset('assets/inside_logo_small.png'),
              alignment: Alignment.center,
            )
          : null,
      ]),
    );
  }

  callbackFct(context) {
    if (callback != null) {
      callback();
    }
    return Navigator.pop(context);
  }
}
