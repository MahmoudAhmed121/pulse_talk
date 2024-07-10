import 'package:chat_material3/firebase_options.dart';
import 'package:chat_material3/layout.dart';
import 'package:chat_material3/provider/theme_provider.dart';
import 'package:chat_material3/screens/auth/login_screen.dart';
import 'package:chat_material3/utils/app_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PulseTalk',
      themeMode: ThemeMode.system,
      theme: AppTheme.themeData(
        isDarkTheme: themeProvider.getDarkTheme,
        context: context,
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.userChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            return const LayoutApp();
          } else {
            return const LoginScreen();
          }
        },
      ),
    );
  }
}
