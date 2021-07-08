import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:inside/Models/Hobbie.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class RegisterUser extends RegisterEvent {
  final String email, password, dateOfBirth, firstname, lastname, description, ageMin, ageMax, distance;
  final List<Hobbie> hobbiesLiked;
  final List<Hobbie> hobbiesDisliked;
  final File photo;

  RegisterUser({@required this.email, @required this.password, @required this.dateOfBirth, @required this.firstname, @required this.lastname, @required this.description, @required this.hobbiesLiked, @required this.hobbiesDisliked, @required this.photo, @required this.ageMin, @required this.ageMax, @required this.distance});

  @override
  List<Object> get props => [email, password];
}

class UpdateUser extends RegisterEvent {
  final String dateOfBirth, firstname, lastname, description, ageMin, ageMax, distance;
  final List<Hobbie> hobbiesLiked;
  final List<Hobbie> hobbiesDisliked;
  final File photo;

  UpdateUser({@required this.dateOfBirth, @required this.firstname, @required this.lastname, @required this.description, @required this.hobbiesLiked, @required this.hobbiesDisliked, @required this.photo, @required this.ageMin, @required this.ageMax, @required this.distance});
}
