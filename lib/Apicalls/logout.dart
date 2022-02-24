import 'package:flutter/material.dart';
import 'package:mysupnet/auth/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

logout(context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('islogged', "false");
  prefs.setString('token', "");

  Navigator.of(context).pushReplacement(MaterialPageRoute(
    builder: (context) => const LoginPage(),
  ));
}
