import 'package:equatable/equatable.dart';
import 'package:inside/Models/User.dart';
abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class FetchMatchs extends ChatEvent {}

class OpenChat extends ChatEvent {
  final List<User> matchs;
  final User userMatched;
  const OpenChat(this.matchs, this.userMatched);
}

class SendMessage extends ChatEvent {
  final String message;
  final state;
  const SendMessage(this.message, this.state);
}