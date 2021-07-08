import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Badge extends StatelessWidget {
  final String text;
  final MaterialColor color;

  Badge({@required this.text, @required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        text,
        style: TextStyle(color: Colors.white),
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(1000),
      ),
      padding: EdgeInsets.symmetric(vertical: 7, horizontal: 12),
    );
  }
}