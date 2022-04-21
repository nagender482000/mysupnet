import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

forgot(
  context,
  String email,
) async {
  var request = http.MultipartRequest('POST',
      Uri.parse("https://apis.mysupnet.org/api/v1/user/password/reset"));

  request.fields.addAll({
    'email': email,
  });

  http.StreamedResponse response = await request.send();
  var responsed = await http.Response.fromStream(response);
  final responseData = json.decode(responsed.body);
  if (response.statusCode == 200) {
    // Navigator.of(context).push(MaterialPageRoute(
    //   builder: (context) => const HomeFeedPage(),
    // ));
    String message = responseData["detail"];
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: const Text(
                'Forgot Password.',
                style: TextStyle(
                  fontFamily: "Avenir LT Std",
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
              content: Text(
                message.toUpperCase(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: "Avenir LT Std",
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(4)),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: const Color(0xffB8B8B8).withAlpha(100),
                                offset: const Offset(0, 4),
                                blurRadius: 8,
                                spreadRadius: 2)
                          ],
                          color: const Color(0xFF71B48D)),
                      child: const Text(
                        'OK',
                        style: TextStyle(
                          fontFamily: "Avenir LT Std",
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ));

    return (responseData["details"]);
  } else {
    String message = responseData["detail"];
    // ignore: deprecated_member_use

    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: const Text(
                'Forgot Password.',
                style: TextStyle(
                  fontFamily: "Avenir LT Std",
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              content: Text(
                message.toUpperCase(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: "Avenir LT Std",
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(4)),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: const Color(0xffB8B8B8).withAlpha(100),
                                offset: const Offset(0, 4),
                                blurRadius: 8,
                                spreadRadius: 2)
                          ],
                          color: const Color(0xFF71B48D)),
                      child: const Text(
                        'OK',
                        style: TextStyle(
                          fontFamily: "Avenir LT Std",
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ));
  }
  return (responseData["detail"]);
}
