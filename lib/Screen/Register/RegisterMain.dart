import 'dart:io';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inside/Blocs/Authentication/AuthenticationBloc.dart';
import 'package:inside/Blocs/Authentication/AuthenticationEvent.dart';
import 'package:inside/Blocs/Register/RegisterBloc.dart';
import 'package:inside/Blocs/Register/RegisterEvent.dart';
import 'package:inside/Blocs/Register/RegisterState.dart';
import 'package:inside/Config/colors.dart';
import 'package:inside/Models/Hobbie.dart';
import 'package:inside/Screen/Register/StepFour.dart';
import 'package:inside/Screen/Register/StepOne.dart';
import 'package:inside/Screen/Register/StepThree.dart';
import 'package:inside/Screen/Register/StepTwo.dart';
import 'package:inside/Repositories/UserRepository.dart';
import 'package:inside/Widget/Layouts/InsideScaffold.dart';
import 'package:inside/Widget/Layouts/LayoutBorder.dart';

import 'PageContainer.dart';

class RegisterScreenProps {
  final String title;

  RegisterScreenProps({this.title});
}

class RegisterScreen extends StatefulWidget {
  final UserRepository userRepository;

  RegisterScreen({@required this.userRepository})
      : assert(userRepository != null);

  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  PageController _step = PageController();
  double currentStep = 0.0;
  final _stepOneFormKey = GlobalKey<FormState>();
  final _stepTwoFormKey = GlobalKey<FormState>();
  final _stepThreeFormKey = GlobalKey<FormState>();
  final _stepFourFormKey = GlobalKey<FormState>();

  String _email;
  String _password;
  String _dateOfBirth;
  String _firstname;
  String _lastname;
  String _description;
  String _distance;
  File _photo;
  String _ageMin;
  String _ageMax;
  List<Hobbie> _hobbiesLiked = [];
  List<Hobbie> _hobbiesDisliked = [];

  bool _errorHobbie = false;
  bool _errorPhoto = false;

  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  RegisterBloc _registerBloc;

  @override
  initState() {
    super.initState();
    _step.addListener(_onStepChange);
    _registerBloc = BlocProvider.of<RegisterBloc>(context);
    _distance = '10';
    _ageMin = '18';
    _ageMax = '70';
  }

  _onStepChange() {
    setState(() {
      currentStep = _step.page;
    });
  }

  @override
  Widget build(BuildContext context) {

    return InsideScaffold(
      child: LayoutBorder(
        child: BlocListener<RegisterBloc, RegisterState>(
          listener: (context, state) {
            if (state.success) {
              BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
              Navigator.pushNamed(context, '/');
            }
            if (state.error) {
              _getFlushBar(context);
            }
          },
          child: BlocBuilder<RegisterBloc, RegisterState>(
            builder: (context, state) {
              return Stack(
                children: <Widget>[
                  //(state.error ? _getFlushBar(context) : SizedBox()),
                  PageView(
                    physics: NeverScrollableScrollPhysics(),
                    controller: _step,
                    children: <Widget>[
                      PagerContainer(
                        stepWidget: StepOne(
                          formKey: _stepOneFormKey,
                          firstnameController: _firstnameController,
                          lastnameController: _lastnameController,
                          emailController: _emailController,
                          dateOfBirthController: _dateOfBirthController,
                          passwordController: _passwordController,
                        ),
                        step: _step,
                        currentStep: currentStep,
                        formKey: _stepOneFormKey,
                        validateForm: () => stepOneValidated(),
                      ),
                      PagerContainer(
                        stepWidget: StepTwo(
                          formKey: _stepTwoFormKey,
                          descriptionController: _descriptionController,
                          pictureError: _errorPhoto,
                          picture: _photo,
                          setPicture: (File photo) => _setPhoto(photo),
                        ),
                        step: _step,
                        currentStep: currentStep,
                        formKey: _stepTwoFormKey,
                        validateForm: () => stepTwoValidated(),
                      ),
                      PagerContainer(
                        stepWidget: StepThree(
                          formKey: _stepThreeFormKey,
                          errorHobbie: _errorHobbie,
                          hobbiesLiked: _hobbiesLiked,
                          hobbiesDisliked: _hobbiesDisliked,
                          setHobbieLiked: (Hobbie hobbie) =>
                              _setLikedHobbie(hobbie),
                          setHobbieDisliked: (Hobbie hobbie) =>
                              _setDislikedHobbie(hobbie),
                          removeHobbie: (Hobbie hobbie) =>
                              _removeHobbie(hobbie),
                        ),
                        step: _step,
                        currentStep: currentStep,
                        formKey: _stepThreeFormKey,
                        validateForm: () => stepThreeValidated(),
                      ),
                      PagerContainer(
                        stepWidget: StepFour(
                          formKey: _stepFourFormKey,
                          ageMin: _ageMin,
                          ageMax: _ageMax,
                          distance: _distance,
                          setAge: (bool isAgeMin, String age) =>
                              _setAge(isAgeMin, age),
                          setDistance: (String distance) =>
                              _setDistance(distance),
                        ),
                        step: _step,
                        currentStep: currentStep,
                        formKey: _stepFourFormKey,
                        validateForm: () => stepFourValidated(),
                      ),
                    ],
                  ),
                  state.loading
                      ? Container(
                          color: InsideColors.darkGrey.withOpacity(0.5),
                        )
                      : SizedBox(),
                  state.loading
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : SizedBox(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Flushbar<Object> _getFlushBar(BuildContext context) {
    return Flushbar(
      backgroundColor: InsideColors.burgundy,
      flushbarPosition: FlushbarPosition.BOTTOM,
      titleText: Text(
        'Erreur',
        style: TextStyle(color: Colors.white),
      ),
      messageText: Text(
        'Une erreur est intervenue lors de l\'inscription. Veuillez réessayer ultérieurement !',
        style: TextStyle(color: Colors.white),
      ),
      duration: Duration(seconds: 3),
    )..show(context);
  }

  stepOneValidated() {
    setState(() {
      _firstname = _firstnameController.text;
      _lastname = _lastnameController.text;
      _dateOfBirth = _dateOfBirthController.text;
      _email = _emailController.text;
      _password = _passwordController.text;
    });

    return true;
  }

  stepTwoValidated() {
    if (_photo == null) {
      setState(() {
        _errorPhoto = true;
      });

      return false;
    }
    setState(() {
      _description = _descriptionController.text;
    });

    return true;
  }

  stepThreeValidated() {
    if (_hobbiesLiked.length == 0 && _hobbiesDisliked.length == 0) {
      setState(() {
        _errorHobbie = true;
      });

      return false;
    }

    return true;
  }

  stepFourValidated() {
    if (_ageMin == null ||
        _ageMax == null) {
      return false;
    }

    _registerBloc.add(RegisterUser(
      email: _email,
      password: _password,
      ageMax: _ageMax,
      ageMin: _ageMin,
      dateOfBirth: _dateOfBirth,
      description: _description,
      firstname: _firstname,
      hobbiesLiked: _hobbiesLiked,
      hobbiesDisliked: _hobbiesDisliked,
      lastname: _lastname,
      photo: _photo,
      distance: _distance
    ));
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
      if (hobbie == hobbieLiked) {
        setState(() {
          _hobbiesLiked.remove(hobbieLiked);
        });
      }
    });
    _hobbiesDisliked.forEach((Hobbie hobbieDisliked) {
      if (hobbie == hobbieDisliked) {
        setState(() {
          _hobbiesDisliked.remove(hobbieDisliked);
        });
      }
    });
  }
}
