import 'dart:collection';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mysupnet/global.dart';
import 'package:mysupnet/home/feed/HomeFeed.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserProfileScreen extends StatefulWidget {
  final String email;
  const UserProfileScreen({Key? key, required this.email}) : super(key: key);

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  LinkedHashMap<String, dynamic> userdata = LinkedHashMap();
  var isLoading = true;
  String dob = "";
  String year = "";

  void onTabTapped(int index) {
    setState(() {});
  }

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    getuser();
    super.initState();
  }

  getuser() async {
    setState(() {
      isLoading = true;
    });
    await profile();
    setState(() {
      isLoading = false;
    });
  }

  profile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token').toString();

    var headers = {'Authorization': 'Bearer ' + token.toString()};
    var request = http.MultipartRequest(
        'GET',
        Uri.parse(
            'https://apis.mysupnet.org/api/v1/user?email=' + widget.email));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    var responsed = await http.Response.fromStream(response);
    final responseData = json.decode(responsed.body);
    if (response.statusCode == 200) {
      userdata = responseData["data"];
    } else {
      return responseData["detail"];
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    if (userdata["date_of_birth"] != null) {
      dob = DateFormat("yyyy-MM-dd")
          .format(DateTime.parse(userdata["date_of_birth"].toString()))
          .toString();
    } else {
      dob = "";
    }

    if (userdata["year_of_diagnosis"] != null) {
      year = DateFormat("yyyy")
          .format(DateTime.parse(userdata["year_of_diagnosis"].toString()))
          .toString();
    } else {
      year = "";
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SizedBox(
              height: size.height * 1.2,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Topbar(size: size),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: size.width * 0.75,
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                    child: CachedNetworkImage(
                                  imageUrl:
                                      baseurl + userdata["photo"].toString(),
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    width: 80.0,
                                    height: 80.0,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                  placeholder: (context, url) => const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const CircleAvatar(
                                          radius: 50,
                                          backgroundImage: AssetImage(
                                            "assets/images/user.png",
                                          )),
                                )),
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      userdata["name"].toString(),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontFamily: "Avenir LT Std",
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      userdata["gender"].toString() +
                                          "," +
                                          userdata["country_code"].toString(),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontFamily: "Avenir LT Std",
                                        color: Colors.black,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      "Born " + dob,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontFamily: "Avenir LT Std",
                                        color: Color(0xFFB8B8B8),
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.email,
                                  color: Color(0xFF4682B4),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  userdata["email"].toString(),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontFamily: "Avenir LT Std",
                                    color: Color(0xFF000000),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.call,
                                  color: Color(0xFF4682B4),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  userdata["phone"].toString(),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontFamily: "Avenir LT Std",
                                    color: Color(0xFFB8B8B8),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: size.height * 0.05,
                            ),
                            const Text(
                              "Disease Information",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: "Avenir LT Std",
                                color: Color(0xFF4682B4),
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              userdata["disease"].toString(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontFamily: "Avenir LT Std",
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              "Condition",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: "Avenir LT Std",
                                color: Color(0xFFB8B8B8),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              year,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontFamily: "Avenir LT Std",
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              "Year of diagnosis",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: "Avenir LT Std",
                                color: Color(0xFFB8B8B8),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              "Crohn's and Colitis Society",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: "Avenir LT Std",
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              "Support Group",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: "Avenir LT Std",
                                color: Color(0xFFB8B8B8),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              userdata["hospital"].toString(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontFamily: "Avenir LT Std",
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              "Hospital",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: "Avenir LT Std",
                                color: Color(0xFFB8B8B8),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              userdata["medications"].toString(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontFamily: "Avenir LT Std",
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              "Medications",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: "Avenir LT Std",
                                color: Color(0xFFB8B8B8),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              userdata["physician"].toString(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontFamily: "Avenir LT Std",
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              "Doctor",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: "Avenir LT Std",
                                color: Color(0xFFB8B8B8),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class Topbar extends StatelessWidget {
  const Topbar({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF2F9FF),
      child: Column(
        children: [
          SizedBox(
            height: size.height * 0.04,
          ),
          Container(
            height: size.height * 0.1,
            width: size.width,
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: SizedBox(
                    width: size.width * 0.02,
                  ),
                ),
                Flexible(
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Color(0xFF4682B4),
                    ),
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => const HomeFeedPage()),
                          (Route<dynamic> route) => false);
                    },
                  ),
                ),
                Flexible(
                  child: SizedBox(
                    width: size.width * 0.02,
                  ),
                ),
                const Text("USER PROFILE",
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF4682B4),
                      fontFamily: "Avenir LT Std",
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
