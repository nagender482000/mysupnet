import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:mysupnet/fadetransition.dart';
import 'package:mysupnet/profile/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

edit(context, Map<String, String> message) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token').toString();

  var headers = {'Authorization': 'Bearer ' + token.toString()};
  var request = http.MultipartRequest(
      'PATCH', Uri.parse('https://apis.mysupnet.org/api/v1/user'));
  request.headers.addAll(headers);

  request.fields.addAll(message);

  http.StreamedResponse response = await request.send();
  var responsed = await http.Response.fromStream(response);
  final responseData = json.decode(responsed.body);
  if (response.statusCode == 200) {
    String message = responseData["detail"];
    // ignore: deprecated_member_use
    Fluttertoast.showToast(msg: message.toString());

    if (message == "success") {
      String name = responseData["data"]["name"].toString();
      prefs.setString('name', name);
      Navigator.of(context).pop();

      Navigator.of(context).push(
        CustomPageRoute(const ProfileScreen()),
      );
      return responseData["data"];
    }
  }
}
