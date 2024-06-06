import 'package:chat_material3/firebase/fire_database.dart';
import 'package:chat_material3/models/message_model.dart';
import 'package:chat_material3/utils/colors.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

class ChatMessageCard extends StatefulWidget {
  final int index;
  final MessageModel message;
  final String roomId;
  const ChatMessageCard({
    super.key,
    required this.index,
    required this.message,
    required this.roomId,
  });

  @override
  State<ChatMessageCard> createState() => _ChatMessageCardState();
}

class _ChatMessageCardState extends State<ChatMessageCard> {
  @override
  void initState() {
    super.initState();
    if (widget.message.toId == FirebaseAuth.instance.currentUser!.uid) {
      FireDatabase.readMessage(
          roomId: widget.roomId, msgId: widget.message.id!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isMe =
        widget.message.fromId == FirebaseAuth.instance.currentUser!.uid;
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
                  if (widget.message.type == 'text') ...[
                    Text(widget.message.msg!),
                  ] else ...[
                    FancyShimmerImage(
                      imageUrl: widget.message.msg!,
                      height: 200,
                      imageBuilder: (context, imageProvider) {
                        return Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    )
                  ],
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        width: 5,
                      ),
                      Icon(
                        Iconsax.tick_circle,
                        color: widget.message.read == ''
                            ? Colors.grey
                            : Colors.blue,
                        size: 18,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        DateFormat().add_yMMMEd().format(
                              DateTime.fromMicrosecondsSinceEpoch(
                                int.parse(
                                  widget.message.createdAt!,
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
