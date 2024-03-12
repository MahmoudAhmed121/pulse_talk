import 'package:chat_material3/firebase_options.dart';
import 'package:chat_material3/provider/theme_provider.dart';
import 'package:chat_material3/screens/auth/login_screen.dart';
import 'package:chat_material3/utils/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MyApp(
      themeProvider: ThemeProvider(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.themeProvider});
  final ThemeProvider themeProvider;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PulseTalk',
      themeMode: ThemeMode.system,
      theme: AppTheme.themeData(
        //themeProvider.getDarkTheme
        isDarkTheme: false,
        context: context,
      ),
      home: const LoginScreen(),
    );
  }
}
