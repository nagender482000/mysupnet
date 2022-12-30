import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:mysupnet/auth/fpassword.dart';

femail(
  context,
  String email,
) async {
  var request = http.MultipartRequest(
      'GET',
      Uri.parse(
          "https://apis.mysupnet.org/api/v1/user/password/otp?email=$email"));

  http.StreamedResponse response = await request.send();
  var responsed = await http.Response.fromStream(response);
  final responseData = json.decode(responsed.body);
  if (response.statusCode == 200) {
    String message = responseData["detail"];
    Fluttertoast.showToast(msg: message);
    Navigator.of(context).pop();
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext bc) {
          return ForgotPassBottomSheet(
            email: email,
          );
        });
  } else {
    Fluttertoast.showToast(msg: responseData["detail"]);
  }
  return (responseData["detail"]);
}

fpass(
  context,
  String email,
  String otp,
  String password,
) async {
  var request = http.MultipartRequest('POST',
      Uri.parse("https://apis.mysupnet.org/api/v1/user/password/reset"));

  request.fields.addAll({"email": email, "otp": otp, "password": password});

  http.StreamedResponse response = await request.send();
  var responsed = await http.Response.fromStream(response);
  final responseData = json.decode(responsed.body);
  if (response.statusCode == 200) {
    String message = responseData["detail"];

    Fluttertoast.showToast(msg: message);
    Navigator.of(context).pop();
  } else {
    String message = responseData["detail"];
    // ignore: deprecated_member_use
    Fluttertoast.showToast(msg: message);
  }
  return (responseData["detail"]);
}
