import 'package:chat_material3/provider/theme_provider.dart';
import 'package:chat_material3/screens/auth/login_screen.dart';
import 'package:chat_material3/utils/app_theme.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
