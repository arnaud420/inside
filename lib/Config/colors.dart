import 'package:flutter/material.dart';
import 'dart:ui';

class InsideColors {
  static Map<int, Color> _beigeConfig = {
    50:Color.fromRGBO(255, 225, 214, .1),
    100:Color.fromRGBO(255, 225, 214, .2),
    200:Color.fromRGBO(255, 225, 214, .3),
    300:Color.fromRGBO(255, 225, 214, .4),
    400:Color.fromRGBO(255, 225, 214, .5),
    500:Color.fromRGBO(255, 225, 214, .6),
    600:Color.fromRGBO(255, 225, 214, .7),
    700:Color.fromRGBO(255, 225, 214, .8),
    800:Color.fromRGBO(255, 225, 214, .9),
    900:Color.fromRGBO(255, 225, 214, 1),
  };
  static Map<int, Color> _pinkConfig = {
    50:Color.fromRGBO(217, 119, 142, .1),
    100:Color.fromRGBO(217, 119, 142, .2),
    200:Color.fromRGBO(217, 119, 142, .3),
    300:Color.fromRGBO(217, 119, 142, .4),
    400:Color.fromRGBO(217, 119, 142, .5),
    500:Color.fromRGBO(217, 119, 142, .6),
    600:Color.fromRGBO(217, 119, 142, .7),
    700:Color.fromRGBO(217, 119, 142, .8),
    800:Color.fromRGBO(217, 119, 142, .9),
    900:Color.fromRGBO(217, 119, 142, 1),
  };
  static Map<int, Color> _burgundyConfig = {
    50:Color.fromRGBO(158, 40, 67, .1),
    100:Color.fromRGBO(158, 40, 67, .2),
    200:Color.fromRGBO(158, 40, 67, .3),
    300:Color.fromRGBO(158, 40, 67, .4),
    400:Color.fromRGBO(158, 40, 67, .5),
    500:Color.fromRGBO(158, 40, 67, .6),
    600:Color.fromRGBO(158, 40, 67, .7),
    700:Color.fromRGBO(158, 40, 67, .8),
    800:Color.fromRGBO(158, 40, 67, .9),
    900:Color.fromRGBO(158, 40, 67, 1),
  };
  static Map<int, Color> _lightBlueConfig = {
    50:Color.fromRGBO(159, 207, 214, .1),
    100:Color.fromRGBO(159, 207, 214, .2),
    200:Color.fromRGBO(159, 207, 214, .3),
    300:Color.fromRGBO(159, 207, 214, .4),
    400:Color.fromRGBO(159, 207, 214, .5),
    500:Color.fromRGBO(159, 207, 214, .6),
    600:Color.fromRGBO(159, 207, 214, .7),
    700:Color.fromRGBO(159, 207, 214, .8),
    800:Color.fromRGBO(159, 207, 214, .9),
    900:Color.fromRGBO(159, 207, 214, 1),
  };
  static Map<int, Color> _blueConfig = {
    50:Color.fromRGBO(27, 99, 127, .1),
    100:Color.fromRGBO(27, 99, 127, .2),
    200:Color.fromRGBO(27, 99, 127, .3),
    300:Color.fromRGBO(27, 99, 127, .4),
    400:Color.fromRGBO(27, 99, 127, .5),
    500:Color.fromRGBO(27, 99, 127, .6),
    600:Color.fromRGBO(27, 99, 127, .7),
    700:Color.fromRGBO(27, 99, 127, .8),
    800:Color.fromRGBO(27, 99, 127, .9),
    900:Color.fromRGBO(27, 99, 127, 1),
  };
  static Map<int, Color> _greyConfig = {
    50:Color.fromRGBO(112, 112, 112, .1),
    100:Color.fromRGBO(112, 112, 112, .2),
    200:Color.fromRGBO(112, 112, 112, .3),
    300:Color.fromRGBO(112, 112, 112, .4),
    400:Color.fromRGBO(112, 112, 112, .5),
    500:Color.fromRGBO(112, 112, 112, .6),
    600:Color.fromRGBO(112, 112, 112, .7),
    700:Color.fromRGBO(112, 112, 112, .8),
    800:Color.fromRGBO(112, 112, 112, .9),
    900:Color.fromRGBO(112, 112, 112, 1),
  };
  static Map<int, Color> _darkGreyConfig = {
    50:Color.fromRGBO(57, 57, 57, .1),
    100:Color.fromRGBO(57, 57, 57, .2),
    200:Color.fromRGBO(57, 57, 57, .3),
    300:Color.fromRGBO(57, 57, 57, .4),
    400:Color.fromRGBO(57, 57, 57, .5),
    500:Color.fromRGBO(57, 57, 57, .6),
    600:Color.fromRGBO(57, 57, 57, .7),
    700:Color.fromRGBO(57, 57, 57, .8),
    800:Color.fromRGBO(57, 57, 57, .9),
    900:Color.fromRGBO(57, 57, 57, 1),
  };
  static Map<int, Color> _brownieConfig = {
    50:Color.fromRGBO(82, 20, 35, .1),
    100:Color.fromRGBO(82, 20, 35, .2),
    200:Color.fromRGBO(82, 20, 35, .3),
    300:Color.fromRGBO(82, 20, 35, .4),
    400:Color.fromRGBO(82, 20, 35, .5),
    500:Color.fromRGBO(82, 20, 35, .6),
    600:Color.fromRGBO(82, 20, 35, .7),
    700:Color.fromRGBO(82, 20, 35, .8),
    800:Color.fromRGBO(82, 20, 35, .9),
    900:Color.fromRGBO(82, 20, 35, 1),
  };

  static MaterialColor beige = MaterialColor(0xFFFFE1D6, _beigeConfig);
  static MaterialColor pink = MaterialColor(0xFFD9778E, _pinkConfig);
  static MaterialColor burgundy = MaterialColor(0xFF9E2843, _burgundyConfig);
  static MaterialColor lightBlue = MaterialColor(0xFF9FCFD6, _lightBlueConfig);
  static MaterialColor blue = MaterialColor(0xFF1B637F, _blueConfig);
  static MaterialColor grey = MaterialColor(0xFF707070, _greyConfig);
  static MaterialColor darkGrey = MaterialColor(0xFF393939, _darkGreyConfig);
  static MaterialColor brownie = MaterialColor(0xFF521423, _brownieConfig);
}