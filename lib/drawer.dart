import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mysupnet/Apicalls/logout.dart';
import 'package:mysupnet/profile/profile.dart';
import 'package:mysupnet/splashscreen/soon.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class NavigationDrawerWidget extends StatefulWidget {
  const NavigationDrawerWidget({Key? key}) : super(key: key);

  @override
  State<NavigationDrawerWidget> createState() => _NavigationDrawerWidgetState();
}

class _NavigationDrawerWidgetState extends State<NavigationDrawerWidget> {
  final padding = const EdgeInsets.symmetric(horizontal: 10);
  bool isloading = true;
  bool viewVisible = true;
  LinkedHashMap<String, dynamic> userdata = LinkedHashMap();
  String uname = "";
  int likecount = 0;
  int commentscount = 0;
  _sendMail() async {
    // Android and iOS
    const uri = 'mailto:mkpsg@mysupnet.org?subject=Help&body=I%20need%20help!';
    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      throw 'Could not launch $uri';
    }
  }

  profile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    uname = prefs.getString('name').toString();
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // String token = prefs.getString('token').toString();

    // var headers = {'Authorization': 'Bearer ' + token.toString()};
    // var request = http.MultipartRequest(
    //     'GET', Uri.parse('https://apis.mysupnet.org/api/v1/user'));

    // request.headers.addAll(headers);

    // http.StreamedResponse response = await request.send();
    // var responsed = await http.Response.fromStream(response);
    // final responseData = json.decode(responsed.body);

    // if (response.statusCode == 200) {
    //   userdata = responseData["data"];
    // } else {
    //   return responseData["detail"];
    // }
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
      isloading = true;
    });
    await profile();
    setState(() {
      isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    String name = uname;
    const email = "Crohn's 1y";
    const urlImage = 'assets/images/user.png';
    Size size = MediaQuery.of(context).size;
    return Drawer(
      child: SingleChildScrollView(
        child: Container(
          height: size.height,
          color: const Color(0xFF4682B4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: [
                  SizedBox(
                    height: size.height * 0.05,
                  ),
                  buildHeader(
                    urlImage: urlImage,
                    name: name,
                    email: email,
                    onClicked: () => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => const ProfileScreen())),
                  ),
                  SizedBox(
                    height: size.height * 0.05,
                  ),
                  Container(
                    padding: padding,
                    child: Column(
                      children: [
                        buildMenuItem(
                          text: 'SETTINGS',
                          licon: Icons.settings,
                          onClicked: () => selectedItem(context, 0),
                        ),
                        const SizedBox(height: 16),
                        buildMenuItem(
                          text: 'DISEASE RESOURCES',
                          licon: Icons.support,
                          onClicked: () => selectedItem(context, 1),
                        ),
                        const SizedBox(height: 16),
                        buildMenuItem(
                          text: 'TECH HELP',
                          licon: Icons.question_answer,
                          onClicked: () => selectedItem(context, 2),
                        ),
                        const SizedBox(height: 16),
                        buildMenuItem(
                          text: 'MYSUPNET.ORG',
                          licon: Icons.info,
                          onClicked: () => selectedItem(context, 3),
                        ),
                        const SizedBox(height: 16),
                        buildMenuItem(
                          text: 'LOGOUT',
                          licon: Icons.logout,
                          onClicked: () => selectedItem(context, 4),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                  height: 60, child: Image.asset("assets/images/logo.png")),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildHeader({
    String? urlImage,
    String? name,
    String? email,
    VoidCallback? onClicked,
  }) =>
      InkWell(
        onTap: onClicked,
        child: Container(
          padding: padding.add(const EdgeInsets.symmetric(vertical: 20)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const SizedBox(
                height: 12,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    name!,
                    style: const TextStyle(
                        fontFamily: "Avenir LT Std",
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    email!,
                    style: const TextStyle(
                      fontFamily: "Avenir LT Std",
                      fontSize: 10,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 20),
              CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.transparent,
                  backgroundImage: AssetImage(urlImage!)),
            ],
          ),
        ),
      );

  Widget buildMenuItem({
    String? text,
    IconData? licon,
    VoidCallback? onClicked,
  }) {
    const hoverColor = Colors.black87;

    return ListTile(
      trailing: Icon(
        licon,
        color: Colors.white,
      ),
      title: Text(text!,
          textAlign: TextAlign.right,
          style: const TextStyle(
            fontFamily: "Avenir LT Std",
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          )),
      hoverColor: hoverColor,
      onTap: onClicked,
    );
  }

  void selectedItem(BuildContext context, int index) {
    Navigator.of(context).pop();

    switch (index) {
      case 0:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const DisplayPage(),
        ));
        break;
      case 1:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const DisplayPage(),
        ));
        break;
      case 2:
        _sendMail();
        // Navigator.of(context).pushReplacement(MaterialPageRoute(
        //   builder: (context) => const ProfileScreen(),
        // ));
        break;
      case 3:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const DisplayPage(),
        ));
        break;
      case 4:
        logout(context);
        break;
    }
  }
}
