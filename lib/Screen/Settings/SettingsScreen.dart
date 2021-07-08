import 'dart:io';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inside/Blocs/Authentication/AuthenticationBloc.dart';
import 'package:inside/Blocs/Authentication/AuthenticationEvent.dart';
import 'package:inside/Blocs/Register/RegisterBloc.dart';
import 'package:inside/Blocs/Register/RegisterEvent.dart';
import 'package:inside/Blocs/Register/RegisterState.dart';
import 'package:inside/Config/colors.dart';
import 'package:inside/Helpers/DateHelper.dart';
import 'package:inside/Models/Hobbie.dart';
import 'package:inside/Models/User.dart';
import 'package:inside/Repositories/UserRepository.dart';
import 'package:inside/Widget/AppBarSmallLogo.dart';
import 'package:inside/Widget/Layouts/InsideScaffold.dart';
import 'package:inside/Widget/Layouts/LayoutBorder.dart';
import 'package:inside/Widget/RoundedButton.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'SettingsItems.dart';

class SettingsScreen extends StatefulWidget {
  final AuthenticationBloc authBloc;

  SettingsScreen({this.authBloc});

  @override
  SettingsScreenState createState() => new SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  User _currentUser;

  final _stepOneFormKey = GlobalKey<FormState>();
  final _stepTwoFormKey = GlobalKey<FormState>();
  final _stepThreeFormKey = GlobalKey<FormState>();
  final _stepFourFormKey = GlobalKey<FormState>();
  String _distance, _ageMin, _ageMax;
  File _photo;
  List<Hobbie> _hobbiesLiked = [];
  List<Hobbie> _hobbiesDisliked = [];

  bool _errorHobbie = false;
  bool _errorPhoto = false;

  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  RegisterBloc _registerBloc;

  @override
  initState() {
    super.initState();
    _registerBloc = BlocProvider.of<RegisterBloc>(context);
    UserRepository().getUserWithHobbies().then((user) {
      setState(() {
        _currentUser = user;
        _firstnameController.text = user.firstname;
        _lastnameController.text = user.lastname;
        _dateOfBirthController.text =
            DateHelper.getStringFromTimestamp(user.birthDate);
        _descriptionController.text = user.description;
        _file(user.photo).then((File photo) {
          _photo = photo;
        });
        _ageMin = user.ageMin;
        _ageMax = user.ageMax;
        _distance = user.distance;
        _hobbiesLiked = user.likedHobbies;
        _hobbiesDisliked = user.dislikedHobbies;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return InsideScaffold(
      avoidBottomInset: false,
      child: LayoutBorder(
        child: BlocListener<RegisterBloc, RegisterState>(
          listener: (context, state) {
            if (state.success) {
              BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
              Navigator.pushNamed(context, '/');
              _getFlushBar(context, false, isSuccess: true);
            }
            if (state.error) {
              _getFlushBar(context, false);
            }
          },
          child: BlocBuilder<RegisterBloc, RegisterState>(
            builder: (context, state) {
              return SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    AppBarSmallLogo(
                      iconRight: Image.asset(
                        'assets/cross.png',
                        height: 25,
                        width: 25,
                        fit: BoxFit.scaleDown,
                      ),
                      iconRightAction: () => Navigator.pop(context),
                      iconLeft: Image.asset(
                        'assets/logout.png',
                        height: 40,
                        width: 40,
                        fit: BoxFit.scaleDown,
                      ),
                      iconLeftAction: () {
                        Navigator.pop(context);
                        widget.authBloc..add(LoggedOut());
                      },
                    ),
                    Column(
                      children: <Widget>[
                        SettingsItems(
                          currentUser: _currentUser,
                          descriptionController: _descriptionController,
                          ageMax: _ageMax,
                          ageMin: _ageMin,
                          dateOfBirthController: _dateOfBirthController,
                          distance: _distance,
                          firstnameController: _firstnameController,
                          hobbiesDisliked: _hobbiesDisliked,
                          hobbiesLiked: _hobbiesLiked,
                          lastnameController: _lastnameController,
                          photo: _photo,
                          stepFourFormKey: _stepFourFormKey,
                          stepOneFormKey: _stepOneFormKey,
                          stepThreeFormKey: _stepThreeFormKey,
                          stepTwoFormKey: _stepTwoFormKey,
                          errorHobbie: _errorHobbie,
                          errorPhoto: _errorPhoto,
                          setPhoto: (File photo) => _setPhoto(photo),
                          setAge: (bool isAgeMin, String age) =>
                              _setAge(isAgeMin, age),
                          setDistance: (String distance) =>
                              _setDistance(distance),
                          setLikedHobbie: (Hobbie hobbie) =>
                              _setLikedHobbie(hobbie),
                          setDislikedHobbie: (Hobbie hobbie) =>
                              _setDislikedHobbie(hobbie),
                          removeHobbie: (Hobbie hobbie) =>
                              _removeHobbie(hobbie),
                        ),
                        Padding(
                          padding: EdgeInsets.all(20),
                          child: RoundedButton(
                            title: 'Enregistrer',
                            backgroundColor: InsideColors.blue,
                            action: () => _saveChanges(context),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  _saveChanges(BuildContext context) {
    if (_hobbiesLiked.length == 0 && _hobbiesDisliked.length == 0) {
      setState(() {
        _errorHobbie = true;
      });
    }
    if ((_stepOneFormKey.currentState != null
            ? _stepOneFormKey.currentState.validate()
            : 1 == 1) &&
        (_stepTwoFormKey.currentState != null
            ? _stepTwoFormKey.currentState.validate()
            : 1 == 1) &&
        (_stepThreeFormKey.currentState != null
            ? _stepThreeFormKey.currentState.validate()
            : 1 == 1) &&
        (_stepFourFormKey.currentState != null
            ? _stepFourFormKey.currentState.validate()
            : 1 == 1) &&
        !_errorHobbie) {
      _registerBloc.add(UpdateUser(
          ageMin: _ageMin,
          ageMax: _ageMax,
          dateOfBirth: _dateOfBirthController.text,
          description: _descriptionController.text,
          distance: _distance,
          firstname: _firstnameController.text,
          hobbiesDisliked: _hobbiesDisliked,
          hobbiesLiked: _hobbiesLiked,
          lastname: _lastnameController.text,
          photo: _photo));
    } else {
      _getFlushBar(context, true);
    }
  }

  _setPhoto(File photo) {
    setState(() {
      _photo = photo;
    });
  }

  _setAge(bool isAgeMin, String age) {
    setState(() {
      if (isAgeMin) {
        _ageMin = age;
      } else {
        _ageMax = age;
      }
    });
  }

  _setDistance(String distance) {
    setState(() {
      _distance = distance;
    });
  }

  _setLikedHobbie(Hobbie hobbie) {
    setState(() {
      _hobbiesLiked.add(hobbie);
    });
  }

  _setDislikedHobbie(Hobbie hobbie) {
    setState(() {
      _hobbiesDisliked.add(hobbie);
    });
  }

  _removeHobbie(Hobbie hobbie) {
    _hobbiesLiked.forEach((Hobbie hobbieLiked) {
      if (hobbie.name == hobbieLiked.name) {
        setState(() {
          _hobbiesLiked.remove(hobbieLiked);
        });
      }
    });
    _hobbiesDisliked.forEach((Hobbie hobbieDisliked) {
      if (hobbie.name == hobbieDisliked.name) {
        setState(() {
          _hobbiesDisliked.remove(hobbieDisliked);
        });
      }
    });
  }

  Future<File> _file(String filename) async {
    Directory dir = await getApplicationDocumentsDirectory();
    String pathName = p.join(dir.path, filename);
    return File(pathName);
  }

  Flushbar<Object> _getFlushBar(BuildContext context, bool isNotComplete,
      {bool isSuccess = false}) {
    return Flushbar(
      backgroundColor: !isSuccess ? InsideColors.burgundy : InsideColors.blue,
      flushbarPosition: FlushbarPosition.TOP,
      titleText: Text(
        !isSuccess ? 'Erreur' : 'Succès',
        style: TextStyle(color: Colors.white),
      ),
      messageText: Text(
        isNotComplete && !isSuccess
            ? 'Veuillez remplir tous les champs requis'
            : (!isSuccess
                ? 'Une erreur est intervenue lors de la mise à jour de vos informations. Veuillez réessayer ultérieurement !'
                : 'Vos modifications ont bien été effectuées'),
        style: TextStyle(color: Colors.white),
      ),
      duration: Duration(seconds: 3),
    )..show(context);
  }
}
