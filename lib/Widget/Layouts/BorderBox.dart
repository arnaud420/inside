import 'package:flutter/cupertino.dart';
import 'package:inside/Config/colors.dart';

class BorderBox extends StatelessWidget {
  final Widget child;

  BorderBox({@required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(),
      decoration: BoxDecoration(
        border: Border.all(
          color: InsideColors.burgundy,
          width: 8,
        ),
      ),
      child: child,
    );
  }
}