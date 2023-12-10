import 'package:TagConnect/constants/theme_constants.dart';
import 'package:TagConnect/models/notification_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AutoLoginNotifier extends ChangeNotifier {
  bool _isAutoLogin = false;

  bool get isAutoLogin => _isAutoLogin;

  // Key for storing the auto-login value
  static const String autoLoginKey = 'autoLogin';

  AutoLoginNotifier() {
    loadAutoLogin();
  }

  void toggleLogin() {
    _isAutoLogin = !_isAutoLogin;
    saveAutoLogin(_isAutoLogin);

    notifyListeners();
  }

  Future<void> loadAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    _isAutoLogin = prefs.getBool(autoLoginKey) ?? false;
  }

  Future<void> saveAutoLogin(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(autoLoginKey, value);
  }
}

class ThemeNotifier extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  // Key for storing the dark mode value
  static const String darkModeKey = 'darkMode';

  ThemeNotifier() {
    loadDarkMode();
  }

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;

    // Save the dark mode value
    saveDarkMode(_isDarkMode);

    _updateSystemNavigationBarColor();
    notifyListeners();
  }

  void _updateSystemNavigationBarColor() {
    final ThemeData currentTheme = _isDarkMode ? darkTheme : lightTheme;
    final Color navigationBarColor = currentTheme.scaffoldBackgroundColor;

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: navigationBarColor,
    ));
  }

  Future<void> loadDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool(darkModeKey) ?? false;
  }

  Future<void> saveDarkMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(darkModeKey, value);
  }
}

class NotificationProvider with ChangeNotifier {
  List<NotificationModel> _notifications = [];

  List<NotificationModel> get notifications => _notifications;

  void addNotification(NotificationModel notification) {
    _notifications.add(notification);
    notifyListeners();
  }

  void removeNotification(int index) {
    if (index >= 0 && index < notifications.length) {
      notifications.removeAt(index);
    }
    notifyListeners();
  }

  void clearNotification() {
    notifications.clear();
    notifyListeners();
  }
}
