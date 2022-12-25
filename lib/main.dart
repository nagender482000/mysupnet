import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:mysupnet/auth/login.dart';
import 'package:mysupnet/home/feed/FeedProvider.dart';
import 'package:mysupnet/home/feed/HomeFeed.dart';
import 'package:mysupnet/profile/editprofile.dart';
import 'package:mysupnet/splashscreen/splashscreen.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

void main() {
  runApp(MultiProvider(providers: providers, child: const MyApp()));
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.dark,
    ),
  );
}

List<SingleChildWidget> providers = [
  ChangeNotifierProvider<FeedProvider>(create: (_) => FeedProvider()),
];

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MySupNet',
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData(),
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        primarySwatch: Colors.blue,
      ),
      home: const SplashPage(),
    );
  }
}
