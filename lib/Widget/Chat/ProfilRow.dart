import 'package:flutter/material.dart';
import 'package:inside/Models/User.dart';
import 'package:inside/Config/colors.dart';
import 'package:inside/Screen/ProfilScreen.dart';

class ProfilRow extends StatelessWidget {
  final User user;
  const ProfilRow(this.user);

  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(children: <Widget>[
            Row(children: <Widget>[
              Column(children: <Widget>[
                ClipOval(
                  child: Image.network(
                    user.photo,
                    width: 60,
                    fit: BoxFit.contain,
                  ),
                ),
              ],),
              Column(children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(user.firstname),
                )
              ]),
            ])
          ]),
          Column(children: <Widget>[
            RaisedButton(
              textColor: Colors.white,
              color: InsideColors.pink,
              child: Text('Profil'),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilScreen(user),
                ),
              ),
              shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(15),
              )
            ),
          ])
        ]
      ),
    );
  }
}