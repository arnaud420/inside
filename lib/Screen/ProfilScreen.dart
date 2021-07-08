import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inside/Blocs/Authentication/AuthenticationBloc.dart';
import 'package:inside/Blocs/Authentication/AuthenticationState.dart';
import 'package:inside/Blocs/Hobbies/HobbieBloc.dart';
import 'package:inside/Blocs/Hobbies/HobbieEvent.dart';
import 'package:inside/Blocs/Hobbies/HobbieState.dart';
import 'package:inside/Config/colors.dart';
import 'package:inside/Helpers/UserHelper.dart';
import 'package:inside/Models/User.dart';
import 'package:inside/Widget/AppBar/AppBarSmallLogo.dart';
import 'package:inside/Widget/Layouts/LayoutBorder.dart';
import 'package:inside/Widget/Profil/HobbiesList.dart';
import 'package:inside/Widget/Texts/Badge.dart';

class ProfilScreen extends StatelessWidget {
  final User user;
  const ProfilScreen(this.user);

  @override
  Widget build(BuildContext context) {
    List likedHobbies = user.likedHobbies.map((document) => document.documentID).toList();
    List dislikedHobbies = user.dislikedHobbies.map((document) => document.documentID).toList();

    return Scaffold(
      body: LayoutBorder(child: ListView(children: <Widget>[
        AppBarSmallLogo(hasArrowBack: true),
        Container(
          padding: const EdgeInsets.all(10),
          child: Column(     
            crossAxisAlignment: CrossAxisAlignment.start,     
            children: <Widget>[

              TopProfilWidget(user),

              Container(
                padding: const EdgeInsets.all(15),
                child: Text(user.description, textAlign: TextAlign.justify),
              ),

              Container(
                padding: const EdgeInsets.all(15),
                child: BlocProvider<HobbieBloc>(
                  builder: (context) => HobbieBloc()..add(getHobbies()),
                  child: BlocBuilder<HobbieBloc, HobbieState>(
                  builder: (context, state) {
                    if (state is LoadedHobbies) {
                      return Column(children: <Widget>[
                        likedHobbies.length >= 1 ? HobbiesList('Aime', likedHobbies, state) : Container(),
                        dislikedHobbies.length >= 1 ? HobbiesList('N\'aime pas', dislikedHobbies, state) : Container(),
                      ]);
                    }
                    return CircularProgressIndicator();
                  },
                  ),
                ), 
              ),

          ]),
          )
        ]))
    );
  }
}

class TopProfilWidget extends StatelessWidget {
  final User user;
  const TopProfilWidget(this.user);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
         builder: (context, authState) {
            if (authState is Authenticated) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Badge(color: InsideColors.lightBlue, text: '${UserHelper().getAge(user.birthDate)} ans'),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center, 
                    children: <Widget>[
                      ClipOval(
                        child: Image.network(
                          user.photo,
                          width: 150,
                          fit: BoxFit.contain,
                        ),
                      ),
                      Container(
                        width: 150,
                        child: Center(
                          child: Text(
                            '${user.firstname} ${user.lastname}', 
                            overflow: TextOverflow.ellipsis, 
                            maxLines: 2, 
                            style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center
                          )
                      )
                  )]),
                  Badge(color: InsideColors.pink, text: '${UserHelper().getDistanceBetweenPoints(user.lastLocation['geopoint'], authState.user.lastLocation['geopoint']).toStringAsFixed(0)} km'),
              ]);
            }
            return Container();
          }
      )
    );
  }
}
