import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final Timestamp birthDate;
  final String description, firstname, lastname, photo, ageMin, ageMax, distance, uid;
  String email;
  final lastLocation;
  List<dynamic> dislikedHobbies, likedHobbies, likedUsers, dislikedUsers, matchedUsers;
  final GeoPoint geopoint;


  @override
  String toString() => 'User : $firstname $lastname ($uid)';

  User.fromMap(Map<String, dynamic> map, String uid)
      : assert(map['birthDate'] != null),
        assert(map['description'] != null),
        assert(map['firstname'] != null),
        assert(map['lastname'] != null),
        assert(map['photo'] != null),
        assert(map['lastLocation'] != null),
        assert(map['dislikedHobbies'] != null),
        assert(map['likedHobbies'] != null),
        assert(uid != null),
        email = null,
        birthDate = map['birthDate'].runtimeType == Timestamp
          ? map['birthDate']
          : Timestamp(map['birthDate']['_seconds'], 0),
        ageMin = map['ageMin'],
        ageMax = map['ageMax'],
        distance = map['distance'],
        description = map['description'],
        firstname = map['firstname'],
        lastname = map['lastname'],
        photo = map['photo'],
        lastLocation = map['lastLocation'],
        dislikedHobbies = map['dislikedHobbies'],
        likedHobbies = map['likedHobbies'],
        likedUsers = map.containsKey('likedUsers') ? map['likedUsers'] : [],
        dislikedUsers = map.containsKey('dislikedUsers') ? map['dislikedUsers'] : [],
        matchedUsers = map.containsKey('matchedUsers') ? map['matchedUsers'] : [],
        uid = uid,
        geopoint = _getGeoPoint(map['lastLocation']);

  User.fromSnapshot(DocumentSnapshot snapshot) : this.fromMap(snapshot.data, snapshot.documentID);

  static GeoPoint _getGeoPoint(lastLocation)
    => lastLocation['geopoint'].runtimeType == GeoPoint
      ? lastLocation['geopoint']
      : GeoPoint(lastLocation['geopoint']['_latitude'],
        lastLocation['geopoint']['_longitude']);
}
