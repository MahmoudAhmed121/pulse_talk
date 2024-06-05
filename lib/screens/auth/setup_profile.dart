import 'package:chat_material3/firebase/firebase_auth.dart';
import 'package:chat_material3/screens/auth/login_screen.dart';
import 'package:chat_material3/utils/colors.dart';
import 'package:chat_material3/utils/my_validator.dart';
import 'package:chat_material3/widgets/text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:iconsax/iconsax.dart';

class SetupProfile extends StatefulWidget {
  const SetupProfile({super.key});

  @override
  State<SetupProfile> createState() => _SetupProfileState();
}

class _SetupProfileState extends State<SetupProfile> {
  late final TextEditingController _nameCon;
  late final TextEditingController _emailCon;
  late final TextEditingController _passCon;
  late final TextEditingController _repetpassCon;
  late final FocusNode _nameFocusNode;
  late final FocusNode _emailFocusNode;
  late final FocusNode _passFocusNode;
  late final FocusNode _repetpassFocusNode;
  late final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameCon = TextEditingController();
    _emailCon = TextEditingController();
    _passCon = TextEditingController();
    _repetpassCon = TextEditingController();
    _nameFocusNode = FocusNode();
    _emailFocusNode = FocusNode();
    _passFocusNode = FocusNode();
    _repetpassFocusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    _nameCon.dispose();
    _emailCon.dispose();
    _passCon.dispose();
    _passFocusNode.dispose();
    _emailFocusNode.dispose();
    _repetpassCon.dispose();
    _repetpassFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        actions: const [
          // IconButton(
          //   onPressed: () {
          //     Navigator.pushAndRemoveUntil(
          //         context,
          //         MaterialPageRoute(
          //           builder: (context) => const LoginScreen(),
          //         ),
          //         (route) => false);
          //   },
          //   icon: const Icon(
          //     Iconsax.arrow_right_3,
          //   ),
          // )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
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
                  controller: _nameCon,
                  lable: "Name",
                  icon: Iconsax.user,
                  focusNode: _nameFocusNode,
                  validator: (value) {
                    return MyValidators.displayNamevalidator(value);
                  },
                  onEditingComplete: () {
                    FocusScope.of(context).requestFocus(_emailFocusNode);
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                CustomField(
                  controller: _emailCon,
                  lable: "Email",
                  icon: IconlyLight.message,
                  focusNode: _emailFocusNode,
                  validator: (value) {
                    return MyValidators.emailValidator(value);
                  },
                  onEditingComplete: () {
                    FocusScope.of(context).requestFocus(_passFocusNode);
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                CustomField(
                  controller: _passCon,
                  lable: "Password",
                  focusNode: _passFocusNode,
                  icon: IconlyLight.lock,
                  isPass: true,
                  validator: (value) {
                    return MyValidators.passwordValidator(value);
                  },
                  onEditingComplete: () {
                    FocusScope.of(context).requestFocus(_repetpassFocusNode);
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                CustomField(
                  controller: _repetpassCon,
                  lable: "Repeat Password",
                  focusNode: _repetpassFocusNode,
                  icon: IconlyLight.lock,
                  isPass: true,
                  validator: (value) {
                    return MyValidators.repeatPasswordValidator(
                      value: value,
                      password: _passCon.text,
                    );
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                        email: _emailCon.text,
                        password: _passCon.text,
                      )
                          .then((value) {
                        FireAuth.createUser(name: _nameCon.text);
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                            (route) => false);
                      }).onError(
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
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: AppColor.kPrimaryColor,
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
      ),
    );
  }
}
