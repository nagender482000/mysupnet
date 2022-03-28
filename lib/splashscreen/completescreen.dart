import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mysupnet/Apicalls/splash.dart';
import 'package:mysupnet/auth/login.dart';
import 'package:mysupnet/fadetransition.dart';

import 'package:shared_preferences/shared_preferences.dart';

class FinalPage extends StatefulWidget {
  const FinalPage({Key? key}) : super(key: key);

  @override
  State<FinalPage> createState() => _FinalPageState();
}

class _FinalPageState extends State<FinalPage> {
  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    super.initState();
    Timer(const Duration(seconds: 2), () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token').toString();
      String islogged = prefs.getString('islogged').toString();

      if (islogged == "true") {
        splash(token, context);
      } else {
        Navigator.of(context).pop();
        Navigator.of(context).push(CustomPageRoute(const LoginPage()));
      }
    });
  }

  @override
  void dispose() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xFFF2F9FF),
      body: SizedBox(
        height: size.height,
        child: Column(
          children: [
            SizedBox(
              height: size.height * 0.35,
            ),
            Padding(
              padding: const EdgeInsets.all(60.0),
              child: Image.asset("assets/images/nameArtboard 1.png"),
            ),
            SizedBox(
              height: size.height * 0.25,
            ),
            // const Text(
            //   "OUR FUNDERS",
            //   style: TextStyle(
            //     fontFamily: "Avenir LT Std",
            //     color: Color(0xFFB8B8B8),
            //     fontSize: 10,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 170),
            //   child: Image.asset("assets/images/image001.png"),
            // ),
          ],
        ),
      ),
    );
  }
}
