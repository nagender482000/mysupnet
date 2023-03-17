import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mysupnet/Apicalls/addpost.dart';
import 'package:mysupnet/Apicalls/editpost.dart';
import 'package:mysupnet/home/feed/HomeFeed.dart';

class AddNewPost extends StatefulWidget {
  final Widget img;
  final String name;
  final String email;
  final String? ptext;
  bool isEditPost;
  final String? id;
  AddNewPost(
      {Key? key,
      required this.img,
      required this.name,
      required this.email,
      required this.isEditPost,
      this.id,
      this.ptext})
      : super(key: key);

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
    if (widget.isEditPost) {
      postController.text = widget.ptext.toString();
    }
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
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Topbar(size: size, isEditPost: widget.isEditPost),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    children: [
                      SizedBox(
                        width: size.width * 0.9,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 10.0, right: 5),
                              child: widget.img,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(widget.name,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        color: Color(0xFF4682B4),
                                        fontFamily: "Avenir LT Std",
                                      )),
                                  // const SizedBox(
                                  //   height: 2,
                                  // ),
                                  // Text(widget.email,
                                  //     style: const TextStyle(
                                  //       fontSize: 10,
                                  //       color: Colors.black,
                                  //       fontFamily: "Avenir LT Std",
                                  //     )),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
                  alignment: Alignment.center,
                  child: TextFormField(
                    keyboardType: TextInputType.multiline,
                    maxLength: 250,
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
                      isDense: true,
                    ),
                    autofocus: false,
                    controller: postController,
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
                      widget.isEditPost
                          ? await editpost(context, widget.id.toString(),
                              postController.text)
                          : await addpost(context, postController.text.trim());
                    },
                    child: Container(
                      width: size.width,
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
                      child: Text(
                        widget.isEditPost ? "SAVE" : 'SHARE',
                        style: const TextStyle(
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
    required this.isEditPost,
  }) : super(key: key);

  final Size size;
  final bool isEditPost;

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
                Text(isEditPost ? "EDIT POST" : "ADD NEW POST",
                    style: const TextStyle(
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
