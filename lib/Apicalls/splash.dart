import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mysupnet/blockpage/block.dart';
import 'package:mysupnet/home/feed.dart';

splash(String? token, context) async {
  var headers = {'Authorization': 'Bearer ' + token.toString()};
  var request = http.MultipartRequest(
      'GET', Uri.parse('https://apis.mysupnet.org/api/v1/user'));

  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();
  var responsed = await http.Response.fromStream(response);
  final responseData = json.decode(responsed.body);

  if (response.statusCode == 200) {
    String napprove = responseData["data"]["needs_approval"].toString();
    if (napprove == 'true') {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const BlockPage()));
    } else {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeFeedPage()));
    }
  } else {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (_) => const BlockPage()));
  }
}
