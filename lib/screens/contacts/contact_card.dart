import 'package:chat_material3/models/user_model.dart';
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
          onPressed: () {},
          icon: const Icon(
            Iconsax.message,
          ),
        ),
      ),
    );
  }
}
