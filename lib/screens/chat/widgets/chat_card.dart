import 'package:chat_material3/models/chat_room_model.dart';
import 'package:chat_material3/models/user_model.dart';
import 'package:chat_material3/screens/chat/chat_screen.dart';
import 'package:chat_material3/utils/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatCard extends StatelessWidget {
  const ChatCard({
    super.key,
    required this.chatRoomModel,
  });

  final ChatRoomModel chatRoomModel;

  @override
  Widget build(BuildContext context) {
    if (chatRoomModel.members != null && chatRoomModel.members!.isNotEmpty) {

      String userId = chatRoomModel.members!
          .where((e) => e != FirebaseAuth.instance.currentUser!.uid)
          .first;

      return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection(users)
            .doc(userId)
            .snapshots(),

        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final user = UserModel.fromJson(snapshot.data!.data()!);
            return Card(
              child: ListTile(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatScreen(
                      userModel: user,
                      roomId: chatRoomModel.id!,
                    ),
                  ),
                ),
                leading: const CircleAvatar(),
                subtitle: Text(chatRoomModel.lastMessage == ''
                    ? 'No message'
                    : chatRoomModel.lastMessage!),
                title: Text(user.name!),
                trailing: const Badge(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  label: Text("3"),
                  largeSize: 30,
                ),
              ),
            );
          } else {
            return const SizedBox();
          }
        },
      );
    } else {
      return const Text('Members list is empty');
    }
  }
}
