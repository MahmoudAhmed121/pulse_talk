import 'package:chat_material3/models/chat_room_model.dart';
import 'package:chat_material3/models/message_model.dart';
import 'package:chat_material3/models/user_model.dart';
import 'package:chat_material3/screens/chat/chat_screen.dart';
import 'package:chat_material3/utils/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
                subtitle: Text(
                  chatRoomModel.lastMessage == ''
                      ? ''
                      : chatRoomModel.lastMessage!.contains('https')
                          ? 'Image 📂'
                          : chatRoomModel.lastMessage!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                title: Text(user.name!),
                trailing: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection(chatRooms)
                      .doc(chatRoomModel.id!)
                      .collection('messages')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final readList = snapshot.data!.docs
                          .map((e) => MessageModel.fromJson(e.data()))
                          .where(
                            (element) =>
                                element.read == '' &&
                                element.fromId !=
                                    FirebaseAuth.instance.currentUser!.uid,
                          )
                          .toList();

                      return readList.isNotEmpty
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(DateFormat.MMMEd()
                                    .format(
                                      DateTime.fromMillisecondsSinceEpoch(
                                        int.parse(chatRoomModel.lastMessageTime!
                                            .toString()),
                                      ),
                                    )
                                    .toString()),
                                Badge(
                                  backgroundColor:
                                      const Color.fromARGB(255, 43, 104, 45),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 7,
                                  ),
                                  label: Text(readList.length.toString()),
                                  largeSize: 20,
                                ),
                                const SizedBox(
                                  height: 2,
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                Text(DateFormat.MMMEd()
                                    .format(
                                      DateTime.fromMillisecondsSinceEpoch(
                                        int.parse(chatRoomModel.lastMessageTime!
                                            .toString()),
                                      ),
                                    )
                                    .toString()),
                              ],
                            );
                    } else {
                      return const SizedBox();
                    }
                  },
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
