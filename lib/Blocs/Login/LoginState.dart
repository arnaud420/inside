import 'package:flutter/material.dart';

class LoginState {
  final bool loading;
  final bool success;
  final bool error;

  const LoginState({
    @required this.loading,
    @required this.success,
    @required this.error,
  });

  factory LoginState.empty() {
    return LoginState(
      loading: false,
      success: false,
      error: false,
    );
  }

  factory LoginState.loading() {
    return LoginState(
      loading: true,
      success: false,
      error: false,
    );
  }

  factory LoginState.success() {
    return LoginState(
      loading: false,
      success: true,
      error: false,
    );
  }

  factory LoginState.error() {
    return LoginState(
      loading: false,
      success: false,
      error: true,
    );
  }
}
