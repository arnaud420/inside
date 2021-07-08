import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inside/Blocs/Login/LoginBloc.dart';
import 'package:inside/Repositories/UserRepository.dart';
import 'package:inside/Widget/AppBar/AppBarBigLogo.dart';
import 'package:inside/Widget/Forms/LoginForm.dart';
import 'package:inside/Widget/Layouts/InsideScaffold.dart';
import 'package:inside/Widget/Layouts/LayoutBorder.dart';
import 'package:inside/Widget/Texts/BigTitle.dart';

class LoginScreen extends StatelessWidget {
  final UserRepository _userRepository;

  LoginScreen({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return InsideScaffold(
      child: LayoutBorder(
        child: SingleChildScrollView(
          child: Column(
            children: [
              AppBarBigLogo(hasArrowBack: true),
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: BigTitle(title: 'Connexion'),
                  ),
                  BlocProvider<LoginBloc>(
                    builder: (context) => LoginBloc(userRepository: _userRepository),
                    child: LoginForm(),
                  )
                ]
              )
            ],
          ),
        )
      ),
    );
  }
}