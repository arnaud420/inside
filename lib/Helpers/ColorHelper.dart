import 'package:flutter/material.dart';

class ColorHelper {
  Color getColorFromString(String color) {
    if (color == "red") {
      return Colors.red[700];
    } else if (color == "yellow") {
      return Colors.yellow[600];
    } else if (color == "orange") {
      return Colors.orange[400];
    } else if (color == "greyblue") {
      return Colors.blueGrey;
    } else if (color == "blue") {
      return Colors.blue[300];
    } else if (color == "violet") {
      return Colors.purple[900];
    } else if (color == "pink") {
      return Colors.pink[400];
    } else if (color == "grey") {
      return Colors.grey[850];
    } else if (color == "green") {
      return Colors.green[900];
    }
  }
}