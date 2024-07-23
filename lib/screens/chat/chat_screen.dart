import 'dart:io';

import 'package:chat_material3/firebase/fire_database.dart';
import 'package:chat_material3/firebase/fire_storge.dart';
import 'package:chat_material3/models/message_model.dart';
import 'package:chat_material3/models/user_model.dart';
import 'package:chat_material3/screens/chat/widgets/chat_message_card.dart';
import 'package:chat_material3/utils/colors.dart';
import 'package:chat_material3/utils/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.roomId, required this.userModel});
  final UserModel userModel;
  final String roomId;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();

  List selectedList = [];
  List<String> copyText = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.userModel.name!),
            Text(
              "Last Seen ${widget.userModel.lastSeen}",
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ],
        ),
        actions: [
          selectedList.isEmpty
              ? const SizedBox()
              : IconButton(
                  onPressed: () {
                    FireDatabase().deleteMessage(
                      roomId: widget.roomId,
                      msgsId: selectedList,
                    ).whenComplete(() {
                      selectedList.clear();
                      copyText.clear();
                    });
                    setState(() {});
                  },
                  icon: const Icon(Iconsax.trash),
                ),
          copyText.isEmpty
              ? const SizedBox()
              : IconButton(
                  onPressed: () {
                    Clipboard.setData(
                      ClipboardData(
                        text: copyText.first,
                      ),
                    );
                  },
                  icon: const Icon(Iconsax.copy),
                ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection(chatRooms)
                      .doc(widget.roomId)
                      .collection('messages')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final List<MessageModel> messages = snapshot.data!.docs
                          .map((e) => MessageModel.fromJson(e.data()))
                          .toList()
                        ..sort(
                          (a, b) => b.createdAt!.compareTo(a.createdAt!),
                        );

                      if (messages.isEmpty) {
                        return GestureDetector(
                          onTap: () => FireDatabase().sendMessage(
                              userId: widget.userModel.id!,
                              msg: "Assalamu Alaikum 👋",
                              roomId: widget.roomId),
                          child: Center(
                            child: GestureDetector(
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "👋",
                                        style: Theme.of(context)
                                            .textTheme
                                            .displayMedium,
                                      ),
                                      const SizedBox(
                                        height: 16,
                                      ),
                                      Text(
                                        "Say Assalamu Alaikum",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      } else {
                        return ListView.builder(
                          reverse: true,
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedList.isNotEmpty
                                      ? selectedList
                                              .contains(messages[index].id)
                                          ? selectedList
                                              .remove(messages[index].id)
                                          : selectedList.add(
                                              messages[index].id!,
                                            )
                                      : null;

                                  copyText.isNotEmpty
                                      ? messages[index].type == 'text'
                                          ? copyText
                                                  .contains(messages[index].msg)
                                              ? copyText
                                                  .remove(messages[index].msg)
                                              : copyText
                                                  .add(messages[index].msg!)
                                          : null
                                      : null;
                                  debugPrint("copyTexttt: $copyText");
                                });
                              },
                              onLongPress: () {
                                setState(() {
                                  selectedList.contains(messages[index].id)
                                      ? selectedList.remove(messages[index].id)
                                      : selectedList.add(
                                          messages[index].id!,
                                        );
                                });

                                messages[index].type == 'text'
                                    ? copyText.contains(messages[index].msg)
                                        ? copyText.remove(messages[index].msg)
                                        : copyText.add(messages[index].msg!)
                                    : null;

                                debugPrint("copyText: $copyText");
                              },
                              child: ChatMessageCard(
                                isSelected: selectedList.contains(
                                  messages[index].id,
                                ),
                                index: index,
                                message: messages[index],
                                roomId: widget.roomId,
                              ),
                            );
                          },
                        );
                      }
                    }
                    return const Center(child: CircularProgressIndicator());
                  }),
            ),
            Row(
              children: [
                Expanded(
                  child: Card(
                    child: TextField(
                      maxLines: 5,
                      minLines: 1,
                      controller: _messageController,
                      decoration: InputDecoration(
                        suffixIcon: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Iconsax.emoji_happy),
                            ),
                            IconButton(
                              onPressed: () async {
                                final ImagePicker picker = ImagePicker();
                                final XFile? image = await picker.pickImage(
                                    source: ImageSource.gallery);
                                if (image != null) {
                                  await FireStorge.sendImage(
                                    file: File(image.path),
                                    roomId: widget.roomId,
                                    userId: widget.userModel.id!,
                                  );
                                }
                              },
                              icon: const Icon(Iconsax.gallery),
                            ),
                          ],
                        ),
                        border: InputBorder.none,
                        hintText: "Message",
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                      ),
                    ),
                  ),
                ),
                IconButton.filled(
                  onPressed: () {
                    if (_messageController.text.isNotEmpty) {
                      FireDatabase().sendMessage(
                        msg: _messageController.text,
                        roomId: widget.roomId,
                        userId: widget.userModel.id!,
                      ).then((value) {
                        _messageController.clear();
                      });
                    }
                  },
                  icon: const Icon(
                    Iconsax.send_1,
                    color: Colors.white,
                  ),
                  style: const ButtonStyle(
                    backgroundColor:
                        MaterialStatePropertyAll(AppColor.darkPrimary),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
