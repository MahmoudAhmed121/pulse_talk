import 'package:chat_material3/firebase/fire_database.dart';
import 'package:chat_material3/models/user_model.dart';
import 'package:chat_material3/screens/contacts/contact_card.dart';
import 'package:chat_material3/utils/constant.dart';
import 'package:chat_material3/utils/my_validator.dart';
import 'package:chat_material3/widgets/text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ContactHomeScreen extends StatefulWidget {
  const ContactHomeScreen({super.key});

  @override
  State<ContactHomeScreen> createState() => _ContactHomeScreenState();
}

class _ContactHomeScreenState extends State<ContactHomeScreen> {
  bool searched = false;
  TextEditingController emailCon = TextEditingController();
  TextEditingController searchCon = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          searched
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      searched = false;
                    });
                  },
                  icon: const Icon(
                    Iconsax.close_circle,
                  ),
                )
              : IconButton(
                  onPressed: () {
                    setState(() {
                      searched = true;
                    });
                  },
                  icon: const Icon(
                    Iconsax.search_normal,
                  ),
                )
        ],
        title: searched
            ? Row(
                children: [
                  Expanded(
                    child: TextField(
                      autofocus: true,
                      controller: searchCon,
                      decoration: const InputDecoration(
                        hintText: "Search by name",
                        border: InputBorder.none,
                      ),
                      onChanged: (value) {
                        setState(() {
                          searchCon.text == value;
                        });
                      },
                    ),
                  )
                ],
              )
            : const Text("My Contacts"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showBottomSheet(
            context: context,
            builder: (context) {
              return Container(
                padding: const EdgeInsets.all(20),
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
                        )
                      ],
                    ),
                    CustomField(
                      controller: emailCon,
                      icon: Iconsax.direct,
                      lable: "Email",
                      validator: (value) {
                        MyValidators.emailValidator(value);
                        return '';
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          backgroundColor:
                              Theme.of(context).colorScheme.primaryContainer),
                      onPressed: () async {
                        await FireDatabase.addContacts(email: emailCon.text)
                            .then((value) {
                          emailCon.clear();
                          Navigator.pop(context);
                        });
                      },
                      child: const Center(
                        child: Text("Add Contact"),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: const Icon(Iconsax.user_add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection(users)
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection(users)
                            .where('id', whereIn: snapshot.data!['my_users'])
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final List<UserModel> users = snapshot.data!.docs
                                .map((e) => UserModel.fromJson(e.data()))
                                .where((element) => element.name!
                                    .toLowerCase()
                                    .startsWith(searchCon.text.toLowerCase()))
                                .toList()..sort((a, b) =>  a.name!.compareTo(b.name!),);
                            return ListView.builder(
                              itemCount: users.length,
                              itemBuilder: (context, index) {
                                return ContactCard(
                                  user: users[index],
                                );
                              },
                            );
                          }
                          return const Center(
                              child: CircularProgressIndicator());
                        },
                      );
                    } else {
                      return const SizedBox();
                    }
                  }),
            )
          ],
        ),
      ),
    );
  }
}
