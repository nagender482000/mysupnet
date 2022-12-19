// ignore_for_file: deprecated_member_use

import 'dart:convert';

import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mysupnet/Apicalls/bookmark.dart';
import 'package:mysupnet/Apicalls/deletepost.dart';
import 'package:mysupnet/Apicalls/flag.dart';
import 'package:mysupnet/Apicalls/likeapi.dart';
import 'package:mysupnet/Apicalls/unbookmark.dart';
import 'package:mysupnet/Apicalls/unlikeapi.dart';
import 'package:mysupnet/drawer.dart';
import 'package:mysupnet/global.dart';
import 'package:mysupnet/home/comments.dart';
import 'package:mysupnet/home/editpostpage.dart';
import 'package:mysupnet/home/newpost.dart';
import 'package:http/http.dart' as http;
import 'package:mysupnet/home/user.dart';
import 'package:mysupnet/splashscreen/soon.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeFeedPage extends StatefulWidget {
  const HomeFeedPage({Key? key}) : super(key: key);

  @override
  _HomeFeedPageState createState() => _HomeFeedPageState();
}

class _HomeFeedPageState extends State<HomeFeedPage> {
  final searchController = TextEditingController();
  final commentController = TextEditingController();
  bool isloading = true;
  List postdata = [];
  String cval = "drop.png";
  String fval = "drop.png";
  Widget img = CircleAvatar(
      backgroundImage: AssetImage(
    "assets/images/user.png",
  ));

  List<String> clist = ["drop.png", "edit.jpg", "delete.jpg"];
  List<String> flist = ["drop.png", "flag.jpg"];

  List<dynamic> commentdata = [];
  String name = "";
  Map<dynamic, dynamic> postdatamap = {};

  //int bookmarkbuttonclick = 0;
  void showWidget(String id) {
    setState(() {
      postdatamap[id]["isvisible"] = true;
    });
  }

  void hideWidget(String id) async {
    setState(() {
      postdatamap[id]["isvisible"] = false;
    });
    await postlist();
  }

  postlist() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token').toString();
    name = prefs.getString('name').toString();
    var headers = {
      'Authorization': 'Bearer ' + token.toString(),
    };
    var request = http.MultipartRequest(
        'GET', Uri.parse('https://apis.mysupnet.org/api/v1/post/all'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    var responsed = await http.Response.fromStream(response);
    final responseData = json.decode(responsed.body);
    print(responseData);
    if (response.statusCode == 200) {
      postdata = responseData["data"];

      for (int i = 0; i < postdata.length; i++) {
        int likes = postdata[i]["likes"];
        int comments = postdata[i]["comments"].length;

        postdatamap[postdata[i]["uuid"].toString()] = {
          "postvis": true,
          "isliked": postdata[i]["current_user_has_liked"],
          "lclickcount": postdata[i]["current_user_has_liked"] ? 1 : 0,
          "bclickcount": postdata[i]["current_user_has_bookmarked"] ? 1 : 0,
          "isbookmarked": postdata[i]["current_user_has_bookmarked"],
          "isvisible": false,
          "likecount": likes,
          "commentscount": comments,
          "editvisible": false,
          "imgvisible": true,
          "user_email": postdata[i]["user_email"].toString()
        };
        postdata[i]["photo"] != null
            ? postdatamap[postdata[i]["uuid"].toString()]["photo"] =
                CircleAvatar(
                    radius: 25,
                    backgroundImage:
                        NetworkImage(baseurl + postdata[i]["photo"].toString()))
            : postdatamap[postdata[i]["uuid"].toString()]["photo"] =
                CircleAvatar(
                    radius: 25,
                    backgroundImage: AssetImage(
                      "assets/images/user.png",
                    ));
        //postdatamap[[postdata[i]["uuid"].toString()].toString()] = {};
      }
    } else {
      return responseData["detail"];
    }
  }

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    getpost();
    super.initState();
  }

  getpost() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String uimg = prefs.getString('img').toString();
    print(uimg);
    uimg != "null"
        ? img = CircleAvatar(
            radius: 25, backgroundImage: NetworkImage(baseurl + uimg))
        : img = CircleAvatar(
            radius: 25,
            backgroundImage: AssetImage(
              "assets/images/user.png",
            ));
    setState(() {
      isloading = true;
    });
    await postlist();
    setState(() {
      isloading = false;
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void like(String id) async {
    await likeapi(context, id, "post");

    setState(() {
      postdatamap[id]["likecount"] = postdatamap[id]["likecount"] + 1;

      postdatamap[id]["isliked"] = true;
    });
  }

  void unlike(String id) async {
    await unlikeapi(context, id);

    setState(() {
      postdatamap[id]["isliked"] = false;
      postdatamap[id]["likecount"] = postdatamap[id]["likecount"] - 1;
    });
  }

  void bookmark(String id) async {
    await bookmarkapi(context, id);
    setState(() {
      postdatamap[id]["isbookmarked"] = true;
    });
  }

  void unbookmark(String id) async {
    await unbookmarkapi(context, id);
    setState(() {
      postdatamap[id]["isbookmarked"] = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      endDrawer: const NavigationDrawerWidget(),
      backgroundColor: Colors.white,
      body: SizedBox(
        height: size.height * 1.2,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Topbar(size: size, searchController: searchController),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: size.width,
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => AddNewPost(
                              img: img,
                            ),
                          ));
                        },
                        child: SizedBox(
                          width: size.width,
                          height: size.height * 0.1,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              img,
                              const SizedBox(
                                width: 20,
                              ),
                              Container(
                                width: size.width * 0.7,
                                alignment: Alignment.center,
                                child: TextFormField(
                                  enabled: false,
                                  maxLines: 1,
                                  style: const TextStyle(
                                      fontFamily: "Avenir LT Std",
                                      color: Color(0xFF000000),
                                      fontSize: 14),
                                  decoration: const InputDecoration(
                                    hintText: " |What's on your mind?",
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 5,
                                      horizontal: 10,
                                    ),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20.0))),
                                  ),
                                  autofocus: false,
                                  controller: searchController,
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                      RefreshIndicator(
                        onRefresh: () {
                          return getpost();
                        },
                        child: SizedBox(
                          height: size.height * .65,
                          child: ListView.separated(
                            shrinkWrap: true,
                            physics: const ScrollPhysics(),
                            padding: EdgeInsets.zero,
                            itemCount: postdata.length,
                            separatorBuilder: (context, index) {
                              return const Divider(
                                thickness: 10,
                                height: 10,
                                color: Color(0xFFF6F6F6),
                              );
                            },
                            itemBuilder: (context, index) {
                              String id = postdata[index]["uuid"].toString();
                              String psname =
                                  postdata[index]["user_name"].toString();
                              return Card(
                                  elevation: 0,
                                  child: Column(children: [
                                    Stack(children: [
                                      post(
                                          size,
                                          psname,
                                          postdata[index]["text"].toString(),
                                          postdatamap[id]["commentscount"],
                                          postdatamap[id]["likecount"],
                                          index,
                                          TimeAgo.timeAgoSinceDate(
                                              DateTime.parse(postdata[index]
                                                      ["created"])
                                                  .toString()),
                                          postdata[index]["user_condition"]
                                              .toString(),
                                          postdata[index]["uuid"].toString(),
                                          postdata[index]["current_user_post"],
                                          postdatamap[id]["user_email"],
                                          postdatamap[id]["photo"]),
                                    ])
                                  ]));
                            },
                          ),
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: [
          BottomNavigationBarItem(
            icon: GestureDetector(
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const HomeFeedPage(),
                ));
              },
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
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const DisplayPage(),
                ));
              },
              child: const Image(
                image: AssetImage("assets/images/inactivechat.png"),
                color: null,
              ),
            ),
            label: "MENTORS",
          ),
          BottomNavigationBarItem(
            icon: GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const DisplayPage(),
                ));
              },
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

  Widget post(
      Size size,
      String name,
      String posttext,
      int commentscount,
      int likecount,
      index,
      creattime,
      cond,
      id,
      bool current,
      String email,
      photo) {
    commentdata.add(postdata[index]["comments"]);

    return Center(
      child: Visibility(
        visible: postdatamap[id]["postvis"],
        maintainSize: false,
        child: SizedBox(
          width: size.width * 0.95,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => UserProfileScreen(
                                email: email,
                              )));
                    },
                    child: CircleAvatar(
                      radius: 20,
                      child: photo,
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => UserProfileScreen(
                                    email: email,
                                  )));
                        },
                        child: Text(
                          name,
                          style: const TextStyle(
                            fontFamily: "Avenir LT Std",
                            color: Color(0xFF4078A6),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            cond,
                            style: const TextStyle(
                              fontFamily: "Avenir LT Std",
                              color: Colors.black,
                              fontSize: 10,
                            ),
                          ),
                          const Text(
                            "• ",
                            style: TextStyle(
                              fontFamily: "Avenir LT Std",
                              color: Colors.black,
                              fontSize: 10,
                            ),
                          ),
                          Text(
                            creattime,
                            style: const TextStyle(
                              fontFamily: "Avenir LT Std",
                              color: Colors.black,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Spacer(),
                  !current
                      ? SizedBox(
                          width: size.width * 0.3,
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                              dropdownColor: Colors.white,
                              alignment: Alignment.centerRight,
                              iconSize: 0.0,
                              isExpanded: true,
                              value: fval,
                              elevation: 1,
                              borderRadius: BorderRadius.circular(10),
                              onChanged: (value) async {
                                if (value == "flag.jpg") {
                                  await flag(context, id, "post");
                                }
                              },
                              items: flist.map((value) {
                                return DropdownMenuItem(
                                  alignment: Alignment.centerRight,
                                  value: value,

                                  child: Image.asset("assets/images/" + value,
                                      height: 20, fit: BoxFit.contain),

                                  // Text(
                                  //   value,
                                  //   textAlign: TextAlign.end,
                                  //   style: const TextStyle(
                                  //     fontFamily: "Avenir LT Std",
                                  //     color: Color(0xFF000000),
                                  //     fontSize: 18,
                                  //   ),
                                  // ),
                                );
                              }).toList(),
                            ),
                          ),
                        )
                      : SizedBox(
                          width: size.width * 0.15,
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                              elevation: 1,
                              borderRadius: BorderRadius.circular(10),
                              dropdownColor: Colors.white,
                              iconSize: 0.0,
                              isExpanded: true,
                              value: cval,
                              onChanged: (value) async {
                                if (value == "edit.jpg") {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => EditPostPage(
                                            ptext: posttext.toString(),
                                            id: id,
                                          )));
                                }
                                if (value == "delete.jpg") {
                                  await delpost(context, id);
                                  setState(() {
                                    postdatamap[id]["postvis"] = false;
                                  });
                                }
                              },
                              items: clist.map((value) {
                                return DropdownMenuItem(
                                  alignment: Alignment.centerRight,
                                  value: value,
                                  child: Image.asset(
                                    "assets/images/" + value,
                                    height: 20,
                                  ),
                                  // Text(
                                  //   value,
                                  //   textAlign: TextAlign.end,
                                  //   style: const TextStyle(
                                  //     fontFamily: "Avenir LT Std",
                                  //     color: Color(0xFF000000),
                                  //     fontSize: 18,
                                  //   ),
                                  // ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                  // GestureDetector(
                  //   onTap: () async {},
                  //   child: postdatamap[id]["imgvisible"]
                  //       ? GestureDetector(
                  //           onTap: () {
                  //             setState(() {
                  //               postdatamap[id]["editvisible"] = true;
                  //               postdatamap[id]["imgvisible"] = false;
                  //             });
                  //           },
                  //           child: Visibility(
                  //             maintainSize: false,
                  //             maintainAnimation: true,
                  //             maintainState: true,
                  //             visible: postdatamap[id]["imgvisible"],
                  //             child: SizedBox(
                  //                 height: size.height * 0.02,
                  //                 child: Image.asset("assets/images/edit.png",
                  //                     fit: BoxFit.contain)),
                  //           ),
                  //         )
                  //       : !current
                  //           ? Visibility(
                  //               maintainSize: false,
                  //               maintainAnimation: true,
                  //               maintainState: true,
                  //               visible: postdatamap[id]["editvisible"],
                  //               child: Container(
                  //                 transformAlignment: Alignment.center,
                  //                 decoration: BoxDecoration(
                  //                     border: Border.all(width: 0.2),
                  //                     borderRadius: BorderRadius.circular(5)),
                  //                 // height: size.height * 0.08,
                  //                 width: size.width * .15,
                  //                 child: Column(
                  //                   children: [
                  //                     GestureDetector(
                  //                       onTap: () async {
                  //                         await flag(context, id, "post");
                  //                         setState(() {
                  //                           postdatamap[id]["editvisible"] =
                  //                               false;
                  //                           postdatamap[id]["imgvisible"] =
                  //                               true;
                  //                         });
                  //                       },
                  //                       child: SizedBox(
                  //                           height: size.height * 0.02,
                  //                           child: Row(
                  //                             children: const [
                  //                               Icon(
                  //                                 Icons.flag,
                  //                                 color: Colors.blue,
                  //                                 size: 15,
                  //                               ),
                  //                               SizedBox(
                  //                                 width: 5,
                  //                               ),
                  //                               Text(
                  //                                 "Flag",
                  //                                 style: TextStyle(
                  //                                     fontSize: 10,
                  //                                     color: Colors.blue),
                  //                               ),
                  //                             ],
                  //                           )),
                  //                     ),
                  //                     const Divider(
                  //                       thickness: 1,
                  //                       height: 2,
                  //                     ),
                  //                     GestureDetector(
                  //                       onTap: () {
                  //                         setState(() {
                  //                           postdatamap[id]["editvisible"] =
                  //                               false;
                  //                           postdatamap[id]["imgvisible"] =
                  //                               true;
                  //                         });
                  //                       },
                  //                       child: SizedBox(
                  //                           height: size.height * 0.02,
                  //                           child: Row(
                  //                             children: const [
                  //                               Icon(
                  //                                 Icons.close,
                  //                                 color: Colors.red,
                  //                                 size: 15,
                  //                               ),
                  //                               SizedBox(
                  //                                 width: 5,
                  //                               ),
                  //                               Text(
                  //                                 "Close",
                  //                                 style: TextStyle(
                  //                                     fontSize: 10,
                  //                                     color: Colors.red),
                  //                               ),
                  //                             ],
                  //                           )),
                  //                     ),
                  //                   ],
                  //                 ),
                  //               ),
                  //             )
                  //           : Visibility(
                  //               maintainSize: false,
                  //               maintainAnimation: true,
                  //               maintainState: true,
                  //               visible: postdatamap[id]["editvisible"],
                  //               child: Container(
                  //                 transformAlignment: Alignment.center,
                  //                 decoration: BoxDecoration(
                  //                     border: Border.all(width: 0.2),
                  //                     borderRadius: BorderRadius.circular(5)),
                  //                 // height: size.height * 0.08,
                  //                 width: size.width * .15,
                  //                 child: Column(
                  //                   children: [
                  //                     GestureDetector(
                  //                       onTap: () {
                  //                         Navigator.of(context).push(
                  //                             MaterialPageRoute(
                  //                                 builder: (context) =>
                  //                                     EditPostPage(
                  //                                       ptext:
                  //                                           posttext.toString(),
                  //                                       id: id,
                  //                                     )));
                  //                         setState(() {
                  //                           postdatamap[id]["editvisible"] =
                  //                               false;
                  //                           postdatamap[id]["imgvisible"] =
                  //                               true;
                  //                         });
                  //                       },
                  //                       child: SizedBox(
                  //                           height: size.height * 0.02,
                  //                           child: Row(
                  //                             children: const [
                  //                               Icon(
                  //                                 Icons.edit,
                  //                                 color: Colors.blue,
                  //                                 size: 15,
                  //                               ),
                  //                               SizedBox(
                  //                                 width: 5,
                  //                               ),
                  //                               Text(
                  //                                 "Edit",
                  //                                 style: TextStyle(
                  //                                     fontSize: 10,
                  //                                     color: Colors.blue),
                  //                               ),
                  //                             ],
                  //                           )),
                  //                     ),
                  //                     const Divider(
                  //                       thickness: 1,
                  //                       height: 2,
                  //                     ),
                  //                     GestureDetector(
                  //                       onTap: () async {
                  //                         await delpost(context, id);
                  //                         setState(() {
                  //                           postdatamap[id]["postvis"] = false;
                  //                           postdatamap[id]["editvisible"] =
                  //                               false;
                  //                           postdatamap[id]["imgvisible"] =
                  //                               true;
                  //                         });
                  //                       },
                  //                       child: SizedBox(
                  //                           height: size.height * 0.02,
                  //                           child: Row(
                  //                             children: const [
                  //                               Icon(
                  //                                 Icons.delete,
                  //                                 color: Colors.blue,
                  //                                 size: 15,
                  //                               ),
                  //                               SizedBox(
                  //                                 width: 5,
                  //                               ),
                  //                               Text(
                  //                                 "Delete",
                  //                                 style: TextStyle(
                  //                                     fontSize: 10,
                  //                                     color: Colors.blue),
                  //                               ),
                  //                             ],
                  //                           )),
                  //                     ),
                  //                     const Divider(
                  //                       thickness: 1,
                  //                       height: 2,
                  //                     ),
                  //                     GestureDetector(
                  //                       onTap: () {
                  //                         setState(() {
                  //                           postdatamap[id]["editvisible"] =
                  //                               false;
                  //                           postdatamap[id]["imgvisible"] =
                  //                               true;
                  //                         });
                  //                       },
                  //                       child: SizedBox(
                  //                           height: size.height * 0.02,
                  //                           child: Row(
                  //                             children: const [
                  //                               Icon(
                  //                                 Icons.close,
                  //                                 color: Colors.red,
                  //                                 size: 15,
                  //                               ),
                  //                               SizedBox(
                  //                                 width: 5,
                  //                               ),
                  //                               Text(
                  //                                 "Close",
                  //                                 style: TextStyle(
                  //                                     fontSize: 10,
                  //                                     color: Colors.red),
                  //                               ),
                  //                             ],
                  //                           )),
                  //                     ),
                  //                   ],
                  //                 ),
                  //               ),
                  //             ),
                  // ),
                  const SizedBox(
                    width: 20,
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                posttext,
                style: const TextStyle(
                  fontFamily: "Avenir LT Std",
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          bottomLeft: Radius.circular(20.0)),
                      color: Color(0xFFF6F6F6),
                    ),
                    height: size.height * 0.04,
                    width: size.width * 0.15,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (!current) {
                              if (!postdatamap[id]["isliked"]) {
                                if (postdatamap[id]["lclickcount"] % 2 == 0) {
                                  like(id);
                                }
                              }

                              if (postdatamap[id]["lclickcount"] % 2 == 1) {
                                unlike(id);
                              }
                              postdatamap[id]["lclickcount"] =
                                  postdatamap[id]["lclickcount"] + 1;
                            }
                          },
                          child: postdatamap[id]["isliked"]
                              ? const Icon(Icons.favorite, color: Colors.green)
                              : const Icon(
                                  Icons.favorite_outline,
                                  color: Colors.green,
                                ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 1,
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFFF6F6F6),
                    ),
                    height: size.height * 0.04,
                    width: size.width * 0.25,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          likecount.toString() + " likes",
                          style: const TextStyle(
                            fontFamily: "Avenir LT Std",
                            color: Color(0xFF4078A6),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 1,
                  ),
                  GestureDetector(
                    onTap: () {
                      if (postdatamap[id]["isvisible"]) {
                        hideWidget(id);
                      } else {
                        showWidget(id);
                      }
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20.0),
                            bottomRight: Radius.circular(20.0)),
                        color: Color(0xFFF6F6F6),
                      ),
                      height: size.height * 0.04,
                      width: size.width * 0.4,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            commentscount.toString() + " comments",
                            style: const TextStyle(
                              fontFamily: "Avenir LT Std",
                              color: Color(0xFF4078A6),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      if (postdatamap[id]["bclickcount"] % 2 == 0) {
                        bookmark(id);
                      } else {
                        unbookmark(id);
                      }
                      postdatamap[id]["bclickcount"] =
                          postdatamap[id]["bclickcount"] + 1;
                    },
                    child: postdatamap[id]["isbookmarked"]
                        ? const Icon(Icons.bookmark, color: Colors.green)
                        : const Icon(
                            Icons.bookmark_border_outlined,
                            color: Colors.green,
                          ),
                  ),
                ],
              ),
              Visibility(
                maintainSize: false,
                maintainAnimation: true,
                maintainState: true,
                visible: postdatamap[id]["isvisible"],
                child: Column(
                  children: [
                    CommentsSec(id, index, postdata, postdatamap, commentdata,
                        postdatamap[id]["postvis"]),
                  ],
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
    required this.searchController,
  }) : super(key: key);

  final Size size;
  final TextEditingController searchController;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF2F9FF),
      child: Column(
        children: [
          SizedBox(
            height: size.height * 0.02,
          ),
          Container(
            height: size.height * 0.12,
            width: size.width,
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Flexible(
                  child: SizedBox(
                    width: 10,
                  ),
                ),
                const Spacer(),
                // GestureDetector(
                //   onTap: () {},
                //   child: Image.asset(
                //     "assets/images/addec5a8-1f71-4772-96f0-843755aaaed1.png",
                //   ),
                // ),
                GestureDetector(
                  onTap: () {
                    Scaffold.of(context).openEndDrawer();
                  },
                  child: Image.asset(
                    "assets/images/53e933ab-b850-43e3-990f-61d635d4ac34.png",
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TimeAgo {
  static String timeAgoSinceDate(String dateString,
      {bool numericDates = true}) {
    DateTime notificationDate =
        DateFormat("yyyy-MM-dd hh:mm:ss").parse(dateString);
    final date2 = DateFormat("yyyy-MM-dd hh:mm:ss")
        .parse(DateTime.now().toUtc().toString());
    final difference = date2.difference(notificationDate);

    if (difference.inDays > 8) {
      return DateFormat("dd-MM-yyyy")
          .format(DateTime.parse(dateString.toString()))
          .toString();
    } else if ((difference.inDays / 7).floor() >= 1) {
      return (numericDates) ? '1 week ago' : 'Last week';
    } else if (difference.inDays >= 2) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays >= 1) {
      return (numericDates) ? '1 day ago' : 'Yesterday';
    } else if (difference.inHours >= 2) {
      return '${difference.inHours} hours ago';
    } else if (difference.inHours >= 1) {
      return (numericDates) ? '1 hour ago' : 'An hour ago';
    } else if (difference.inMinutes >= 2) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inMinutes >= 1) {
      return (numericDates) ? '1 minute ago' : 'A minute ago';
    } else if (difference.inSeconds >= 3) {
      return '${difference.inSeconds} seconds ago';
    } else {
      return 'Just now';
    }
  }
}
