import 'package:chat_material3/utils/cache_helber.dart';
import 'package:flutter/material.dart';


class ThemeProvider with ChangeNotifier {
  bool _darkTheme = true;
  bool get getDarkTheme => _darkTheme;
  static const themeApp = 'THEME_APP';

  ThemeProvider() {
    getTheme();
  }

  Future<void> saveTheme({required bool themeValue}) async {
    await CacheHelber.saveData(key: themeApp, value: themeValue);

    _darkTheme = themeValue;
    notifyListeners();
  }

  Future<void> getTheme() async {
    bool? savedTheme = await CacheHelber.getData(key: themeApp);
    _darkTheme = savedTheme ?? false;
    notifyListeners();
  }
}
