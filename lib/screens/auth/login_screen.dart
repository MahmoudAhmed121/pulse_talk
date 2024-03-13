import 'package:chat_material3/layout.dart';
import 'package:chat_material3/screens/auth/forget_screen.dart';
import 'package:chat_material3/screens/auth/setup_profile.dart';
import 'package:chat_material3/utils/colors.dart';
import 'package:chat_material3/utils/my_validator.dart';
import 'package:chat_material3/widgets/logo.dart';
import 'package:chat_material3/widgets/text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final TextEditingController emailCon;
  late final TextEditingController passCon;
  late final FocusNode passFocusNode;
  late final FocusNode emailFocusNode;
  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    emailCon = TextEditingController();
    passCon = TextEditingController();
    passFocusNode = FocusNode();
    emailFocusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    emailCon.dispose();
    passCon.dispose();
    passFocusNode.dispose();
    emailFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const LogoApp(),
              const SizedBox(
                height: 20,
              ),
              Text(
                "Welcome Back,",
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              Text(
                "PulseTalk Chat App",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    CustomField(
                      controller: emailCon,
                      lable: "Email",
                      icon: IconlyLight.message,
                      focusNode: emailFocusNode,
                      validator: (value) {
                        return MyValidators.emailValidator(value);
                      },
                      onEditingComplete: () {
                        FocusScope.of(context).requestFocus(passFocusNode);
                      },
                    ),
                    CustomField(
                      controller: passCon,
                      lable: "Password",
                      focusNode: passFocusNode,
                      icon: IconlyLight.lock,
                      isPass: true,
                      validator: (value) {
                        return MyValidators.passwordValidator(value);
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Row(
                      children: [
                        const Spacer(),
                        GestureDetector(
                          child: const Text("Forget Password?"),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ForgetScreen(),
                              ),
                            );
                          },
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                                  email: emailCon.text, password: passCon.text)
                              .then((value) => Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const LayoutApp(),
                                    ),
                                    (route) => false,
                                  ))
                              .onError(
                                (error, stackTrace) =>
                                    ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      error.toString(),
                                    ),
                                  ),
                                ),
                              );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: AppColor.kPrimaryColor,
                        padding: const EdgeInsets.all(16),
                      ),
                      child: Center(
                        child: Text(
                          "Login".toUpperCase(),
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.all(16),
                      ),
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SetupProfile(),
                            ),
                            (route) => false);
                      },
                      child: Center(
                        child: Text(
                          "Create Account".toUpperCase(),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
