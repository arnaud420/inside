import 'package:bubble/bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:inside/Blocs/Authentication/AuthenticationBloc.dart';
import 'package:inside/Blocs/Authentication/AuthenticationState.dart';
import 'package:inside/Blocs/Chat/ChatBloc.dart';
import 'package:inside/Blocs/Chat/ChatEvent.dart';
import 'package:inside/Blocs/Chat/ChatState.dart';
import 'package:inside/Config/colors.dart';
import 'package:inside/Models/Message.dart';
import 'package:inside/Models/User.dart';
import 'package:inside/Repositories/ChatRepository.dart';
import 'package:inside/Widget/AppBar/AppBarSmallLogo.dart';
import 'package:inside/Widget/Layouts/LayoutBorder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inside/Widget/Chat/Profil.dart';
import 'package:inside/Widget/Chat/ProfilRow.dart';
import 'package:inside/Widget/FullScreenLoader.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';

class ChatScreen extends StatefulWidget {
   final ChatRepository _chatRepository;

  ChatScreen({Key key, @required ChatRepository chatRepository})
      : assert(chatRepository != null),
        _chatRepository = chatRepository,
        super(key: key);

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  bool _isVisible;

  @protected
  void initState() {
    super.initState();
    _isVisible = false;
    
    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        _isVisible = visible;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ChatBloc _chatBloc = BlocProvider.of<ChatBloc>(context);
    final TextEditingController textEditingController = TextEditingController();

    return Scaffold(
      body: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, chatState) {
          if (chatState.isLoading) {
            return FullScreenLoader();
          }

          if (chatState.error) {
            return errorWidget(context, 'Une erreur s\'est produite');
          }

          if (chatState.userMatched == null) {
            return errorWidget(context, 'Aucun matchs n\'a été trouvé.\n Pour avoir plus de chance d\'obtenir un match ajoute quelques hobbies supplémentaires');
          }
          
          return BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, authState) {
              if (authState is Authenticated) {
                return LayoutBorder(
                  child: Stack(
                    children: <Widget>[
                      AppBarSmallLogo(hasArrowBack: true, callback: () => FocusScope.of(context).unfocus()),

                      Positioned(
                        top: 80.0,
                        left: 0.0,
                        right: 0.0,
                        child: Column(
                          children: <Widget>[
                            !_isVisible
                            ? Column(children: <Widget>[
                                Container(
                                height: 135,
                                padding: const EdgeInsets.all(10.0),
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: chatState.matchs
                                    .map((user) {
                                      return GestureDetector(
                                        child: Profil(user),
                                        onTap: () => _chatBloc.add(OpenChat(chatState.matchs, user))
                                      );
                                  }).toList())
                              ),

                              ProfilRow(chatState.userMatched),

                              Container(
                                padding: const EdgeInsets.all(10),
                                child: Divider(
                                  color: Colors.grey,
                                  height: 1,
                                ),
                              ),
                              ])
                            : Container(),

                            Container(
                              padding: const EdgeInsets.only(left: 10, right: 10),
                              height: MediaQuery.of(context).size.height / 2.3,
                              child: StreamBuilder(
                                stream: widget._chatRepository.getMessages(authState.user, chatState.userMatched),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return Container();
                                  }
                                  return buildListMessages(context, snapshot.data.documents, authState.user, chatState.userMatched);
                                },
                              )
                            )
                          ]
                        )
                      ),

                      Positioned(
                        bottom: 0.0,
                        left: 0.0,
                        right: 0.0,
                        child: Container(
                          child: Row(
                            children: <Widget>[
                              Material(
                                child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: 1.0),
                                  child: IconButton(
                                    icon: Icon(Icons.photo_camera),
                                    onPressed: () => null,
                                    color: Colors.grey,
                                  ),
                                ),
                                color: Colors.white,
                              ),

                              // Edit text
                              Flexible(
                                child: Container(
                                  child: TextField(
                                    style: TextStyle(color: Colors.black, fontSize: 15.0),
                                    controller: textEditingController,
                                    onSubmitted: (value) => _chatBloc.add(SendMessage(value, chatState)),
                                    decoration: InputDecoration.collapsed(
                                      hintText: 'Message ...',
                                      hintStyle: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ),
                              ),

                              // Button send message
                              Material(
                                child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: 8.0),
                                  child: IconButton(
                                    icon: Icon(Icons.send),
                                    onPressed: () => {
                                      _chatBloc.add(SendMessage(textEditingController.text, chatState)),
                                      textEditingController.clear()
                                    },
                                    color: InsideColors.pink,
                                  ),
                                ),
                                color: Colors.white,
                              ),
                            ],
                          ),
                          width: double.infinity,
                          height: 50.0,
                          decoration: BoxDecoration(
                              border: Border(top: BorderSide(color: Colors.grey, width: 0.5)), color: Colors.white),
                        )
                      ),
                      
                    ],
                  )
                );
              }
              return Container();
            }
          );
        }
      )
    );
  }

  Widget errorWidget(BuildContext context, message) {
    return LayoutBorder(child: Column(children: <Widget>[
      AppBarSmallLogo(hasArrowBack: true),
      Container(
        child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(10),
                width: 300,
                child: Text(message, style: TextStyle(color: Colors.black), textAlign: TextAlign.center)
              )
            ])
        ])
      )
    ]));
  }

  Widget buildListMessages(BuildContext context, List<DocumentSnapshot> snapshot, User currentUser, User userMatched) {
    if (snapshot.length <= 0) {
      return Container(
        child: Text('Fait le premier pas en envoyant un message à ${userMatched.firstname} !', textAlign: TextAlign.center)
      );
    }

    return Container(
      child: GestureDetector(
        onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: ListView(
          reverse: true,
          children: snapshot.map((data) => buildItemMessage(context, data, currentUser)).toList(),
        )
    ));
  }

  Widget buildItemMessage(BuildContext context, DocumentSnapshot data, User currentUser) {
    final message = Message.fromMap(data);

    return Container(
      child: message.senderId != currentUser.uid 
      ? Bubble(
        margin: BubbleEdges.only(top: 10),
        alignment: Alignment.topLeft,
        nip: BubbleNip.leftTop,
        color: InsideColors.blue,
        child: Text(message.content, style: TextStyle(color: Colors.white)),
      )
      : Bubble(
        margin: BubbleEdges.only(top: 10),
        alignment: Alignment.topRight,
        nip: BubbleNip.rightTop,
        color: InsideColors.lightBlue,
        child: Text(message.content, textAlign: TextAlign.right, style: TextStyle(color: Colors.white)),
      ),
    );
  }
}