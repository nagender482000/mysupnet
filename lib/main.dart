import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:mysupnet/blockpage/block.dart';
import 'package:mysupnet/home/feed.dart';
import 'package:mysupnet/splashscreen/splashscreen.dart';

void main() {
  runApp(const MyApp());
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.dark,
    ),
  );
}

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
