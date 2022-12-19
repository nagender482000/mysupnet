import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:mysupnet/auth/fotp.dart';
import 'package:mysupnet/auth/fpassword.dart';

femail(
  context,
  String email,
) async {
  var request = http.MultipartRequest(
      'GET', Uri.parse("https://apis.mysupnet.org/api/v1/user/otp"));

  request.fields.addAll({"email": email});

  http.StreamedResponse response = await request.send();
  var responsed = await http.Response.fromStream(response);
  final responseData = json.decode(responsed.body);
  if (response.statusCode == 200) {
    print("OK");
    String message = responseData["detail"];
    print(message);
    Fluttertoast.showToast(msg: message);
    Navigator.of(context).pop();
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext bc) {
          return ForgotOTPBottomSheet(
            email: email,
          );
        });
    // Navigator.of(context).push(MaterialPageRoute(
    //   builder: (context) => const HomeFeedPage(),
    // ));
    // String message = responseData["detail"];
    // showDialog(
    //     context: context,
    //     builder: (_) => AlertDialog(
    //           title: const Text(
    //             'Forgot Password.',
    //             style: TextStyle(
    //               fontFamily: "Avenir LT Std",
    //               color: Colors.black,
    //               fontSize: 20,
    //             ),
    //           ),
    //           content: Text(
    //             message.toUpperCase(),
    //             textAlign: TextAlign.center,
    //             style: const TextStyle(
    //               fontFamily: "Avenir LT Std",
    //               color: Colors.black,
    //               fontSize: 16,
    //             ),
    //           ),
    //           actions: [
    //             Padding(
    //               padding: const EdgeInsets.symmetric(
    //                   horizontal: 20.0, vertical: 10.0),
    //               child: InkWell(
    //                 onTap: () {
    //                   Navigator.of(context).pop();
    //                 },
    //                 child: Container(
    //                   width: MediaQuery.of(context).size.width,
    //                   padding: const EdgeInsets.symmetric(vertical: 13),
    //                   alignment: Alignment.center,
    //                   decoration: BoxDecoration(
    //                       borderRadius:
    //                           const BorderRadius.all(Radius.circular(4)),
    //                       boxShadow: <BoxShadow>[
    //                         BoxShadow(
    //                             color: const Color(0xffB8B8B8).withAlpha(100),
    //                             offset: const Offset(0, 4),
    //                             blurRadius: 8,
    //                             spreadRadius: 2)
    //                       ],
    //                       color: const Color(0xFF71B48D)),
    //                   child: const Text(
    //                     'OK',
    //                     style: TextStyle(
    //                       fontFamily: "Avenir LT Std",
    //                       color: Colors.white,
    //                       fontSize: 20,
    //                       fontWeight: FontWeight.bold,
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //             ),
    //           ],
    //         ));

    // return (responseData["details"]);
  } else {
    print("Not OK");
    String message = responseData["detail"];
    print(message);
    // showDialog(
    //     context: context,
    //     builder: (_) => AlertDialog(
    //           title: const Text(
    //             'Forgot Password.',
    //             style: TextStyle(
    //               fontFamily: "Avenir LT Std",
    //               color: Colors.white,
    //               fontSize: 16,
    //             ),
    //           ),
    //           content: Text(
    //             message.toUpperCase(),
    //             textAlign: TextAlign.center,
    //             style: const TextStyle(
    //               fontFamily: "Avenir LT Std",
    //               color: Colors.black,
    //               fontSize: 16,
    //               fontWeight: FontWeight.bold,
    //             ),
    //           ),
    //           actions: [
    //             Padding(
    //               padding: const EdgeInsets.all(20.0),
    //               child: InkWell(
    //                 onTap: () {
    //                   Navigator.of(context).pop();
    //                 },
    //                 child: Container(
    //                   width: MediaQuery.of(context).size.width,
    //                   padding: const EdgeInsets.symmetric(vertical: 13),
    //                   alignment: Alignment.center,
    //                   decoration: BoxDecoration(
    //                       borderRadius:
    //                           const BorderRadius.all(Radius.circular(4)),
    //                       boxShadow: <BoxShadow>[
    //                         BoxShadow(
    //                             color: const Color(0xffB8B8B8).withAlpha(100),
    //                             offset: const Offset(0, 4),
    //                             blurRadius: 8,
    //                             spreadRadius: 2)
    //                       ],
    //                       color: const Color(0xFF71B48D)),
    //                   child: const Text(
    //                     'OK',
    //                     style: TextStyle(
    //                       fontFamily: "Avenir LT Std",
    //                       color: Colors.white,
    //                       fontSize: 20,
    //                       fontWeight: FontWeight.bold,
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //             ),
    //           ],
    //         ));
  }
  return (responseData["detail"]);
}

fotp(context, String email, String otp) async {
  var request = http.MultipartRequest(
      'GET', Uri.parse("https://apis.mysupnet.org/api/v1/user/validate_otp"));

  request.fields.addAll({"email": email, "otp": otp});

  http.StreamedResponse response = await request.send();
  var responsed = await http.Response.fromStream(response);
  final responseData = json.decode(responsed.body);
  if (response.statusCode == 200) {
    print("Not OK");
    String message = responseData["detail"];
    print(message);
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
    print("Not OK");
    String message = responseData["detail"];
    print(message);
  }
  return (responseData["detail"]);
}

fpass(context, String email, String password) async {
  var request = http.MultipartRequest('POST',
      Uri.parse("https://apis.mysupnet.org/api/v1/user/password/reset"));

  request.fields.addAll({"email": email, "password": password});

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
