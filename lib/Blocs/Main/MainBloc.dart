import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:inside/Blocs/Main/MainEvent.dart';
import 'package:inside/Blocs/Main/MainState.dart';
import 'package:inside/Models/User.dart';
import 'package:inside/Repositories/UserRepository.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  UserRepository _userRepository;

  MainBloc({@required userRepository})
    : assert(userRepository != null),
      _userRepository = userRepository;


  @override
  MainState get initialState => Loading();

  @override
  Stream<MainState> mapEventToState(MainEvent event) async* {
    if (event is SearchPotentialMatches) {
      yield* _mapSearchPotentialMatchesToState();
    }
  }

  Stream<MainState> _mapSearchPotentialMatchesToState() async* {
    yield Loading();
    try {
      User currentUser = await _userRepository.getUser();
      List<User> users = await _userRepository.getPotentialsMatches(currentUser);

      yield Loaded(users: users);
    } catch (e) {
      print('Error while fetching potential matches : $e');
      yield LoadingError();
    }
  }
}