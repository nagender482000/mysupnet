import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mysupnet/Apicalls/logout.dart';
import 'package:mysupnet/profile/profile.dart';
import 'package:mysupnet/splashscreen/soon.dart';
import 'package:url_launcher/url_launcher.dart';

class NavigationDrawerWidget extends StatefulWidget {
  final String userEmail;
  final Widget userImg;
  final String userName;
  const NavigationDrawerWidget(
      {Key? key,
      required this.userEmail,
      required this.userImg,
      required this.userName})
      : super(key: key);

  @override
  State<NavigationDrawerWidget> createState() => _NavigationDrawerWidgetState();
}

class _NavigationDrawerWidgetState extends State<NavigationDrawerWidget> {
  final padding = const EdgeInsets.symmetric(horizontal: 10);
  bool isloading = true;
  bool viewVisible = true;
  LinkedHashMap<String, dynamic> userdata = LinkedHashMap();

  int likecount = 0;
  int commentscount = 0;
  _sendMail() async {
    // Android and iOS
    const uri = 'mailto:mkpsg@mysupnet.org?subject=Help&body=I%20need%20help!';
    if (await canLaunchUrl(Uri.parse(uri))) {
      await launchUrl(Uri.parse(uri));
    } else {
      throw 'Could not launch $uri';
    }
  }

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String name = widget.userName;
    String email = widget.userEmail;

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
                      name: name,
                      email: email,
                      onClicked: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const ProfileScreen()));
                      }),
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
                          onClicked: () {
                            Navigator.of(context).pop();

                            selectedItem(context, 0);
                          },
                        ),
                        const SizedBox(height: 16),
                        buildMenuItem(
                          text: 'RESOURCES',
                          licon: Icons.support,
                          onClicked: () {
                            Navigator.of(context).pop();

                            selectedItem(context, 1);
                          },
                        ),
                        const SizedBox(height: 16),
                        buildMenuItem(
                          text: 'TECH HELP',
                          licon: Icons.question_answer,
                          onClicked: () {
                            Navigator.of(context).pop();

                            selectedItem(context, 2);
                          },
                        ),
                        const SizedBox(height: 16),
                        buildMenuItem(
                          text: 'MYSUPNET.ORG',
                          licon: Icons.info,
                          onClicked: () {
                            Navigator.of(context).pop();

                            selectedItem(context, 3);
                          },
                        ),
                        const SizedBox(height: 16),
                        buildMenuItem(
                          text: 'LOGOUT',
                          licon: Icons.logout,
                          onClicked: () {
                            Navigator.of(context).pop();

                            selectedItem(context, 4);
                          },
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
              Flexible(child: widget.userImg),
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
