import 'package:chat_material3/models/chat_room_model.dart';
import 'package:chat_material3/models/message_model.dart';
import 'package:chat_material3/utils/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

class FireDatabase {
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;
  static final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  static String myId = firebaseAuth.currentUser!.uid;

  static Future<void> createChatRoom({required String email}) async {
    final QuerySnapshot<Map<String, dynamic>> userData = await firestore
        .collection(users)
        .where('email', isEqualTo: email)
        .get();

    if (userData.docs.isEmpty) {
      return;
    }

    String userId = userData.docs.first.id;

    if (userId.isNotEmpty && myId != userId) {
      List<String> members = [myId, userId]..sort(
          (a, b) => a.compareTo(b),
        );

      final QuerySnapshot<Map<String, dynamic>> roomExists = await firestore
          .collection(chatRooms)
          .where('members', isEqualTo: members)
          .get();

      if (roomExists.docs.isEmpty) {
        ChatRoomModel chatRoomModel = ChatRoomModel(
          id: members.toString(),
          members: members,
          lastMessage: '',
          lastMessageTime: DateTime.now().microsecondsSinceEpoch.toString(),
          createdAt: DateTime.now().microsecondsSinceEpoch.toString(),
        );

        await firestore.collection(chatRooms).doc(members.toString()).set(
              chatRoomModel.toJson(),
            );
      }
    }
  }

  static Future<void> sendMessage({
    required String userId,
    required String msg,
    required String roomId,
    String? type,
  }) async {
    final String msgId = const Uuid().v1();
    MessageModel massageModel = MessageModel(
      id: msgId,
      toId: userId,
      fromId: myId,
      msg: msg,
      createdAt: DateTime.now().microsecondsSinceEpoch.toString(),
      type: type ?? 'text',
      read: '',
    );

    await firestore
        .collection(chatRooms)
        .doc(roomId)
        .collection('messages')
        .doc(msgId)
        .set(
          massageModel.toJson(),
        );

    firestore.collection(chatRooms).doc(roomId).update({
      'last_message': msg,
      'last_message_time': DateTime.now().microsecondsSinceEpoch.toString(),
    });
  }

  static Future<void> readMessage(
      {required String roomId, required String msgId}) async {
    try {
      await firestore
          .collection(chatRooms)
          .doc(roomId)
          .collection('messages')
          .doc(msgId)
          .update({
        'read': DateTime.now().millisecondsSinceEpoch.toString(),
      });
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> addContacts({required String email}) async {
    final QuerySnapshot<Map<String, dynamic>> userData = await firestore
        .collection(users)
        .where('email', isEqualTo: email)
        .get();
    if (userData.docs.isNotEmpty) {
      String userId = userData.docs.first.id;

      if (myId != userId) {
        await firestore.collection(users).doc(myId).update({
          "my_users": FieldValue.arrayUnion([userId]),
        });
      }
    }
  }

  static Future<void> deleteMessage({
    required String roomId,
    required List msgsId,
  }) async {
    try {
      for (var msgId in msgsId) {
        await firestore
            .collection(chatRooms)
            .doc(roomId)
            .collection('messages')
            .doc(msgId)
            .delete();
      }
    } catch (e) {
      rethrow;
    }
  }
}
