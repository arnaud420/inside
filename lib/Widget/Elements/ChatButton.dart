import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inside/Blocs/Matchs/MatchBloc.dart';
import 'package:inside/Blocs/Matchs/MatchState.dart';
import 'package:inside/Config/colors.dart';
import 'package:inside/Models/User.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:simple_animations/simple_animations/controlled_animation.dart';

class ChatButton extends StatefulWidget {
  @override
  _ChatButtonState createState() => _ChatButtonState();
}

class _ChatButtonState extends State<ChatButton> with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation<double> animation;

  User _match;

  @override
  void initState() {
    super.initState();
    _match = null;
    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5),
    )..addListener(() => setState(() {}));
    animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOut,
    );

    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MatchBloc, MatchState>(
      listener: (context, state) {
        if (state is MatchSended && state.match != null) {
          setState(() { _match = state.match; });
        } else if (state is NoMatchActions) {
          setState(() { _match = null; });
        }
      },
      child: BlocBuilder<MatchBloc, MatchState>(
        builder: (context, matchState) {
          return Container(
            width: 55,
            child: Stack(
              children: <Widget>[
                IconButton(
                  icon: Image.asset('assets/chat_love.png'),
                  onPressed: () {
                    Navigator.pushNamed(context, '/chat')
                        .then((value) => setState(() => _match = null));
                  },
                  iconSize: 45,
                ),
                Container(
                  child: _match != null
                    ? ControlledAnimation(
                        playback: Playback.MIRROR,
                        duration: Duration(seconds: 1),
                        tween: Tween(begin: 15.0, end: 17.0),
                        builder: (context, size) => Positioned(
                          right: 2,
                          top: 4,
                          child: Container(
                            height: size,
                            width: size,
                            decoration: BoxDecoration(
                              color: InsideColors.burgundy,
                              borderRadius: new BorderRadius.circular(40),
                            ),
                          ),
                        ),
                      )
                    : null,
                ),
              ],
            ),
          );
      }),
    );
  }
}