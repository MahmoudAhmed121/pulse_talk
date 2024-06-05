import 'package:chat_material3/models/message_model.dart';
import 'package:chat_material3/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

class ChatMessageCard extends StatelessWidget {
  final int index;
  final MessageModel message;
  const ChatMessageCard({
    super.key,
    required this.index,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final bool isMe = message.fromId == FirebaseAuth.instance.currentUser!.uid;
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.start : MainAxisAlignment.end,
      children: [
        Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
            bottomLeft: const Radius.circular(16),
            bottomRight: const Radius.circular(16),
            topLeft: Radius.circular(isMe ? 0 : 16),
            topRight: Radius.circular(isMe ? 16 : 0),
          )),
          color: isMe
              ? Theme.of(context).colorScheme.background
              : AppColor.darkPrimary,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.sizeOf(context).width / 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(message.msg!),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      isMe
                          ? const Icon(
                              IconlyLight.tickSquare,
                              color: Color.fromARGB(255, 2, 102, 5),
                              size: 18,
                            )
                          : const SizedBox(),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        DateFormat().add_yMMMEd().format(
                              DateTime.fromMicrosecondsSinceEpoch(
                                int.parse(
                                  message.createdAt!,
                                ),
                              ),
                            ),
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        isMe
            ? IconButton(
                onPressed: () {},
                icon: const Icon(
                  Iconsax.message_edit,
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}
