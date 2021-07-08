import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inside/Blocs/Chat/ChatBloc.dart';
import 'package:inside/Blocs/Chat/ChatEvent.dart';
import 'package:inside/Config/colors.dart';
import 'package:inside/Repositories/ChatRepository.dart';
import 'package:inside/Screen/ChatScreen.dart';
import 'Blocs/Matchs/MatchBloc.dart';
import 'Screen/HomeScreen.dart';
import 'package:inside/Screen/HomeScreen.dart';
import 'package:inside/Screen/LoadingScreen.dart';
import 'package:inside/Screen/MainScreen.dart';
import 'package:inside/Screen/Register/RegisterMain.dart';
import 'Blocs/Authentication/AuthenticationBloc.dart';
import 'Blocs/Authentication/AuthenticationEvent.dart';
import 'Blocs/Authentication/AuthenticationState.dart';
import 'Blocs/Register/RegisterBloc.dart';
import 'Screen/LoginScreen.dart';
import 'Repositories/UserRepository.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final UserRepository userRepository = UserRepository();
  final ChatRepository chatRepository = ChatRepository();

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: InsideColors.burgundy,
  ));
  return runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationBloc>(
          builder: (context) =>
              AuthenticationBloc(userRepository: userRepository)
                ..add(AppStarted()),
        ),
        BlocProvider<RegisterBloc>(
          builder: (context) => RegisterBloc(userRepository: userRepository),
        ),
        BlocProvider<MatchBloc>(
          builder: (context) => MatchBloc(userRepository: userRepository),
        ),
      ],
      child: InsideApp(
          userRepository: userRepository, chatRepository: chatRepository),
    ),
  );
}

class InsideApp extends StatefulWidget {
  final UserRepository _userRepository;
  final ChatRepository _chatRepository;

  InsideApp(
      {Key key,
      @required UserRepository userRepository,
      @required ChatRepository chatRepository})
      : assert(userRepository != null && chatRepository != null),
        _userRepository = userRepository,
        _chatRepository = chatRepository,
        super(key: key);

  _InsideAppState createState() => _InsideAppState();
}

class _InsideAppState extends State<InsideApp> {
  MatchBloc _matchBloc;
  final FirebaseMessaging _fcm = FirebaseMessaging();
  final Firestore _db = Firestore.instance;

  @override
  void initState() {
    super.initState();
    _matchBloc = BlocProvider.of<MatchBloc>(context);
    _saveDeviceToken();
    _configureFcm();
  }

  _configureFcm() {
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        Flushbar(
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
            message['notification']['title'],
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          messageText: Text(
            message['notification']['body'],
            style: TextStyle(color: Colors.white),
          ),
          duration: Duration(seconds: 5),
        )..show(context);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
  }

  _saveDeviceToken() async {
    // Get the current user
    FirebaseUser currentUser = await widget._userRepository.getFirebaseUser();
    String uid = currentUser.uid;

    // Get the token for this device
    String fcmToken = await _fcm.getToken();

    // Save it to Firestore
    if (fcmToken != null) {
      var tokens = _db.collection('users').document(uid);

      await tokens.updateData({'token': fcmToken});
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inside App',
      theme: ThemeData(
        primarySwatch: InsideColors.burgundy,
        fontFamily: 'Montserrat',
      ),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('fr'),
      ],
      initialRoute: '/',
      routes: {
        '/': (context) => BlocBuilder<AuthenticationBloc, AuthenticationState>(
              builder: (context, state) {
                if (state is Uninitialized) {
                  return LoadingScreen();
                }
                if (state is Authenticated) {
                  return MainScreen(userRepository: widget._userRepository);
                }
                return HomeScreen();
              },
            ),
        '/home': (context) => HomeScreen(),
        '/register': (context) => BlocProvider<RegisterBloc>(
              builder: (context) =>
                  RegisterBloc(userRepository: widget._userRepository),
              child: RegisterScreen(userRepository: widget._userRepository),
            ),
        '/login': (context) => LoginScreen(userRepository: widget._userRepository),
        '/chat': (context) => BlocProvider<ChatBloc>(
              builder: (context) => ChatBloc(
                  userRepository: widget._userRepository,
                  chatRepository: widget._chatRepository)
                ..add(FetchMatchs()),
              child: ChatScreen(chatRepository: widget._chatRepository),
            ),
        // '/profil': (context) => ProfilScreen()
      },
    );
  }
}
