import 'dart:convert';

import 'package:TagConnect/constants/theme_constants.dart';
import 'package:TagConnect/models/notification_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

class AutoLoginProvider extends ChangeNotifier {
  bool _isAutoLogin = false;

  bool get isAutoLogin => _isAutoLogin;

  // Key for storing the auto-login value
  static const String autoLoginKey = 'autoLogin';

  AutoLoginProvider() {
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

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  // Key for storing the dark mode value
  static const String darkModeKey = 'darkMode';

  ThemeProvider() {
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
  late Database _database;
  List<NotificationModel> _notifications = [];
  List<NotificationModel> get notifications => _notifications;

  NotificationProvider() {
    initializeDatabase();
  }

  Future<void> initializeDatabase() async {
    _database = await openDatabase(
      path.join(await getDatabasesPath(), 'notifications.db'),
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE notifications (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            body TEXT,
            data TEXT
          )
        ''');
      },
      version: 1,
    );
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    final List<Map<String, dynamic>> rows =
        await _database.query('notifications');
    _notifications = rows.map((row) {
      return NotificationModel(
        id: row['id'],
        title: row['title'],
        body: row['body'],
        data: jsonDecode(row['data']),
      );
    }).toList();
    notifyListeners();
  }

  void addNotification(NotificationModel notification) async {
    final int id = await _database.insert(
      'notifications',
      notification.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    final NotificationModel notificationWithId = NotificationModel(
      id: id,
      title: notification.title,
      body: notification.body,
      data: notification.data,
    );
    _notifications.add(notificationWithId);
    notifyListeners();
  }

  void removeNotification(int index) async {
    if (index >= 0 && index < notifications.length) {
      final NotificationModel removedNotification =
          notifications.removeAt(index);
      await _database.delete(
        'notifications',
        where: 'id = ?',
        whereArgs: [removedNotification.id],
      );
    }
    notifyListeners();
  }

  void clearNotification() async {
    await _database.delete('notifications');
    notifications.clear();
    notifyListeners();
  }
}
