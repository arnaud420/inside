import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inside/Blocs/Authentication/AuthenticationBloc.dart';
import 'package:inside/Blocs/Authentication/AuthenticationEvent.dart';
import 'package:inside/Blocs/Authentication/AuthenticationState.dart';
import 'package:inside/Models/User.dart';
import 'package:inside/Repositories/UserRepository.dart';

import 'package:mockito/mockito.dart';

class MockUserRepository extends Mock implements UserRepository {}
Map<String, dynamic> _getMapedUser() {
      Map<String, dynamic> geopoint = Map();
      Map<String, double> location = Map();
      location['_latitude'] = 43.6107;
      location['_longitude'] = -0.5218;
      geopoint['geopoint'] = location;

      Map<String, dynamic> userMap = Map();
      userMap['birthDate'] = Timestamp.now();
      userMap['description'] = "Description";
      userMap['firstname'] = "Test";
      userMap['lastname'] = "Test";
      userMap['photo'] = "https://placekitten.com/g/200/300";
      userMap['lastLocation'] = geopoint;
      userMap['dislikedHobbies'] = ['hobbie1'];
      userMap['likedHobbies'] = ['hobbie1'];

      return userMap;
    }
main() {
  AuthenticationBloc authenticationBloc;
  MockUserRepository userRepository;

  setUp(() {
    userRepository = MockUserRepository();
    authenticationBloc = AuthenticationBloc(userRepository: userRepository);
  });

  tearDown(() {
    authenticationBloc?.close();
  });

  group('Init state', () {
    test('initial state is correct', () {
      expect(authenticationBloc.initialState, Uninitialized());
    });

    test('close does not emit new states', () {
      expectLater(
        authenticationBloc,
        emitsInOrder([Uninitialized(), emitsDone]),
      );
      authenticationBloc.close();
    });
  });

  group('App started', () {
    test(
        'emits [uninitialized, unauthenticated] if the user is not logged in when app starts',
        () {
      final expectedResponse = [Uninitialized(), Unauthenticated()];

      when(userRepository.isSignedIn()).thenAnswer((_) => Future.value(false));

      expectLater(
        authenticationBloc,
        emitsInOrder(expectedResponse),
      );

      authenticationBloc.add(AppStarted());
    });
  });

  group('Logged In', () {test(
        'emits [uninitialized, authenticated] when user logged is persisted',
        () {
      final String uid = "DkvLhsWgZHWJF8n1xQWIIVASUkW2";
      Map<String, dynamic> mapUser = _getMapedUser();
      User user = User.fromMap(mapUser, uid);

      expectLater(
        authenticationBloc,
        emitsInOrder([
          Uninitialized(),
          Authenticated(user),
        ]),
      );

      authenticationBloc.add(TestLoggedIn(user: user));
    });
  });

  group('Logged Out', () {
    test(
        'emits [authenticated, authenticated, unauthenticated] when user logged is persisted then logged out',
        () {
      final String uid = "DkvLhsWgZHWJF8n1xQWIIVASUkW2";
      Map<String, dynamic> mapUser = _getMapedUser();
      User user = User.fromMap(mapUser, uid);

      expectLater(
        authenticationBloc,
        emitsInOrder([
          Uninitialized(),
          Authenticated(user),
          Unauthenticated(),
        ]),
      );

      authenticationBloc.add(TestLoggedIn(user: user));
      authenticationBloc.add(LoggedOut());
    });
  });
}
