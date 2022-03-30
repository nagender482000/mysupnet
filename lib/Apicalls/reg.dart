import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mysupnet/blockpage/block.dart';
import 'package:shared_preferences/shared_preferences.dart';

reg(
  context,
  String name,
  String email,
  String password,
  String underMedication,
  String phone,
  String role,
  String supportGroup,
  String gender,
  String countryCode,
  String disease,
) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token;

  var request = http.MultipartRequest(
      'POST', Uri.parse('https://apis.mysupnet.org/api/v1/user/register'));

  request.fields.addAll({
    'name': name,
    'email': email,
    'password': password,
    'under_medication': underMedication,
    'phone': phone,
    'role': role,
    'support_group': supportGroup,
    'gender ': gender,
    'country_code': countryCode,
    'admin': 'False',
    'disease': disease,
  });

  http.StreamedResponse response = await request.send();
  var responsed = await http.Response.fromStream(response);
  final responseData = json.decode(responsed.body);
  if (responseData["status"] >= 200 && responseData["status"] <= 400) {
    token = responseData["data"]["access_token"].toString();
    prefs.setString('token', token);
    prefs.setString('islogged', "true");
    String name = responseData["data"]["user"]["name"].toString();
    prefs.setString('name', name);
    String id = responseData["data"]["user"]["id"].toString();
    prefs.setString('id', id);
    String email = responseData["data"]["user"]["email"].toString();
    prefs.setString('email', email);

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
      Timer(const Duration(seconds: 3), () {
        Navigator.of(context).pop();
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const BlockPage()));
      });
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
    Navigator.of(context).pop();
  } else {
    String message = "Error not Defined.";
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
    Navigator.of(context).pop();
  }
}
