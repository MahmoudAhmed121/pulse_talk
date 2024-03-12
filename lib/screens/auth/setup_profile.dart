import 'package:chat_material3/screens/auth/login_screen.dart';
import 'package:chat_material3/utils/colors.dart';
import 'package:chat_material3/utils/my_validator.dart';
import 'package:chat_material3/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class SetupProfile extends StatefulWidget {
  const SetupProfile({super.key});

  @override
  State<SetupProfile> createState() => _SetupProfileState();
}

class _SetupProfileState extends State<SetupProfile> {
  @override
  Widget build(BuildContext context) {
    TextEditingController nameCon = TextEditingController();
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                  (route) => false);
            },
            icon: const Icon(
              Iconsax.arrow_right_3,
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              Text(
                "Welcome,",
                style: Theme.of(context).textTheme.displayMedium,
              ),
              Text(
                "PulseTalk Chat App",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                "Please Enter Your Name",
                style: Theme.of(context).textTheme.bodySmall,
              ),
              CustomField(
                controller: nameCon,
                lable: "Name",
                icon: Iconsax.user,
                validator: (value) {
                  MyValidators.displayNamevalidator(value);
                  return '';
                },
              ),
              const SizedBox(
                height: 16,
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  backgroundColor:AppColor. kPrimaryColor,
                  padding: const EdgeInsets.all(16),
                ),
                child: Center(
                  child: Text(
                    "Continuo".toUpperCase(),
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
