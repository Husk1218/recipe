import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:recipe/common/model/CreateEvent.dart';

class FireAuth {
  
  static Future<User?> signInUsingEmailPassword({
    required String email,
    required String password,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      print(e);
      EasyLoading.showToast(e.code);
    }
    return user;
  }


  static Future<User?> registerUsingEmailPassword({
    required String email,
    required String password,
  }) async {
    EasyLoading.show(status: 'loading...');
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user;
      user = auth.currentUser;
    } on FirebaseAuthException catch (e) {
      print(e);
      EasyLoading.showToast(e.code);
    } catch (e) {
      print(e);
    }
    EasyLoading.dismiss();
    return user;
  }


  static signOut() async {
    await FirebaseAuth.instance.signOut();
  }


  static Future<dynamic> fetchUserInfo(String userId) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    print("-=-=-=-=-=-=");
    try {
      DocumentSnapshot documentSnapshot =
          await firestore.collection('users').doc(userId).get();
      if (documentSnapshot.exists) {
        Map<String, dynamic> userData =
            documentSnapshot.data() as Map<String, dynamic>;
        print(userData);
        return userData;
      } else {
        print('No such user!');
      }
    } catch (e) {
      print(e);
    }
  }


  static Future<void> updateUserInfo(
      String userId,
      String nickName,
      String phoneNumber,
      String school,
      String bio,
      String email,
      String? image) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    users
        .doc(userId)
        .set({
          'nickName': nickName,
          'phoneNumber': phoneNumber,
          'school': school,
          'bio': bio,
          'email': email,
          'image': image ?? ""
        }, SetOptions(merge: true))
        .then(
          (value) => print("User detail update success"),
        )
        .catchError(
          (error) => print("Failed to update user detail$error"),
        );
  }


  static Future<dynamic> updateEventInfo(
      CreateEventModel createEventModel) async {
    CollectionReference users = FirebaseFirestore.instance.collection('events');
    users.doc(createEventModel.eventId).update(createEventModel.toJson()).then(
      (value) {
        print("event information update success");
        return 200;
      },
    ).catchError(
      (error) {
        print("event information update failed$error");
        return 400;
      },
    );
  }
}
