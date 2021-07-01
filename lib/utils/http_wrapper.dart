
import 'dart:convert';

import 'package:wishlist_app/utils/app_config.dart';
import 'package:wishlist_app/model/wishlist.dart';
import 'package:http/http.dart' as http;

/// Set of static methods to interact with the API
class HttpWrapper {
  static AppConfig? _appConfig;

  /// Loads the config file if not already done
  static Future _initConfigIfNeeded() async {
    if (_appConfig == null){
      _appConfig = await AppConfig.getConfig();
    }
  }

  /// Returns the headers required for POST calls
  static Map<String, String> _getHeaders() {
    return const <String, String>{
      "Content-Type": "application/json; charset=UTF-8"
    };
  }

  /// Fetches all wishlists
  static Future<List<Wishlist>> fetchWishlists() async {
    await _initConfigIfNeeded();

    final response = await http.get(
        Uri.parse(_appConfig!.apiUrl)
    );

    if(response.statusCode == 200) {
      final lists = (jsonDecode(response.body) as List).map((i) => Wishlist.fromJson(i)).toList();
      return lists;
    } else {
      throw Exception("Failed to load wishlists");
    }
  }

  /// Returns a wishlist's details
  static Future<Wishlist> fetchWishlist(String name) async {
    await _initConfigIfNeeded();

    final response = await http.get(
        Uri.parse(_appConfig!.apiUrl + "/" + name)
    );

    if(response.statusCode == 200) {
      return Wishlist.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to load wishlist " + name);
    }
  }

  /// Adds a wishlist
  static Future addWishlist(String name) async {
    await _initConfigIfNeeded();

    final newList = Wishlist(name: name);
    final response = await http.post(
        Uri.parse(_appConfig!.apiUrl),
        body: jsonEncode(newList.toJson()),
        headers: _getHeaders()
    );

    if(response.statusCode != 200){
      throw Exception("Failed to insert the new wishlist");
    }

  }

}