import 'package:equatable/equatable.dart';
import 'package:inside/Models/User.dart';

abstract class MainState extends Equatable {
  const MainState();

  @override
  List<Object> get props => [];
}

class Loading extends MainState {}

class Loaded extends MainState {
  final List<User> users;

  Loaded({this.users});

  @override
  List<Object> get props => [users];
}

class LoadingError extends MainState {}