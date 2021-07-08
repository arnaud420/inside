import 'dart:io';

import 'package:flutter/material.dart';
import 'package:inside/Models/Hobbie.dart';
import 'package:inside/Models/User.dart';
import 'package:inside/Screen/Register/StepFour.dart';
import 'package:inside/Screen/Register/StepOne.dart';
import 'package:inside/Screen/Register/StepThree.dart';
import 'package:inside/Screen/Register/StepTwo.dart';
import 'package:inside/Widget/Elements/ExpandableItem.dart';

class SettingsItems extends StatefulWidget {
  final User currentUser;
  final GlobalKey<FormState> stepOneFormKey,
      stepTwoFormKey,
      stepThreeFormKey,
      stepFourFormKey;
  final String distance, ageMin, ageMax;
  final File photo;
  final List<Hobbie> hobbiesLiked, hobbiesDisliked;
  final bool errorHobbie, errorPhoto;
  final TextEditingController firstnameController,
      lastnameController,
      dateOfBirthController,
      descriptionController;
  final Function setPhoto,
      setAge,
      setDistance,
      setLikedHobbie,
      setDislikedHobbie,
      removeHobbie;

  SettingsItems({
    @required this.currentUser,
    @required this.stepOneFormKey,
    @required this.stepTwoFormKey,
    @required this.stepThreeFormKey,
    @required this.stepFourFormKey,
    @required this.distance,
    @required this.ageMin,
    @required this.ageMax,
    @required this.photo,
    @required this.hobbiesLiked,
    @required this.hobbiesDisliked,
    @required this.firstnameController,
    @required this.lastnameController,
    @required this.dateOfBirthController,
    @required this.descriptionController,
    @required this.errorHobbie,
    @required this.errorPhoto,
    @required this.removeHobbie,
    @required this.setAge,
    @required this.setDislikedHobbie,
    @required this.setDistance,
    @required this.setLikedHobbie,
    @required this.setPhoto,
  });

  _SettingsItemsState createState() => _SettingsItemsState();
}

class _SettingsItemsState extends State<SettingsItems> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: (widget.currentUser == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(bottom: 1),
                  child: ExpandableItem(
                    headerTitle: 'Profil',
                    child: StepOne(
                      formKey: widget.stepOneFormKey,
                      dateOfBirthController: widget.dateOfBirthController,
                      firstnameController: widget.firstnameController,
                      lastnameController: widget.lastnameController,
                      hasPassword: false,
                      hasEmail: false,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 1),
                  child: ExpandableItem(
                    headerTitle: 'Photo et description',
                    child: StepTwo(
                      formKey: widget.stepTwoFormKey,
                      descriptionController: widget.descriptionController,
                      picture: widget.photo,
                      setPicture: (File photo) => widget.setPhoto(photo),
                      isImageFromFile: true,
                      url: widget.currentUser.photo,
                      pictureError: widget.errorPhoto,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 1),
                  child: ExpandableItem(
                    headerTitle: 'Centres d\'intérêt',
                    child: StepThree(
                      formKey: widget.stepThreeFormKey,
                      hobbiesLiked: widget.currentUser.likedHobbies,
                      hobbiesDisliked: widget.currentUser.dislikedHobbies,
                      errorHobbie: widget.errorHobbie,
                      setHobbieLiked: (Hobbie hobbie) =>
                          widget.setLikedHobbie(hobbie),
                      setHobbieDisliked: (Hobbie hobbie) =>
                          widget.setDislikedHobbie(hobbie),
                      removeHobbie: (Hobbie hobbie) =>
                          widget.removeHobbie(hobbie),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 1),
                  child: ExpandableItem(
                    headerTitle: 'Préférences de recherche',
                    child: StepFour(
                      formKey: widget.stepFourFormKey,
                      ageMax: widget.currentUser.ageMax,
                      ageMin: widget.currentUser.ageMin,
                      distance: widget.currentUser.distance,
                      setAge: (bool isAgeMin, String age) =>
                          widget.setAge(isAgeMin, age),
                      setDistance: (String distance) => widget.setDistance(distance),
                    ),
                  ),
                ),
              ],
            )),
    );
  }
}
