import 'package:equatable/equatable.dart';

abstract class MatchEvent extends Equatable {
  const MatchEvent();

  @override
  List<Object> get props => [];
}

class ResetMatch extends MatchEvent {}

class LikeUser extends MatchEvent {
  final targetId;

  LikeUser({ this.targetId });
}

class DislikeUser extends MatchEvent {
  final targetId;

  DislikeUser({ this.targetId });
}