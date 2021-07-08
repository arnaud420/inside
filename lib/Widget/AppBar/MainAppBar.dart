import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inside/Blocs/Authentication/AuthenticationBloc.dart';
import 'package:inside/Config/colors.dart';
import 'package:inside/Repositories/UserRepository.dart';
import 'package:inside/Screen/Settings/SettingsScreen.dart';
import 'package:inside/Widget/Elements/ChatButton.dart';

class MainAppBar extends StatefulWidget {
  @override
  _MainAppBarState createState() => new _MainAppBarState();
}

class _MainAppBarState extends State<MainAppBar> {
  AuthenticationBloc _appBloc;

  @override
  void initState() {
    super.initState();
    _appBloc = BlocProvider.of<AuthenticationBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          ChatButton(),
          Image.asset('assets/inside_logo.png', width: 70),
          IconButton(
            alignment: Alignment.center,
            icon: Icon(
              Icons.account_circle,
              color: InsideColors.blue,
            ),
            iconSize: 45,
            onPressed: () => _showSettingsScreen(context, _appBloc),
          )
        ],
      ),
    );
  }

  _showSettingsScreen(BuildContext context, AuthenticationBloc authBloc) {
    return showBottomSheet(
      context: context,
      builder: (context) {
        return SettingsScreen(authBloc: authBloc);
      },
    );
  }
}
