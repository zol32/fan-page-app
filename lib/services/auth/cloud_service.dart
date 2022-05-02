import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/user_model.dart';

class CloudService {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  CollectionReference postsCollection =
      FirebaseFirestore.instance.collection('posts');

  Future<dynamic> addUser(
    UserCredential user,
    String displayName,
    String firstName,
    String lastName,
  ) {
    dynamic uid = user.user!.uid;
    return usersCollection
        .doc(uid)
        .set({
          "user_id": uid,
          'username': displayName,
          'first_name': firstName,
          'last_name': lastName,
          'reg_datetime': FieldValue.serverTimestamp(),
          'role': 'USER',
        })
        .then((value) => user)
        .catchError((error) => error);
  }

  Future<dynamic> createPost(
    String imageUrl,
    String caption,
  ) {
    return postsCollection
        .add({
          "image_url": imageUrl,
          'caption': caption,
          'post_created': FieldValue.serverTimestamp(),
        })
        .then((value) => print('Post Created'))
        .catchError((error) => error);
  }

  Future<bool> isAdmin(String uid) async {
    try {
      bool isAdmin = await usersCollection
          .doc(uid)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          dynamic role = documentSnapshot.get('role');
          bool val = role == 'ADMIN' ? true : false;
          return val;
        } else {
          return false;
        }
      });
      return isAdmin;
    } catch (e) {
      return false;
    }
  }
}
