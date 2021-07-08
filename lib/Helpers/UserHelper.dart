import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:inside/Repositories/UserRepository.dart';

class UserHelper {
  String getAge(Timestamp birthDateTimestamp) {
    final DateTime birthDate = DateTime.fromMillisecondsSinceEpoch(birthDateTimestamp.millisecondsSinceEpoch);
    final DateTime now = DateTime.now();
    final int days = now.difference(birthDate).inDays;
    final String age = (days/365).floor().toString();

    return age;
  }

   double getDistanceBetweenPoints(GeoPoint firstLocation, GeoPoint secondLocation) {
     Geoflutterfire geo = Geoflutterfire();
     var point = geo.point(latitude: firstLocation.latitude, longitude: firstLocation.longitude);
     return point.distance(lat: secondLocation.latitude, lng: secondLocation.longitude);
   }
}