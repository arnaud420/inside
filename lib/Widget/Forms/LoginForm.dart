import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inside/Blocs/Authentication/AuthenticationBloc.dart';
import 'package:inside/Blocs/Authentication/AuthenticationEvent.dart';
import 'package:inside/Blocs/Login/LoginBloc.dart';
import 'package:inside/Blocs/Login/LoginEvent.dart';
import 'package:inside/Blocs/Login/LoginState.dart';
import 'package:inside/Config/colors.dart';
import 'package:inside/Widget/Forms/EmailInput.dart';
import 'package:inside/Widget/Forms/PasswordInput.dart';
import 'package:inside/Widget/RoundedButton.dart';

class LoginForm extends StatefulWidget {
  @override
  LoginFormState createState() => LoginFormState();
}

class LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginBloc _loginBloc;

  @override
  void initState() {
    super.initState();
    _loginBloc = BlocProvider.of<LoginBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.success) {
          BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
          Navigator.pushNamed(context, '/');
        }
        if (state.error) {
          _getFlushBar(context);
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return Padding(
            padding: EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  EmailInput(controller: _emailController),
                  PasswordInput(controller: _passwordController),
                  RoundedButton(
                    title: 'Se connecter',
                    backgroundColor: InsideColors.burgundy,
                    action: () {
                      if (_formKey.currentState.validate()) {
                        _loginBloc.add(
                          LoginWithCredentials(
                            email: _emailController.text,
                            password: _passwordController.text,
                          ),
                        );
                      }
                    },
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: 30),
                      child: state.loading
                          ? CircularProgressIndicator()
                          : Container()),
                  // Text(
                  //   state.error ? 'Identifiants invalides' : '',
                  //   style: TextStyle(color: InsideColors.burgundy),
                  // ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Flushbar<Object> _getFlushBar(BuildContext context) {
    return Flushbar(
      backgroundColor: InsideColors.burgundy,
      flushbarPosition: FlushbarPosition.BOTTOM,
      titleText: Text(
        'Erreur',
        style: TextStyle(color: Colors.white),
      ),
      messageText: Text(
        'Une erreur est intervenue lors de la connexion. Veuillez réessayer ultérieurement !',
        style: TextStyle(color: Colors.white),
      ),
      duration: Duration(seconds: 3),
    )..show(context);
  }
}
