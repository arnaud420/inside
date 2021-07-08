import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:inside/Blocs/Hobbies/HobbieBloc.dart';
import 'package:inside/Blocs/Hobbies/HobbieEvent.dart';
import 'package:inside/Blocs/Main/MainBloc.dart';
import 'package:inside/Blocs/Main/MainEvent.dart';
import 'package:inside/Blocs/Matchs/MatchBloc.dart';
import 'package:inside/Config/colors.dart';
import 'package:inside/Repositories/UserRepository.dart';
import 'package:inside/Widget/AppBar/MainAppBar.dart';
import 'package:inside/Widget/Blocs/SwipableCard.dart';
import 'package:inside/Widget/Layouts/InsideScaffold.dart';

class MainScreen extends StatefulWidget {
  final UserRepository _userRepository;

  MainScreen({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with WidgetsBindingObserver {
  final CardController cardController = CardController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    widget._userRepository.sendLocation();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      widget._userRepository.sendLocation();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MainBloc>(
          builder: (context) => MainBloc(userRepository: widget._userRepository)
            ..add(SearchPotentialMatches()),
        ),
        BlocProvider<MatchBloc>(
            builder: (context) =>
                MatchBloc(userRepository: widget._userRepository)),
      ],
      child: InsideScaffold(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  MainAppBar(),
                  BlocProvider<HobbieBloc>(
                      builder: (context) => HobbieBloc()..add(getHobbies()),
                      child: SwipableCard(
                        cardController: cardController,
                      )),
                  Row(
                    children: <Widget>[
                      _EmotionButton(
                        icon: Icons.close,
                        iconColor: InsideColors.blue,
                        onPressed: () {
                          cardController.triggerLeft();
                        },
                      ),
                      _EmotionButton(
                        icon: Icons.favorite,
                        iconColor: InsideColors.burgundy,
                        onPressed: () {
                          cardController.triggerRight();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _EmotionButton extends StatelessWidget {
  final IconData icon;
  final MaterialColor iconColor;
  final Function onPressed;

  _EmotionButton({
    @required this.icon,
    @required this.iconColor,
    @required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FlatButton(
        padding: EdgeInsets.symmetric(vertical: 15),
        child: Icon(
          icon,
          color: iconColor,
          size: 45,
        ),
        onPressed: onPressed,
      ),
    );
  }
}
