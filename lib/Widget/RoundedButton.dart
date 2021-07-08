import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RoundedButton extends StatelessWidget {
  final String title;
  final MaterialColor backgroundColor;
  final Function action;

  RoundedButton({this.title, this.backgroundColor, this.action});

  @override
  Widget build(BuildContext context) {
    final double screenSize = MediaQuery.of(context).size.height;
    
    return ConstrainedBox(
    constraints: BoxConstraints(minWidth: double.infinity),
  child: FlatButton(
      child: Text(
        title,
        style: TextStyle(fontSize: screenSize < 600 ? 10 : screenSize > 600 && screenSize < 800 ? 12 : 15),
        maxLines: 1,
      ),
      color: backgroundColor,
      textColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      onPressed: () => action(),
    ),);
  }
}
