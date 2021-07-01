import 'package:flutter/material.dart';
import 'package:wishlist_app/utils/globals.dart';

import 'pages/wishlist_list.dart';

/// Entry point of the app
void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MaterialApp(
      title: Globals.appName,
      theme: ThemeData(
          primaryColor: Globals.themeColor,
          accentColor: Globals.themeColor
      ),
      home: WishlistList()
  ));
}