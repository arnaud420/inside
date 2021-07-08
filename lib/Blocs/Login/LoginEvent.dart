import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class LoginWithCredentials extends LoginEvent {
  final String email;
  final String password;

  const LoginWithCredentials({
    @required this.email,
    @required this.password,
  });

  @override
  List<Object> get props => [email, password];
}
