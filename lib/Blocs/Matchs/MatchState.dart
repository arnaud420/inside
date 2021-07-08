import 'package:equatable/equatable.dart';
import 'package:inside/Models/User.dart';

abstract class MatchState extends Equatable {
  const MatchState();

  @override
  List<Object> get props => [];
}

class NoMatchActions extends MatchState {}

class SendingMatch extends MatchState {}

class MatchSended extends MatchState {
  final User match;

  MatchSended({ this.match });
}

class MatchError extends MatchState {}