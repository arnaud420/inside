import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inside/Models/Hobbie.dart';

class HobbieRepository {
  Future<List<Hobbie>> getHobbies() async {
    List<Hobbie> hobbiesRetrieved = [];

    await Firestore.instance
        .collection('hobbies')
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((DocumentSnapshot hobbie) {
        var hobbieRetrieved = Hobbie.fromSnapshot(hobbie);
        hobbiesRetrieved.add(hobbieRetrieved);
      });
    });

    return hobbiesRetrieved;
  }

  Future<List<Hobbie>> getHobbiesFromDocumentReferenceList(
      List<dynamic> hobbiesReferences) async {
    final Firestore databaseReference = Firestore.instance;
    List<Hobbie> hobbies = [];
    try {
      for (DocumentReference hobbieReference in hobbiesReferences) {
        await databaseReference
            .collection('hobbies')
            .document(hobbieReference.documentID)
            .get()
            .then((DocumentSnapshot snapshot) {
          hobbies.add(Hobbie.fromSnapshot(snapshot));
        });
      }
    } catch (e) {
      print('Error : $e');
    }
    return hobbies;
  }
}
