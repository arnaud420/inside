import 'package:flutter/material.dart';
import 'package:inside/Config/colors.dart';

class FullScreenLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[CircularProgressIndicator(backgroundColor: InsideColors.pink)])
          ])
      )
    );
  }
}