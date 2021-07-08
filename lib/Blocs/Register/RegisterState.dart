import 'package:flutter/material.dart';

class RegisterState {
  final bool loading;
  final bool success;
  final bool error;

  const RegisterState({
    @required this.loading,
    @required this.success,
    @required this.error,
  });

  factory RegisterState.empty() {
    return RegisterState(
      loading: false,
      success: false,
      error: false,
    );
  }

  factory RegisterState.loading() {
    return RegisterState(
      loading: true,
      success: false,
      error: false,
    );
  }

  factory RegisterState.success() {
    return RegisterState(
      loading: false,
      success: true,
      error: false,
    );
  }

  factory RegisterState.error() {
    return RegisterState(
      loading: false,
      success: false,
      error: true,
    );
  }
}
