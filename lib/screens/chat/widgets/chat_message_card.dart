import 'package:chat_material3/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:iconsax/iconsax.dart';

class ChatMessageCard extends StatelessWidget {
  final int index;
  const ChatMessageCard({
    super.key,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          index % 2 == 0 ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        index % 2 == 0
            ? IconButton(onPressed: () {}, icon: const Icon(Iconsax.message_edit))
            : const SizedBox(),
        Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
            bottomLeft: const Radius.circular(16),
            bottomRight: const Radius.circular(16),
            topLeft:  Radius.circular(index % 2 == 0 ? 16 : 0),
            topRight: Radius.circular(index % 2 == 0 ? 0 : 16),
          )),
          color: index % 2 == 0
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
                  const Text("Messagejsdhkjhdks"),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      index % 2 == 0
                          ? const Icon(
                              IconlyLight.tickSquare,
                              color: Color.fromARGB(255, 2, 102, 5),
                              size: 18,
                            )
                          : const SizedBox(),
                          const SizedBox(width: 5,),
                      Text(
                        "06:16 pm",
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
      ],
    );
  }
}
