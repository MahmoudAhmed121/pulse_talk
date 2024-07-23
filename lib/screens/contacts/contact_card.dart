import 'package:chat_material3/firebase/fire_database.dart';
import 'package:chat_material3/models/user_model.dart';
import 'package:chat_material3/screens/chat/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ContactCard extends StatelessWidget {
  const ContactCard({
    super.key,
    required this.user,
  });
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const CircleAvatar(),
        subtitle: Text(
          user.about!,
          overflow: TextOverflow.ellipsis,
        ),
        title: Text(user.name!),
        trailing: IconButton(
          onPressed: () {
            final List<String> roomId = [
              user.id!,
              FirebaseAuth.instance.currentUser!.uid
            ]..sort(
                (a, b) => a.compareTo(b),
              );
            FireDatabase().createChatRoom(email: user.email!).then((value) {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return ChatScreen(
                  roomId: roomId.toString(),
                  userModel: user,
                );
              }));
            });
          },
          icon: const Icon(
            Iconsax.message,
          ),
        ),
      ),
    );
  }
}
