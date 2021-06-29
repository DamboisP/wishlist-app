import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:wishlist_app/wishlist.dart';
import 'package:wishlist_app/wishlist_page.dart';
import 'app_config.dart';

class WishlistApp extends StatefulWidget {
  final AppConfig appConfig;

  WishlistApp({required this.appConfig});

  @override
  State<StatefulWidget> createState() {
    return _WishlistAppState(appConfig: appConfig);
  }
}

class _WishlistAppState extends State<WishlistApp> {
  final AppConfig appConfig;
  late Future<List<Wishlist>> futureWishlists;
  late Future<Wishlist> futureWishlist;

  _WishlistAppState({required this.appConfig});

  @override
  void initState(){
    super.initState();
    futureWishlists = fetchWishlists();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData.light(),
        home: Scaffold(
            appBar: AppBar(
              title: Text("Wishlist"),
            ),
            body: Center(
              child: FutureBuilder<List<Wishlist>>(
                future: futureWishlists,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return getTiles(snapshot.data ?? []);
                  }
                  return CircularProgressIndicator();
                },
              ),
            )
        )
    );
  }

  Widget getTiles(List<Wishlist> lists) {
    return RefreshIndicator(
        child: ListView.builder(
          itemCount: lists.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(lists[index].name),
              onTap: () => openWishlist(context, lists[index].name),
            );
          },
        ),
        onRefresh: refreshWishlists
    );
  }

  void openWishlist(BuildContext context, String name) {
    Navigator.of(context).push(
        MaterialPageRoute(
            builder: (BuildContext ctx) {
              return WishlistPage(wishlistName: name, appConfig: appConfig);
            }
        )
    );
  }


  Future<void> refreshWishlists() async{
    setState(() {
      futureWishlists = fetchWishlists();
    });
  }

  Future<List<Wishlist>> fetchWishlists() async {
    final response = await http.get(Uri.parse(appConfig.apiUrl));

    if(response.statusCode == 200) {
      final lists = (jsonDecode(response.body) as List).map((i) => Wishlist.fromJson(i)).toList();
      return lists;
    } else {
      throw Exception("Failed to load wishlists");
    }
  }

}