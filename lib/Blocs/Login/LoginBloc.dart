import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:inside/Blocs/Login/LoginEvent.dart';
import 'package:inside/Repositories/UserRepository.dart';
import 'LoginState.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  UserRepository _userRepository;

  LoginBloc({
    @required UserRepository userRepository,
  })  : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  LoginState get initialState => LoginState.empty();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
   if (event is LoginWithCredentials) {
     yield* _mapLoginWithCredentialsToState(
       email: event.email,
       password: event.password,
     );
   }
  }

  Stream<LoginState> _mapLoginWithCredentialsToState({String email, String password}) async* {
    yield LoginState.loading();
    try {
      await _userRepository.signInWithCredentials(email, password);
      yield LoginState.success();
    } catch (_) {
      yield LoginState.error();
    }
  }
}