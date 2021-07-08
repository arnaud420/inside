import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:inside/Models/User.dart';
import 'package:inside/Repositories/ChatRepository.dart';
import 'package:inside/Repositories/UserRepository.dart';
import 'ChatEvent.dart';
import 'ChatState.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository _chatRepository;
  final UserRepository _userRepository;
  
  ChatBloc({@required UserRepository userRepository, @required ChatRepository chatRepository})
      : assert(userRepository != null && chatRepository != null),
        _userRepository = userRepository,
        _chatRepository = chatRepository;

  @override
  ChatState get initialState => ChatState.inital();

  @override
  Stream<ChatState> mapEventToState(ChatEvent event) async* {
    if (event is FetchMatchs) {
      yield* _mapFetchMatchsToState();
    }
    if (event is OpenChat) {
      yield* _mapOpenChatToState(event.matchs, event.userMatched);
    }
    if (event is SendMessage) {
      yield* _mapSendMessageToState(event.message, event.state);
    }
  }

  Stream<ChatState> _mapFetchMatchsToState() async* {
    try {
      var currentUser = await _userRepository.getUser();
      List<User> matchs = await _userRepository.getMatchs(currentUser);
      matchs = matchs.length >= 1 ? matchs.reversed.toList() : matchs;
      yield ChatState.fetchMatchs(matchs);
    } catch(e) {
      print(e);
      yield ChatState.error(e);
    }
  }

  Stream<ChatState> _mapOpenChatToState(matchs, userMatch) async* {
    try {
      yield ChatState.openChat(matchs, userMatch);
    } catch(e) {
      print(e);
      yield ChatState.error(e);
    }
  }

  Stream<ChatState> _mapSendMessageToState(message, state) async* {
    if (message.length <= 0) return;
    User receiver = state.userMatched;

    try {
      User currentUser = await _userRepository.getUser();
      await _chatRepository.postMessage(message, currentUser, receiver);
      yield ChatState.openChat(state.matchs, receiver);
    } catch(e) {
      print(e);
      yield ChatState.error(e);
    }
  }

}