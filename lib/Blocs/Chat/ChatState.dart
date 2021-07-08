import 'package:inside/Models/User.dart';

class ChatState {
  final List<User> matchs;
  final User userMatched;
  final bool isLoading;
  final bool error;

  const ChatState({this.matchs, this.userMatched, this.isLoading, this.error});
  
  factory ChatState.fetchMatchs(matchs) {
    return ChatState(
      matchs: matchs, 
      userMatched: matchs.length >= 1 ? matchs[0] : null,
      isLoading: false,
      error: false,
    );
  }

  factory ChatState.inital() {
    return ChatState(
      matchs: null,
      userMatched: null,
      isLoading: true,
      error: false,
    );
  }

  factory ChatState.error(error) {
    return ChatState(
      matchs: null,
      error: true,
      isLoading: false
    );
  }

  factory ChatState.openChat(matchs, userMatched) {
    return ChatState(
      matchs: matchs,
      userMatched: userMatched,
      isLoading: false,
      error: false,
    );
  }
}