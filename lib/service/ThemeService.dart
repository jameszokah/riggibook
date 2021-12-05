import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService {
  final _box = GetStorage();
  final String _key = 'isDarkMode';
  SharedPreferences? store;
  ThemeMode? getTheme;
  bool? loadTheme;

  void _saveThemeToBox(bool isDarkMode) => _box.write(_key, isDarkMode);

  bool _loadThemeFromBox() => _box.read(_key) ?? false;

  ThemeMode get theme => _loadThemeFromBox() ? ThemeMode.dark : ThemeMode.light;

  void switchTheme() {
    Get.changeThemeMode(_loadThemeFromBox() ? ThemeMode.dark : ThemeMode.light);
    _saveThemeToBox(!_loadThemeFromBox());
  }

  storeTheme() async {
    store = await SharedPreferences.getInstance();
    loadTheme = store!.getBool(_key) ?? false;
    getTheme = loadTheme! ? ThemeMode.dark : ThemeMode.light;
  }

  changeTheme() {
    Get.changeThemeMode(loadTheme! ? ThemeMode.dark : ThemeMode.light);
    store!.setBool(_key, !loadTheme!);
  }
}
