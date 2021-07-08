import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:inside/Models/User.dart';
import 'package:inside/Repositories/UserRepository.dart';

import 'MatchEvent.dart';
import 'MatchState.dart';

class MatchBloc extends Bloc<MatchEvent, MatchState> {
  UserRepository _userRepository;

  MatchBloc({@required userRepository})
    : assert(userRepository != null),
      _userRepository = userRepository;


  @override
  MatchState get initialState => NoMatchActions();

  @override
  Stream<MatchState> mapEventToState(MatchEvent event) async* {
    if (event is LikeUser) {
      yield* _mapLikeUserToState(targetId: event.targetId);
    } else if (event is DislikeUser) {
      yield* _mapDislikeUserToState(targetId: event.targetId);
    } else if (event is ResetMatch) {
      yield* _mapResetMatchToState();
    }
  }

  Stream<MatchState> _mapLikeUserToState({String targetId}) async* {
    yield SendingMatch();
    try {
      await _userRepository.addLike(targetId);

      User match = await _userRepository.hasMatch(targetId);
      yield MatchSended(match: match);
    } catch (e) {
      print('Error while fetching potential matches : $e');
      yield MatchError();
    }
  }

  Stream<MatchState> _mapDislikeUserToState({String targetId}) async* {
    yield SendingMatch();
    try {
      await _userRepository.addDislike(targetId);

      yield MatchSended(match: null);
    } catch (e) {
      print('Error while sending dislike request : $e');
      yield MatchError();
    }
  }

  Stream<MatchState> _mapResetMatchToState() async* {
    yield NoMatchActions();
  }
}