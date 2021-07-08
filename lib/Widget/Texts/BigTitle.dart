import 'package:flutter/cupertino.dart';
import 'package:inside/Config/colors.dart';

class BigTitle extends StatelessWidget {
  final String title;

  BigTitle({@required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.5, top: 10),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 30,
          color: InsideColors.burgundy,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}