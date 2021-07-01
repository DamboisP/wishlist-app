import 'dart:convert';

import 'package:flutter/services.dart';

class AppConfig {
  final String apiUrl;

  AppConfig({this.apiUrl = ""});

  static Future<AppConfig> getConfig() async {
    final contents = await rootBundle.loadString(
        'assets/settings.json'
    );
    final json = jsonDecode(contents);

    return AppConfig(apiUrl: json['apiUrl']);
  }
}