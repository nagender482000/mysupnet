import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mysupnet/Apicalls/splash.dart';

import 'package:shared_preferences/shared_preferences.dart';

log(String email, String password, BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // var headers = {'Authorization': 'Bearer ' + token.toString()};
  var request = http.MultipartRequest(
      'POST', Uri.parse('https://apis.mysupnet.org/api/v1/user/login'));
  request.fields.addAll({'email': email, 'password': password});
  // request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();
  var responsed = await http.Response.fromStream(response);

  final responseData = json.decode(responsed.body);
  if (responseData["status"] >= 200 && responseData["status"] <= 400) {
    String message = responseData["detail"];
    // ignore: deprecated_member_use
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(
        message,
        style: const TextStyle(
          fontFamily: "Avenir LT Std",
          color: Colors.white,
          fontSize: 16,
        ),
      ),
    ));
    if (message == "success") {
      String token = responseData["data"]["access_token"].toString();
      String id = responseData["data"]["user"]["id"].toString();
      prefs.setString('islogged', "true");
      prefs.setString('token', token);
      prefs.setString('id', id);
      String name = responseData["data"]["user"]["name"].toString();
      prefs.setString('name', name);
      splash(token, context);
    }
  } else if (responseData["status"] >= 400 && responseData["status"] <= 500) {
    String message = responseData["detail"];
    // ignore: deprecated_member_use
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(
        message,
        style: const TextStyle(
          fontFamily: "Avenir LT Std",
          color: Colors.white,
          fontSize: 16,
        ),
      ),
    ));
  } else {
    String message = responseData["detail"];
    // ignore: deprecated_member_use
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(
        message,
        style: const TextStyle(
          fontFamily: "Avenir LT Std",
          color: Colors.white,
          fontSize: 16,
        ),
      ),
    ));
  }
}
