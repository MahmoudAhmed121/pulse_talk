import 'package:chat_material3/screens/auth/login_screen.dart';
import 'package:chat_material3/utils/colors.dart';
import 'package:chat_material3/utils/my_validator.dart';
import 'package:chat_material3/widgets/logo.dart';
import 'package:chat_material3/widgets/text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

class ForgetScreen extends StatefulWidget {
  const ForgetScreen({super.key});

  @override
  State<ForgetScreen> createState() => _ForgetScreenState();
}

class _ForgetScreenState extends State<ForgetScreen> {
  late final TextEditingController emailCon;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    emailCon = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    emailCon.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const LogoApp(),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "Reset Password,",
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                Text(
                  "Please Enter Your Email",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                CustomField(
                  controller: emailCon,
                  lable: "Email",
                  icon: IconlyLight.message,
                  validator: (value) {
                    return MyValidators.emailValidator(value);
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      FirebaseAuth.instance
                          .sendPasswordResetEmail(email: emailCon.text)
                          .then(
                        (value) {
                          Navigator.pushAndRemoveUntil(context,
                              MaterialPageRoute(
                            builder: (context) {
                              return const LoginScreen();
                            },
                          ), (route) => false);
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text("Please check your email"),
                          ));
                        },
                      ).onError(
                        (error, stackTrace) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                error.toString(),
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        12,
                      ),
                    ),
                    backgroundColor: AppColor.kPrimaryColor,
                    padding: const EdgeInsets.all(16),
                  ),
                  child: Center(
                    child: Text(
                      "Send Email".toUpperCase(),
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
