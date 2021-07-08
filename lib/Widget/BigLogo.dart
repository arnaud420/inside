import 'package:flutter/cupertino.dart';
import 'package:inside/Config/colors.dart';

class BigLogo extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(right: 30),
          child: Image.asset(
            'assets/inside_logo.png',
            width: 220,
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 12),
          child: Text(
              'Inside',
              style: TextStyle(
                fontSize: 50,
                color: InsideColors.pink,
              )),
        ),
      ],
    );
  }
}