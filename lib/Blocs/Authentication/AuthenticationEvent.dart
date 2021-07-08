import 'package:equatable/equatable.dart';
import 'package:inside/Models/User.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class AppStarted extends AuthenticationEvent {}

class LoggedIn extends AuthenticationEvent {}

class LoggedOut extends AuthenticationEvent {}

class TestLoggedIn extends AuthenticationEvent {
  final User user;

  TestLoggedIn({this.user});
}
