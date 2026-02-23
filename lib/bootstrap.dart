import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Bootstrap {
  static late SharedPreferences sharedPreferences;

  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    sharedPreferences = await SharedPreferences.getInstance();
  }
}
