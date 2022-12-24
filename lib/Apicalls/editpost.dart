import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mysupnet/home/feed/HomeFeed.dart';
import 'package:shared_preferences/shared_preferences.dart';

editpost(
  context,
  String uuid,
  String posttext,
) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token').toString();

  var headers = {'Authorization': 'Bearer ' + token.toString()};
  var request = http.MultipartRequest(
      'PATCH', Uri.parse("https://apis.mysupnet.org/api/v1/post"));
  request.headers.addAll(headers);
  request.fields.addAll({
    "uuid": uuid,
    'text': posttext,
  });

  http.StreamedResponse response = await request.send();
  var responsed = await http.Response.fromStream(response);
  final responseData = json.decode(responsed.body);
  if (response.statusCode == 200) {
    Navigator.of(context).pop();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const HomeFeedPage()),
        (Route<dynamic> route) => false);
    return (responseData["data"]);
  } else {
    Navigator.of(context).pop();

    return (responseData["detail"]);
  }
}
