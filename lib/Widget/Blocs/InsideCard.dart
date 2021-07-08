import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inside/Blocs/Authentication/AuthenticationBloc.dart';
import 'package:inside/Blocs/Authentication/AuthenticationState.dart';
import 'package:inside/Config/colors.dart';
import 'package:inside/Helpers/UserHelper.dart';
import 'package:inside/Models/User.dart';
import 'package:inside/Widget/Layouts/BorderBox.dart';
import 'package:inside/Widget/Texts/Badge.dart';

import 'HobbiesColumn.dart';

class InsideCard extends StatelessWidget {
  final User user;

  InsideCard({this.user});

  final UserHelper userHelper = UserHelper();
  GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();

  @override
  Widget build(BuildContext context) {
    return FlipCard(
      key: cardKey,
      flipOnTouch: false,
      front: BorderBox(
          child: Container(
            decoration: BoxDecoration(color: Colors.white),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Badge(
                        text: '${userHelper.getAge(user.birthDate)} ans',
                        color: InsideColors.lightBlue,
                      ),
                      Text(
                        '${user.firstname[0]}.${user.lastname[0]}.',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      BlocBuilder<AuthenticationBloc, AuthenticationState>(
                        builder: (context, state) {
                          if (state is Authenticated) {
                            return  Badge(
                              text: '${userHelper.getDistanceBetweenPoints(user.geopoint, state.user.geopoint)} km',
                              color: InsideColors.beige,
                            );
                          }
                          return  Container();
                        }
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    children: [
                      Text(
                        user.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 16),
                      ),
                      GestureDetector(
                        onTap: () => cardKey.currentState.toggleCard(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'Voir plus',
                              style: TextStyle(fontSize: 13, fontStyle: FontStyle.italic),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 8),
                              child: Icon(Icons.trending_flat, size: 18),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        HobbiesColumn(
                          iconName: 'heart.png',
                          title: 'Aime',
                          hobbies: user.likedHobbies,
                          border: true,
                        ),
                        HobbiesColumn(
                          iconName: 'broken_heart.png',
                          title: 'N\'aime pas',
                          hobbies: user.dislikedHobbies,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
      ),
      back: BorderBox(
        child: Container(
          decoration: BoxDecoration(color: Colors.white),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: GestureDetector(
              onTap: () => cardKey.currentState.toggleCard(),
              child: SingleChildScrollView(
                child: Text(
                  user.description,
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
