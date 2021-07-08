import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inside/Config/colors.dart';

class InsideScaffold extends StatelessWidget {
  final Widget child;
  final bool avoidBottomInset;

  InsideScaffold({@required this.child, this.avoidBottomInset = true});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          child: AppBar(
            backgroundColor: InsideColors.burgundy,
            elevation: 0.0,
          ),
          preferredSize: Size.fromHeight(0.0)),
          resizeToAvoidBottomInset: avoidBottomInset,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: child,
      ),
    );
  }
}
