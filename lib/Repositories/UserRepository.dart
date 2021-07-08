import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:inside/Models/Hobbie.dart';
import 'package:inside/Models/User.dart';
import 'package:intl/intl.dart';
import 'package:mime_type/mime_type.dart';
import 'package:path/path.dart' as p;
import 'package:location/location.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'HobbieRepository.dart';

class UserRepository {
  final FirebaseAuth _firebaseAuth;
  final Firestore databaseReference = Firestore.instance;

  UserRepository({FirebaseAuth firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  Future<void> signInWithCredentials(String email, String password) {
    return _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signUp(String email, String password) async {
    return await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> registerFullUser(
    String id,
    String dateOfBirth,
    String firstname,
    String lastname,
    String description,
    List<Hobbie> hobbiesLiked,
    List<Hobbie> hobbiesDisliked,
    File photo,
    String ageMin,
    String ageMax,
    String distance,
  ) async {
    try {
      final String fileName = p.basename(photo.path);
      final String mimeType = mime(fileName);
      final StorageReference storageRef =
          FirebaseStorage.instance.ref().child(fileName);
      final StorageUploadTask uploadTask =
          _uploadPicture(storageRef, photo, mimeType);
      final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
      final String photoUrl = (await downloadUrl.ref.getDownloadURL());
      final GeoFirePoint userLocation = await _getCurrentLocation();
      final List<DocumentReference> likedHobbiesSnapshots =
          await _getHobbiesCollectionsReferences(hobbiesLiked);
      final List<DocumentReference> dislikedHobbiesSnapshots =
          await _getHobbiesCollectionsReferences(hobbiesDisliked);
      return await databaseReference.collection('users').document(id).setData({
        'birthDate':
            Timestamp.fromDate(DateFormat("dd/MM/yyyy").parse(dateOfBirth)),
        'description': description,
        'dislikedHobbies': dislikedHobbiesSnapshots,
        'likedHobbies': likedHobbiesSnapshots,
        'firstname': firstname,
        'id': id,
        'lastLocation': userLocation.data,
        'lastname': lastname,
        'photo': photoUrl,
        'ageMin': ageMin,
        'ageMax': ageMax,
        'distance': distance,
      });
    } catch (e) {
      throw e;
    }
  }

  Future<void> updateFullUser(
    String id,
    String dateOfBirth,
    String firstname,
    String lastname,
    String description,
    List<Hobbie> hobbiesLiked,
    List<Hobbie> hobbiesDisliked,
    File photo,
    String ageMin,
    String ageMax,
    String distance,
  ) async {
    try {
      String fileName = p.basename(photo.path);
      if (fileName.contains('?')) {
        fileName = fileName.split('?')[0];
      }
      User currentUser = await getUser();
      String photoUrl = currentUser.photo;
      if (!photoUrl.contains(fileName)) {
        final String mimeType = mime(fileName);
        final StorageReference storageRef =
            FirebaseStorage.instance.ref().child(fileName);
        final StorageUploadTask uploadTask =
            _uploadPicture(storageRef, photo, mimeType);
        final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
        photoUrl = await downloadUrl.ref.getDownloadURL();
      }
      final GeoFirePoint userLocation = await _getCurrentLocation();
            final List<DocumentReference> likedHobbiesSnapshots =
          await _getHobbiesCollectionsReferences(hobbiesLiked);
      final List<DocumentReference> dislikedHobbiesSnapshots =
          await _getHobbiesCollectionsReferences(hobbiesDisliked);
      return await databaseReference
          .collection('users')
          .document(id)
          .updateData({
        'birthDate':
            Timestamp.fromDate(DateFormat("dd/MM/yyyy").parse(dateOfBirth)),
        'description': description,
        'dislikedHobbies': dislikedHobbiesSnapshots,
        'likedHobbies': likedHobbiesSnapshots,
        'firstname': firstname,
        'id': id,
        'lastLocation': userLocation.data,
        'lastname': lastname,
        'photo': photoUrl,
        'ageMin': ageMin,
        'ageMax': ageMax,
        'distance': distance,
      });
    } catch (e) {
      throw e;
    }
  }

  Future<void> addLike(String targetId) async {
    try {
      final User currentUser = await this.getUser();

      List<String> likedUsers = List<String>.from(currentUser.likedUsers);
      likedUsers.add(targetId);

      return await databaseReference
          .collection('users')
          .document(currentUser.uid)
          .updateData({
        'likedUsers': likedUsers,
      });
    } catch (e) {
      throw e;
    }
  }

  Future<void> addDislike(String targetId) async {
    try {
      final User currentUser = await this.getUser();

      List<String> dislikedUsers = List<String>.from(currentUser.dislikedUsers);
      dislikedUsers.add(targetId);

      return await databaseReference
        .collection('users')
        .document(currentUser.uid)
        .updateData({
          'dislikedUsers': dislikedUsers,
        });
    } catch (e) {
      throw e;
    }
  }

  Future<User> hasMatch(String targetId) async {
    try {
      User currentUser = await this.getUser();

      User target = await databaseReference
        .collection('users')
        .document(targetId)
        .get()
        .then((DocumentSnapshot snapshot) {
          return User.fromSnapshot(snapshot);
        });

      bool hasMatch = target.likedUsers.contains(currentUser.uid);

      if (hasMatch) {
        List<String> userMatchedUsers = List<String>.from(currentUser.matchedUsers);
        userMatchedUsers.add(targetId);

        await databaseReference
          .collection('users')
          .document(currentUser.uid)
          .updateData({
            'matchedUsers': userMatchedUsers,
        });

        List<String> targetMatchedUsers = List<String>.from(target.matchedUsers);
        targetMatchedUsers.add(currentUser.uid);

        await databaseReference
            .collection('users')
            .document(target.uid)
            .updateData({
          'matchedUsers': targetMatchedUsers,
        });
      }

      return hasMatch ? target : null;
    } catch (e) {
      throw e;
    }
  }

  Future<List<DocumentReference>> _getHobbiesCollectionsReferences(
      List<Hobbie> hobbies) async {
    List<DocumentReference> snapshots = [];
    if (hobbies.length > 0) {
      for (Hobbie hobbie in hobbies) {
        DocumentReference snapshot =
            databaseReference.collection('hobbies').document(hobbie.documentID);
        snapshots.add(snapshot);
      }
    }

    return snapshots;
  }

  StorageUploadTask _uploadPicture(
      StorageReference storageRef, File photo, String mimeType) {
    return storageRef.putFile(
      photo,
      StorageMetadata(
        contentType: mimeType != null ? mimeType : 'image/jpg',
      ),
    );
  }

  Future<GeoFirePoint> _getCurrentLocation() async {
    LocationData currentLocation;
    var location = Location();
    GeoFirePoint geopoint;
    try {
      currentLocation = await location.getLocation();
      Geoflutterfire geo = Geoflutterfire();
      geopoint = geo.point(
          latitude: currentLocation.latitude,
          longitude: currentLocation.longitude);
    } catch (_) {
      currentLocation = null;
    }

    return geopoint;
  }

  Future<void> signOut() async {
    return Future.wait([
      _firebaseAuth.signOut(),
    ]);
  }

  Future<bool> isSignedIn() async {
    final currentUser = await _firebaseAuth.currentUser();
    return currentUser != null;
  }

  Future<FirebaseUser> getFirebaseUser() async {
    return await _firebaseAuth.currentUser();
  }

  Future<User> getUser() async {
    final FirebaseUser firebaseUser = await this.getFirebaseUser();
    User currentUser;

    currentUser = await Firestore.instance
        .collection('users')
        .document(firebaseUser.uid)
        .get()
        .then((DocumentSnapshot snapshot) {
      return User.fromSnapshot(snapshot);
    });

    return currentUser;
  }

  Future<User> getUserWithHobbies() async {
    final FirebaseUser firebaseUser = await this.getFirebaseUser();
    User currentUser;

    currentUser = await Firestore.instance
        .collection('users')
        .document(firebaseUser.uid)
        .get()
        .then((DocumentSnapshot snapshot) {
      return User.fromSnapshot(snapshot);
    });

    currentUser.likedHobbies = await HobbieRepository()
        .getHobbiesFromDocumentReferenceList(currentUser.likedHobbies)
        .then((hobbiesLiked) {
      return hobbiesLiked;
    });

    currentUser.dislikedHobbies = await HobbieRepository()
        .getHobbiesFromDocumentReferenceList(currentUser.dislikedHobbies)
        .then((hobbiesDisliked) {
      return hobbiesDisliked;
    });

    currentUser.email = firebaseUser.email;

    return currentUser;
  }

  Future<List<User>> getPotentialsMatches(User currentUser) async {
    List<User> users = List<User>();

    final HttpsCallable callable = CloudFunctions.instance.getHttpsCallable(
      functionName: 'getPotentialsMatches',
    );

    HttpsCallableResult response = await callable.call();

    response.data.forEach((data) => {
      users.add(User.fromMap(Map<String, dynamic>.from(data), data['id']))
    });

    print('${users.length} matches found');
    users.forEach((user) => print(user));
    return users;
  }

  sendLocation() async {
    try {
    final User currentUser = await getUser();
    final String userId = currentUser.uid;
    final DocumentReference currentUserDocumentReference =
        Firestore.instance.collection('users').document(userId);
    final GeoFirePoint userLocation = await _getCurrentLocation();
    currentUserDocumentReference.updateData({
      'lastLocation': userLocation.data
    });
    } catch(e) {
      print("Error while sending location: $e");
    }
  }

  Future<List<User>> getMatchs(User currentUser) async {
    List<User> users = List<User>();
    try {
      for (String docId in currentUser.matchedUsers) {
        await databaseReference
            .collection('users')
            .document(docId)
            .get()
            .then((DocumentSnapshot snapshot) {
              users.add(User.fromSnapshot(snapshot));
            });
      }
    } catch (e) {
      print('Error : $e');
    }

    return users;
  }
}