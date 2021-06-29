import 'package:flutter/material.dart';
import 'package:wishlist_app/app_config.dart';

import 'home.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  final conf = await AppConfig.getConfig();
  runApp(WishlistApp(appConfig: conf));
}