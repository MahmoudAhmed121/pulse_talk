import 'package:chat_material3/screens/home/chat_home_screen.dart';
import 'package:chat_material3/screens/home/contact_home_screen.dart';
import 'package:chat_material3/screens/home/group_home_screen.dart';
import 'package:chat_material3/screens/home/setting_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:iconsax/iconsax.dart';

class LayoutApp extends StatefulWidget {
  const LayoutApp({super.key});

  @override
  State<LayoutApp> createState() => _LayoutAppState();
}

class _LayoutAppState extends State<LayoutApp> {
  int currentIndex = 0;
  PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: PageView(
        onPageChanged: (value) {
          setState(() {
            currentIndex = value;
          });
        },
        controller: pageController,
        children: const [
          ChatHomeScreen(),
          GroupHomeScreen(),
          ContactHomeScreen(),
          SettingHomeScreen()
        ],
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        indicatorColor: Colors.grey,
        elevation: 0,
        selectedIndex: currentIndex,
        onDestinationSelected: (value) {
          setState(() {
            currentIndex = value;
            pageController.jumpToPage(value);
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(
              Iconsax.message,
            ),
            label: "Chat",
          ),
          NavigationDestination(
            icon: Icon(
              Iconsax.messages,
            ),
            label: "Group",
          ),
          NavigationDestination(
            icon: Icon(
              IconlyLight.user2,
            ),
            label: "Contacts",
          ),
          NavigationDestination(
            icon: Icon(
              Iconsax.setting,
            ),
            label: "Setting",
          ),
        ],
      ),
    );
  }
}
