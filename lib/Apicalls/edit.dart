import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mysupnet/fadetransition.dart';
import 'package:mysupnet/profile/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

edit(
  context,
  String name,
  String gender,
  String dob,
  String countryCode,
  String phone,
  String year,
  String hospital,
  String medications,
  String doctor,
) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token').toString();

  var headers = {'Authorization': 'Bearer ' + token.toString()};
  var request = http.MultipartRequest(
      'PATCH', Uri.parse('https://apis.mysupnet.org/api/v1/user'));
  request.headers.addAll(headers);

  request.fields.addAll({
    'name': name,
    'gender': gender,
    'date_of_birth': dob,
    'country_code': countryCode,
    'phone': phone,
    'year_of_diagnosis': year,
    'hospital': hospital,
    'medications': medications,
    'physician': doctor,
  });

  http.StreamedResponse response = await request.send();
  var responsed = await http.Response.fromStream(response);
  final responseData = json.decode(responsed.body);

  if (response.statusCode == 200) {
    String name = responseData["data"]["name"].toString();
    prefs.setString('name', name);
    Navigator.of(context).pop();

    Navigator.of(context).push(
      CustomPageRoute(const ProfileScreen()),
    );
    return responseData["data"];
  } else {
    return responseData["detail"];
  }
}
