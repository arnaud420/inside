import 'package:flutter/material.dart';
import 'package:inside/Models/User.dart';

class Profil extends StatelessWidget {
  final User user;
  const Profil(this.user);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      width: 100,
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center, 
            children: <Widget>[
              ClipOval(
                child: Image.network(
                  user.photo,
                  width: 80,
                  fit: BoxFit.contain,
                ),
              ),
              Container(
                width: 80,
                child: Center(
                  child: Text(user.firstname, overflow: TextOverflow.ellipsis, maxLines: 1, textAlign: TextAlign.center)
                )
              )
          ])
      ])
    );
  }
}