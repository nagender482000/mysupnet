import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

bookmarkapi(
  context,
  String id,
) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token').toString();
  var headers = {'Authorization': 'Bearer ' + token.toString()};
  var request = http.MultipartRequest(
      'POST', Uri.parse("https://apis.mysupnet.org/api/v1/post/bookmark"));
  request.headers.addAll(headers);

  request.fields.addAll({
    'post_uuid': id,
  });

  http.StreamedResponse response = await request.send();
  var responsed = await http.Response.fromStream(response);
  final responseData = json.decode(responsed.body);
  if (response.statusCode == 200) {
    return (responseData["data"]);
  } else {
    return (responseData["detail"]);
  }
}
