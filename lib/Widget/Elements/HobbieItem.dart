import 'package:flutter/material.dart';
import 'package:inside/Helpers/ColorHelper.dart';
import 'package:inside/Models/Hobbie.dart';

class HobbieItem extends StatelessWidget {
  final Hobbie hobbie;

  HobbieItem({@required this.hobbie,});

  @override
  Widget build(BuildContext context) {
    return hobbie != null ? Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.only(bottom: 3),
            child: Image.asset(
              'assets/${hobbie.icon}',
              width: 37,
            ),
            decoration: BoxDecoration(
              color: ColorHelper().getColorFromString(hobbie.backgroundColor),
              shape: BoxShape.circle,
            ),
          ),
          Text(
            hobbie.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    ) : SizedBox();
  }
}
