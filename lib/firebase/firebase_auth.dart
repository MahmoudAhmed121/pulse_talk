import 'package:chat_material3/models/user_model.dart';
import 'package:chat_material3/utils/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FireAuth {
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;

  static User user = auth.currentUser!;
  static Future<void> createUser({required String name}) async {
    UserModel userModel = UserModel(
      id: user.uid,
      name: name,
      email: user.email,
      about: 'Hi there, I am using Chat Pulse Talk',
      createdAt: DateTime.now().microsecondsSinceEpoch.toString(),
      pushToken: '',
      imageUrl: '',
      lastSeen:  DateTime.now().microsecondsSinceEpoch.toString(),
      online: false,
      myUsers: [],
    );

    await firestore.collection(users).doc(user.uid).set(
          userModel.toJson(),
          SetOptions(merge: true),
        );
  }
}
