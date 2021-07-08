import 'package:flutter/material.dart';
import 'package:inside/Config/colors.dart';
import 'package:inside/Widget/BigLogo.dart';
import 'package:inside/Widget/Layouts/InsideScaffold.dart';
import 'package:inside/Widget/Layouts/LayoutBorder.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InsideScaffold(
      child: LayoutBorder(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            BigLogo(),
            Column(children: [
              _HomeButton(
                text: 'Se connecter',
                color: InsideColors.pink,
                pageName: '/login',
              ),
              _HomeButton(
                text: 'S\'enregistrer',
                color: InsideColors.burgundy,
                pageName: '/register',
              ),
            ])
          ],
        ),
      ),
    );
  }
}

class _HomeButton extends StatelessWidget {
  final String text;
  final MaterialColor color;
  final String pageName;

  _HomeButton({this.text, this.color, this.pageName});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 12),
      child: SizedBox(
        width: 270,
        height: 50,
        child: FlatButton(
          child: Text(
            text,
            style: TextStyle(fontSize: 17),
          ),
          color: color,
          textColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
          onPressed: () {
            Navigator.pushNamed(context, pageName);
          },
        ),
      ),
    );
  }
}
