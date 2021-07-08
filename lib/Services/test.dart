import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Test extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('hobbies').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return LinearProgressIndicator();
        return _buildList(context, snapshot.data.documents);
      },
    );
  }
  

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final hobbies = Hobbie.fromSnapshot(data);
    
    return Container(
      child: Text("test")
    );
  }
}

class Hobbie {
  final String backgroundColor, name;
  final int backgroundColorVariation;

  @override
  String toString() => "Hobbie<$name, $backgroundColor, $backgroundColorVariation>";

  Hobbie.fromMap(Map<String, dynamic> map)
      : assert(map['backgroundColor'] != null),
        assert(map['backgroundColorVariation'] != null),
        assert(map['name'] != null),
        backgroundColor = map['backgroundColor'],
        backgroundColorVariation = map['backgroundColorVariation'],
        name = map['name'];

  Hobbie.fromSnapshot(DocumentSnapshot snapshot) : this.fromMap(snapshot.data);
}