import 'package:flutter/material.dart';
import 'package:inside/Config/colors.dart';
import 'package:inside/Widget/Elements/HobbieItem.dart';

class HobbiesList extends StatelessWidget {
  final List hobbies;
  final String title;
  final state;
  const HobbiesList(this.title, this.hobbies, this.state);
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,  
      children: <Widget>[
        Text('${this.title} :', style: TextStyle(fontSize: 18, color: InsideColors.pink)),

        Container(padding: const EdgeInsets.all(5)),

        Container(
          height: 95,
          child: ListView(
          scrollDirection: Axis.horizontal,
          children: this.hobbies.map((hobbieKey) => 
            Container(
              width: 75,
              child: HobbieItem(hobbie: state.hobbies.singleWhere((hobbie) => hobbie.documentID == hobbieKey))
            )
          ).toList())
        )
    ]);
  }
}