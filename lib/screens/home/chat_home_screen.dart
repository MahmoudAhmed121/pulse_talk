import 'package:chat_material3/firebase/fire_database.dart';
import 'package:chat_material3/models/chat_room_model.dart';
import 'package:chat_material3/screens/chat/widgets/chat_card.dart';
import 'package:chat_material3/utils/constant.dart';
import 'package:chat_material3/utils/my_validator.dart';
import 'package:chat_material3/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:iconsax/iconsax.dart';

class ChatHomeScreen extends StatefulWidget {
  const ChatHomeScreen({super.key});

  @override
  _ChatHomeScreenState createState() => _ChatHomeScreenState();
}

class _ChatHomeScreenState extends State<ChatHomeScreen> {
  late final TextEditingController _emailCon;
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _emailCon = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _emailCon.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showBottomSheet(
            context: context,
            builder: (context) {
              return Container(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Enter Friend Email",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const Spacer(),
                          IconButton.filled(
                            onPressed: () {},
                            icon: const Icon(Iconsax.scan_barcode),
                          ),
                        ],
                      ),
                      CustomField(
                        controller: _emailCon,
                        icon: IconlyLight.message,
                        lable: "Email",
                        validator: (value) {
                          return MyValidators.emailValidator(value);
                        },
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          backgroundColor:
                              Theme.of(context).colorScheme.primaryContainer,
                        ),
                        onPressed: () async {
                          if (_emailCon.text.isNotEmpty &&
                              _formKey.currentState!.validate()) {
                            await FireDatabase().createChatRoom(
                              email: _emailCon.text,
                            ).then((value) {
                              _emailCon.clear();
                              Navigator.pop(context);
                            });
                          }
                        },
                        child: const Center(
                          child: Text("Create Chat"),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        child: const Icon(Iconsax.message_add),
      ),
      appBar: AppBar(
        title: const Text("Chats"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: FireDatabase.firestore
                    .collection(chatRooms)
                    .where(
                      'members',
                      arrayContains: FireDatabase.firebaseAuth.currentUser!.uid,
                    )
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final List<ChatRoomModel> items = snapshot.data!.docs
                        .map((e) => ChatRoomModel.fromJson(e.data()))
                        .toList()
                      ..sort(
                        (a, b) =>
                            b.lastMessageTime!.compareTo(a.lastMessageTime!),
                      );

                    return ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        return ChatCard(
                          chatRoomModel: items[index],
                        );
                      },
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
