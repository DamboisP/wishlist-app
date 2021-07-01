import 'dart:convert';

import 'package:flutter/material.dart';

class Wishlist {
  List<WishlistItem> elements;
  final String name;

  Wishlist({
    required this.name,
    this.elements = const []
  });

  factory Wishlist.fromJson(Map<String, dynamic> json){
    Wishlist list = Wishlist(name: json["name"]);

    if (json["elements"] != null) {
      list.elements = (json["elements"] as List).map((item) => WishlistItem.fromJson(item)).toList();
    }

    return list;
  }

  Map<String, dynamic> toJson(){
    return {
      "name": name
    };
  }

}

class WishlistItem {
  final String name;
  final Icon icon;

  WishlistItem({
    required this.name,
    required this.icon,
  });
  
  factory WishlistItem.fromJson(Map<String, dynamic> json){
    var iconData = IconData(json["icon"]["codePoint"], fontFamily: json["icon"]["fontFamily"]);

    return WishlistItem(
        name: json["name"],
        icon: Icon(iconData, size: 48,)
    );
  }

  Map<String, dynamic> toJson(){
    return {
      "name": name,
      "icon": {
        "codePoint": icon.icon!.codePoint,
        "fontFamily": icon.icon!.fontFamily
      }
    };
  }
}