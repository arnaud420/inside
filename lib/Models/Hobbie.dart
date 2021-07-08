import 'package:cloud_firestore/cloud_firestore.dart';

class Hobbie {
  final String backgroundColor, name, icon, documentID;

  @override
  String toString() => "Hobbie<$documentID, $name, $backgroundColor, $icon>";

  Hobbie.fromMap(Map<String, dynamic> map, String documentID)
      : assert(map['backgroundColor'] != null),
        assert(map['name'] != null),
        assert(map['icon'] != null),
        assert(documentID != null),
        backgroundColor = map['backgroundColor'],
        name = map['name'],
        icon = map['icon'],
        documentID = documentID;

  Hobbie.fromSnapshot(DocumentSnapshot snapshot) : this.fromMap(snapshot.data, snapshot.documentID);
}