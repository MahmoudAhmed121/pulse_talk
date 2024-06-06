import 'dart:io';

import 'package:chat_material3/firebase/fire_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FireStorge {
  static final FirebaseStorage fireStorage = FirebaseStorage.instance;

  static Future<void> sendImage({
    required File file,
    required String roomId,
    required String userId,
  }) async {
    final ext = file.path.split('.').last;

    try {
      final ref = fireStorage.ref().child(
            'images/$roomId/${DateTime.now().millisecondsSinceEpoch}.$ext',
          );

      await ref.putFile(file);

      String url = await ref.getDownloadURL();

      await FireDatabase.sendMessage(
        userId: userId,
        msg: url,
        roomId: roomId,
        type: 'image',
      );
    } catch (e) {
      rethrow;
    }
  }
}
