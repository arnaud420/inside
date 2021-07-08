import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inside/Widget/BigLogo.dart';
import 'package:inside/Widget/Layouts/InsideScaffold.dart';

class LoadingScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return InsideScaffold(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            BigLogo(),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}