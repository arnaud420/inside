import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:inside/Blocs/Main/MainBloc.dart';
import 'package:inside/Blocs/Main/MainEvent.dart';
import 'package:inside/Blocs/Main/MainState.dart';
import 'package:inside/Blocs/Matchs/MatchBloc.dart';
import 'package:inside/Blocs/Matchs/MatchEvent.dart';
import 'package:inside/Blocs/Matchs/MatchState.dart';
import 'package:inside/Config/colors.dart';
import 'package:inside/Models/User.dart';
import 'package:inside/Widget/Blocs/InsideCard.dart';

class SwipableCard extends StatefulWidget {
  final CardController cardController;

  SwipableCard({@required this.cardController});

  _SwipableCardState createState() => _SwipableCardState();
}

class _SwipableCardState extends State<SwipableCard> {
  MatchBloc _matchBloc;

  @override
  void initState() {
    super.initState();
    _matchBloc = BlocProvider.of<MatchBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainBloc, MainState>(
      builder: (context, mainState) {
        if (mainState is Loaded) {
          return BlocListener<MatchBloc, MatchState>(
            listener: (context, matchState) {
              if (matchState is MatchSended && matchState.match != null) {
                //_getFlushBar(context, matchState.match);
              }
            },
            child: BlocBuilder<MatchBloc, MatchState>(
                builder: (context, matchState) {
                  return Stack(
                    children: <Widget>[
                      // -- No results --
                      Container(
                        height: MediaQuery.of(context).size.height * 0.7,
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text('Personne ne te correpond :/'),
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Text('Mais ne perd pas espoir et relance la recherche ;)', textAlign: TextAlign.center),
                            ),
                            IconButton(
                              icon: Icon(Icons.refresh, color: InsideColors.blue),
                              onPressed: () => {
                                BlocProvider.of<MainBloc>(context).add(SearchPotentialMatches())
                              },
                            ),
                          ],
                        ),
                      ),
                      // -- Cards --
                      Container(
                        height: MediaQuery.of(context).size.height * 0.7,
                        child: TinderSwapCard(
                          orientation: AmassOrientation.TOP,
                          totalNum: mainState.users.length,
                          stackNum: 3,
                          swipeEdge: 4,
                          animDuration: 400,
                          maxWidth: MediaQuery.of(context).size.width * 0.95,
                          maxHeight: MediaQuery.of(context).size.height * 0.95,
                          minWidth: MediaQuery.of(context).size.width * 0.8,
                          minHeight: MediaQuery.of(context).size.height * 0.8,
                          cardBuilder: (context, index) =>
                              InsideCard(user: mainState.users[index]),
                          cardController: widget.cardController,
                          swipeCompleteCallback: (CardSwipeOrientation orientation, int index) {
                            if (orientation == CardSwipeOrientation.LEFT) {
                              _matchBloc.add(DislikeUser(targetId: mainState.users[index].uid));
                            }
                            if (orientation == CardSwipeOrientation.RIGHT) {
                              _matchBloc.add(LikeUser(targetId: mainState.users[index].uid));
                            }
                          },
                        ),
                      ),
                    ],
                  );
                }
            ),
          );
        }

        if (mainState is LoadingError) {
          return Center(
            child: Text('Une erreur est survenue durant le chargement des données'),
          );
        }

        return CircularProgressIndicator();
      }
    );
  }
}

Flushbar<Object> _getFlushBar(BuildContext context, User match) {
  return Flushbar(
    margin: EdgeInsets.all(8),
    borderRadius: 8,
    backgroundColor: InsideColors.pink,
    flushbarPosition: FlushbarPosition.TOP,
    icon: Padding(
      padding: const EdgeInsets.all(8.0),
//      child: Icon(Icons.favorite, color: InsideColors.pink)
      child: Image.asset('assets/inside_logo.png'),
    ),
    titleText: Text(
      'Nouveau match !',
      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),
    messageText: Text(
      'Vous venez de matcher avec ${match.firstname} ${match.lastname} ! N\'attendez pas pour chatter avec ;)',
      style: TextStyle(color: Colors.white),
    ),
    duration: Duration(seconds: 5),
  )..show(context);
}