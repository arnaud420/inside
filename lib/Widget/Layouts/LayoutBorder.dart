import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:inside/Config/colors.dart';
import 'package:inside/Widget/Layouts/BorderBox.dart';

/// Provide a Layout with Inside theme border.
/// Respect the device's safe area.
class LayoutBorder extends StatelessWidget {
  final Widget child;

  LayoutBorder({@required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: InsideColors.burgundy,
      child: SafeArea(
        child: Container(
          color: Colors.white,
          child: BorderBox(
            child: child,
          ),
        ),
      ),
    );
  }
}
