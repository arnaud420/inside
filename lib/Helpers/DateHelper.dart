import 'package:cloud_firestore/cloud_firestore.dart';

class DateHelper {
  static getStringFromTimestamp(Timestamp timestamp) {
      DateTime dateFromTimestamp = timestamp.toDate();
      int year = dateFromTimestamp.year;
      int month = dateFromTimestamp.month;
      int day = dateFromTimestamp.day;
      
      return '$day/$month/$year';
  }
}