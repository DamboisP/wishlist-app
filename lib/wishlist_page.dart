import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wishlist_app/app_config.dart';
import 'package:wishlist_app/wishlist.dart';
import 'package:http/http.dart' as http;


class WishlistPage extends StatefulWidget {
  final String wishlistName;
  final AppConfig appConfig;

  const WishlistPage({ required this.wishlistName, required this.appConfig });

  @override
  State<StatefulWidget> createState() {
    return _WishlistPageState();
  }

}

class _WishlistPageState extends State<WishlistPage>{
  late Future<Wishlist> futureWishlist;

  @override
  Widget build(BuildContext context) {

    futureWishlist = _fetchWishlist(widget.wishlistName);
    return Scaffold(
        appBar: AppBar(title: Text(widget.wishlistName)),
        body : Center(
            child: FutureBuilder<Wishlist>(
              future: futureWishlist,
              builder: (context, snapshot) {
                if (snapshot.hasData){
                  return Text(snapshot.data!.name);
                }
                else if (snapshot.hasError){
                  return Text(snapshot.error.toString());
                }
                return CircularProgressIndicator();
              },
              )
        )
    );
  }

  Future<Wishlist> _fetchWishlist(String name) async {
    final response = await http.get(Uri.parse(widget.appConfig.apiUrl + "/" + name));

    if(response.statusCode == 200) {
      return Wishlist.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to load wishlist " + name);
    }
  }

}