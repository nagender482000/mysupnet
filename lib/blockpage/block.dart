// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:mysupnet/Apicalls/logout.dart';
import 'package:mysupnet/auth/login.dart';
import 'package:mysupnet/fadetransition.dart';
import 'package:mysupnet/home/feed.dart';

class BlockPage extends StatefulWidget {
  const BlockPage({Key? key}) : super(key: key);

  @override
  _BlockPageState createState() => _BlockPageState();
}

class _BlockPageState extends State<BlockPage> {
  final searchController = TextEditingController();

  void onTabTapped(int index) {
    setState(() {});
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      // appBar: PreferredSize(
      //   preferredSize: const Size.fromHeight(20.0),
      //   child: AppBar(
      //     backgroundColor: Colors.white,
      //     bottomOpacity: 0.0,
      //     elevation: 0.0,
      //   ),
      // ),
      backgroundColor: Colors.white,
      body: Center(
        child: SizedBox(
          height: size.height,
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Topbar(size: size, searchController: searchController),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: size.width * 0.8,
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: SizedBox(
                              height: size.height * 0.3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text(
                                    'This feature will be available once your Support Group approves your membership.\n ',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: "Avenir LT Std",
                                      color: Color(0xFF4078A6),
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    "You will be able to access APP features once the support group approves your membership",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: "Avenir LT Std",
                                      color: Color(0xFF4078A6),
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Center(
                            child: SizedBox(
                              height: size.height * 0.2,
                              child: Image.asset("assets/images/logo.png"),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                    Navigator.of(context).push(
                                        CustomPageRoute(const HomeFeedPage()));
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 13),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(4)),
                                        boxShadow: <BoxShadow>[
                                          BoxShadow(
                                              color: const Color(0xffB8B8B8)
                                                  .withAlpha(100),
                                              offset: const Offset(0, 4),
                                              blurRadius: 8,
                                              spreadRadius: 2)
                                        ],
                                        color: const Color(0xFF71B48D)),
                                    child: const Text(
                                      'CONTACT SUPPORT',
                                      style: TextStyle(
                                        fontFamily: "Avenir LT Std",
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: size.height * 0.03),
                                InkWell(
                                  onTap: () async {
                                    logout(context);
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 13),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(4)),
                                        boxShadow: <BoxShadow>[
                                          BoxShadow(
                                              color: const Color(0xffB8B8B8)
                                                  .withAlpha(100),
                                              offset: const Offset(0, 4),
                                              blurRadius: 8,
                                              spreadRadius: 2)
                                        ],
                                        color: Colors.white),
                                    child: const Text(
                                      'LOG OUT',
                                      style: TextStyle(
                                        fontFamily: "Avenir LT Std",
                                        color: Color(0xFF71B48D),
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
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
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: [
          BottomNavigationBarItem(
            icon: GestureDetector(
              onTap: () {},
              child: const Image(
                image: AssetImage("assets/images/feed.png"),
                color: null,
              ),
            ),
            backgroundColor: null,
            label: "FEED",
          ),
          BottomNavigationBarItem(
            icon: GestureDetector(
              child: const Image(
                image: AssetImage("assets/images/inactivechat.png"),
                color: null,
              ),
            ),
            label: "MENTORS",
          ),
          BottomNavigationBarItem(
            icon: GestureDetector(
              child: const Image(
                image: AssetImage("assets/images/inactivenew.png"),
                color: null,
              ),
            ),
            label: "WHAT'S NEW",
          ),
        ],
      ),
    );
  }
}

class Topbar extends StatelessWidget {
  const Topbar({
    Key? key,
    required this.size,
    required this.searchController,
  }) : super(key: key);

  final Size size;
  final TextEditingController searchController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Container(
        color: const Color(0xFFF2F9FF),
        child: Container(
          height: size.height * 0.12,
          width: size.width,
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Color(0xFF4682B4),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()),
                        (Route<dynamic> route) => false);
                  },
                ),
              ),
              Flexible(
                child: TextFormField(
                  style: const TextStyle(
                    fontFamily: "Avenir LT Std",
                    color: Color(0xFF4682B4),
                    fontSize: 20,
                  ),
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.only(top: 10),
                    labelText: "Search",
                    labelStyle: TextStyle(
                      fontFamily: "Avenir LT Std",
                      color: Color(0xFF4682B4),
                      fontSize: 16,
                      height: 0.5,
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  controller: searchController,
                  validator: (value) {
                    if (value == null) {
                      return 'Please Enter a value.';
                    }
                    return null;
                  },
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Image.asset(
                  "assets/images/addec5a8-1f71-4772-96f0-843755aaaed1.png",
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Image.asset(
                  "assets/images/53e933ab-b850-43e3-990f-61d635d4ac34.png",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
