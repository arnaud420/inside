import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:inside/Models/Hobbie.dart';
import 'RegisterEvent.dart';
import 'package:inside/Repositories/UserRepository.dart';
import 'RegisterState.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  UserRepository _userRepository;

  RegisterBloc({
    @required UserRepository userRepository,
  })  : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  RegisterState get initialState => RegisterState.empty();

  @override
  Stream<RegisterState> mapEventToState(RegisterEvent event) async* {
    if (event is RegisterUser) {
      yield* _mapRegisterUserToState(
        email: event.email,
        password: event.password,
        dateOfBirth: event.dateOfBirth,
        firstname: event.firstname,
        lastname: event.lastname,
        description: event.description,
        hobbiesLiked: event.hobbiesLiked,
        hobbiesDisliked: event.hobbiesDisliked,
        photo: event.photo,
        ageMin: event.ageMin,
        ageMax: event.ageMax,
        distance: event.distance,
      );
    } else if (event is UpdateUser) {
      yield* _mapUpdateUserToState(
        dateOfBirth: event.dateOfBirth,
        firstname: event.firstname,
        lastname: event.lastname,
        description: event.description,
        hobbiesLiked: event.hobbiesLiked,
        hobbiesDisliked: event.hobbiesDisliked,
        photo: event.photo,
        ageMin: event.ageMin,
        ageMax: event.ageMax,
        distance: event.distance,
      );
    }
  }

  Stream<RegisterState> _mapRegisterUserToState({
    String email,
    String password,
    String dateOfBirth,
    String firstname,
    String lastname,
    String description,
    List<Hobbie> hobbiesLiked,
    List<Hobbie> hobbiesDisliked,
    File photo,
    String ageMin,
    String ageMax,
    String distance,
  }) async* {
    yield RegisterState.loading();
    try {
      await _userRepository.signUp(email, password);
      FirebaseUser currentUser = await _userRepository.getFirebaseUser();
      String id = currentUser.uid;
      await _userRepository.registerFullUser(
        id,
        dateOfBirth,
        firstname,
        lastname,
        description,
        hobbiesLiked,
        hobbiesDisliked,
        photo,
        ageMin,
        ageMax,
        distance,
      );
      yield RegisterState.success();
    } catch (e) {
      FirebaseUser currentUser = await _userRepository.getFirebaseUser();
      try {
        await _userRepository.signOut();
        await currentUser.delete();
      } catch (_) {
        print("error while deleting a user: $e");
        yield RegisterState.error();
      }
      print("error while creating a user: $e");
      yield RegisterState.error();
    }
  }

  Stream<RegisterState> _mapUpdateUserToState({
    String dateOfBirth,
    String firstname,
    String lastname,
    String description,
    List<Hobbie> hobbiesLiked,
    List<Hobbie> hobbiesDisliked,
    File photo,
    String ageMin,
    String ageMax,
    String distance,
  }) async* {
    yield RegisterState.loading();
    try {
      FirebaseUser currentUser = await _userRepository.getFirebaseUser();
      String id = currentUser.uid;
      await _userRepository.updateFullUser(
        id,
        dateOfBirth,
        firstname,
        lastname,
        description,
        hobbiesLiked,
        hobbiesDisliked,
        photo,
        ageMin,
        ageMax,
        distance,
      );
      yield RegisterState.success();
    } catch (e) {
      print("error while updating a user: $e");
      yield RegisterState.error();
    }
  }
}
