import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mysupnet/Apicalls/addpost.dart';
import 'package:mysupnet/drawer.dart';
import 'package:mysupnet/home/feed/HomeFeed.dart';

class AddNewPost extends StatefulWidget {
  final Widget img;
  const AddNewPost({Key? key, required this.img}) : super(key: key);

  @override
  _AddNewPostState createState() => _AddNewPostState();
}

class _AddNewPostState extends State<AddNewPost> {
  final postController = TextEditingController();

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    super.initState();
  }

  @override
  void dispose() {
    postController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        endDrawer: const NavigationDrawerWidget(),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Topbar(size: size),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: SizedBox(
                    width: size.width,
                    height: size.height * 0.7,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Padding(
                            padding:
                                const EdgeInsets.only(top: 12.0, right: 10),
                            child: widget.img,
                          ),
                        ),
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.only(top: 0),
                            alignment: Alignment.center,
                            child: TextFormField(
                              maxLines: 32,
                              style: const TextStyle(
                                fontFamily: "Avenir LT Std",
                                color: Color(0xFF000000),
                                fontSize: 16,
                              ),
                              decoration: const InputDecoration(
                                hintText: "|What's on your mind?",
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 5,
                                ),
                                border: InputBorder.none,
                              ),
                              autofocus: false,
                              controller: postController,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: InkWell(
                    onTap: () async {
                      showDialog(
                          barrierColor: const Color(0xaaFFFFFF),
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return WillPopScope(
                              onWillPop: () async => false,
                              child: SizedBox(
                                height: 40,
                                width: 40,
                                child: Transform.scale(
                                  scale: 0.05,
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 50,
                                  ),
                                ),
                              ),
                            );
                          });
                      await addpost(context, postController.text);
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
                        'SHARE',
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
              ]),
        ));
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
        mainAxisSize: MainAxisSize.min,
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
                const Text("ADD NEW POST",
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
