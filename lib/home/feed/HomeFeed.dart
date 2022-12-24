// ignore_for_file: deprecated_member_use

import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:mysupnet/Apicalls/deletepost.dart';
import 'package:mysupnet/Apicalls/flag.dart';

import 'package:mysupnet/drawer.dart';
import 'package:mysupnet/global.dart';
import 'package:mysupnet/home/editpostpage.dart';
import 'package:mysupnet/home/feed/FeedProvider.dart';
import 'package:mysupnet/home/newpost.dart';
import 'package:mysupnet/home/user.dart';
import 'package:mysupnet/splashscreen/soon.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeFeedPage extends StatefulWidget {
  const HomeFeedPage({Key? key}) : super(key: key);

  @override
  _HomeFeedPageState createState() => _HomeFeedPageState();
}

class _HomeFeedPageState extends State<HomeFeedPage> {
  final commentController = TextEditingController();
  bool iscommenting = true;
  String cval = "drop.png";
  String fval = "drop.png";
  Widget img = const CircleAvatar(
      backgroundImage: AssetImage(
    "assets/images/user.png",
  ));
  List<String> clist = ["drop.png", "edit.jpg", "delete.jpg"];
  List<String> flist = ["drop.png", "flag.jpg"];
  String name = "";
  String email = "";
  String uimg = "";
  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    setpost();
    super.initState();
  }

  setpost() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    uimg = prefs.getString('img').toString();
    name = prefs.getString('name').toString();

    email = prefs.getString('email').toString();
    print(uimg);
    uimg != "null"
        ? img = CircleAvatar(
            radius: 25, backgroundImage: NetworkImage(baseurl + uimg))
        : img = const CircleAvatar(
            radius: 25,
            backgroundImage: AssetImage(
              "assets/images/user.png",
            ));
    final feedModel = Provider.of<FeedProvider>(context, listen: false);

    feedModel.getpost();
  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer<FeedProvider>(
      builder: (context, feedModel, _) => Scaffold(
        endDrawer: const NavigationDrawerWidget(),
        backgroundColor: Colors.white,
        body: feedModel.isloading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SizedBox(
                height: size.height * 1.2,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Topbar(size: size),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      img,
                                      const SizedBox(
                                        width: 10,
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
                                              fontSize: 12),
                                          decoration: const InputDecoration(
                                            hintText: " | What's on your mind?",
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                              vertical: 4,
                                              horizontal: 12,
                                            ),
                                            border: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20.0))),
                                          ),
                                          autofocus: false,
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
                                  return setpost();
                                },
                                child: SizedBox(
                                  height: size.height * .65,
                                  child: ListView.separated(
                                    shrinkWrap: true,
                                    physics: const ScrollPhysics(),
                                    padding: EdgeInsets.zero,
                                    itemCount: feedModel.feed!.data.length,
                                    separatorBuilder: (context, index) {
                                      return const Divider(
                                        thickness: 10,
                                        height: 10,
                                        color: Color(0xFFF6F6F6),
                                      );
                                    },
                                    itemBuilder: (context, index) {
                                      return Visibility(
                                          visible: feedModel
                                              .feed!.data[index].isPostVisible,
                                          maintainSize: false,
                                          child: Card(
                                              elevation: 0,
                                              child: Column(children: [
                                                Stack(children: [
                                                  post(
                                                      size,
                                                      index,
                                                      TimeAgo.timeAgoSinceDate(
                                                          DateTime.parse(feedModel
                                                                  .feed!
                                                                  .data[index]
                                                                  .created
                                                                  .toString())
                                                              .toString()),
                                                      feedModel,
                                                      name,
                                                      email,
                                                      uimg),
                                                ])
                                              ])));
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
      ),
    );
  }

  Widget post(Size size, postindex, creattime, FeedProvider feedModel, name,
      email, uimg) {
    Widget pic = CircleAvatar(
        radius: 25,
        backgroundImage: NetworkImage(
            baseurl + feedModel.feed!.data[postindex].photo.toString()));
    feedModel.feed!.data[postindex].photo != "null"
        ? pic = CircleAvatar(
            radius: 25,
            backgroundImage: NetworkImage(
                baseurl + feedModel.feed!.data[postindex].photo.toString()))
        : pic = const CircleAvatar(
            radius: 25,
            backgroundImage: AssetImage(
              "assets/images/user.png",
            ));
    return Center(
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
                            email: feedModel.feed!.data[postindex].userEmail,
                          )));
                },
                child: CircleAvatar(
                  radius: 20,
                  child: pic,
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
                                email:
                                    feedModel.feed!.data[postindex].userEmail,
                              )));
                    },
                    child: Text(
                      feedModel.feed!.data[postindex].userName,
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
                        feedModel.feed!.data[postindex].userCondition,
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
              !feedModel.feed!.data[postindex].currentUserPost
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
                              await flag(context,
                                  feedModel.feed!.data[postindex].uuid, "post");
                            }
                          },
                          items: flist.map((value) {
                            return DropdownMenuItem(
                              alignment: Alignment.centerRight,
                              value: value,
                              child: Image.asset("assets/images/" + value,
                                  height: 20, fit: BoxFit.contain),
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
                                        ptext: feedModel
                                            .feed!.data[postindex].text
                                            .toString(),
                                        id: feedModel
                                            .feed!.data[postindex].uuid,
                                        img: img,
                                      )));
                            }
                            if (value == "delete.jpg") {
                              await delpost(context,
                                  feedModel.feed!.data[postindex].uuid);
                              feedModel.hidePost(
                                postindex,
                              );
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
                            );
                          }).toList(),
                        ),
                      ),
                    ),
              const SizedBox(
                width: 20,
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            feedModel.feed!.data[postindex].text,
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
                        if (!feedModel.feed!.data[postindex].currentUserPost) {
                          if (!feedModel
                              .feed!.data[postindex].currentUserHasLiked) {
                            feedModel.postLike(
                                feedModel.feed!.data[postindex].uuid,
                                postindex);
                          } else {
                            feedModel.postUnlike(
                                feedModel.feed!.data[postindex].uuid,
                                postindex);
                          }
                        }
                      },
                      child: feedModel.feed!.data[postindex].currentUserHasLiked
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
                      feedModel.feed!.data[postindex].likes.toString() +
                          " likes",
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
                  if (feedModel.feed!.data[postindex].isCommentsVisible) {
                    feedModel.hideComments(postindex);
                  } else {
                    feedModel.showComments(
                      postindex,
                    );
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
                        feedModel.feed!.data[postindex].commentCount
                                .toString() +
                            " comments",
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
                  if (!feedModel
                      .feed!.data[postindex].currentUserHasBookmarked) {
                    feedModel.bookmark(
                        feedModel.feed!.data[postindex].uuid, postindex);
                  } else {
                    feedModel.unbookmark(
                        feedModel.feed!.data[postindex].uuid, postindex);
                  }
                },
                child: feedModel.feed!.data[postindex].currentUserHasBookmarked
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
            visible: feedModel.feed!.data[postindex].isCommentsVisible,
            child: Column(
              children: [
                Column(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemCount:
                          feedModel.feed!.data[postindex].comments.length,
                      itemBuilder: (context, index) {
                        if (feedModel
                            .feed!.data[postindex].comments.isNotEmpty) {
                          return Column(children: [
                            comments(
                              size,
                              TimeAgo.timeAgoSinceDate(feedModel
                                  .feed!.data[postindex].comments[index].created
                                  .toString()),
                              postindex,
                              index,
                              feedModel,
                            ),
                          ]);
                        }
                        return SizedBox(
                          width: size.width,
                          height: size.height * 0.1,
                          child: const Text(
                            "There are no Comments to show. ",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: "Avenir LT Std",
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(
                      width: size.width,
                      height: size.height * 0.1,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 25,
                            child: img,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Container(
                            width: size.width * 0.6,
                            alignment: Alignment.center,
                            child: TextFormField(
                              style: const TextStyle(
                                  fontFamily: "Avenir LT Std",
                                  color: Color(0xFF000000),
                                  fontSize: 14),
                              decoration: const InputDecoration(
                                isDense: false,
                                hintText: " Write a comment",
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 20,
                                ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(20.0))),
                              ),
                              autofocus: false,
                              controller: commentController,
                            ),
                          ),
                          feedModel.iscommenting
                              ? const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.black,
                                    ),
                                  ),
                                )
                              : IconButton(
                                  onPressed: () async {
                                    if (commentController.text.isEmpty) {
                                      Fluttertoast.showToast(
                                          msg: "Enter a Comment");
                                    } else {
                                      feedModel.commenting(
                                          context,
                                          postindex,
                                          commentController,
                                          name,
                                          email,
                                          feedModel.feed!.data[postindex].uuid,
                                          uimg);
                                    }
                                  },
                                  icon: const Icon(Icons.send),
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }

  Column comments(
      Size size, hrs, postindex, commentindex, FeedProvider feedModel) {
    Widget userpic = const CircleAvatar(
        radius: 25,
        backgroundImage: NetworkImage(
          "assets/images/user.png",
        ));
    feedModel.feed!.data[postindex].comments[commentindex].userPhoto != "null"
        ? userpic = CircleAvatar(
            radius: 25,
            backgroundImage: NetworkImage(baseurl +
                feedModel.feed!.data[postindex].comments[commentindex].userPhoto
                    .toString()))
        : userpic = const CircleAvatar(
            radius: 25,
            backgroundImage: NetworkImage(
              "assets/images/user.png",
            ));
    return Column(children: [
      SizedBox(
          child: SizedBox(
              width: size.width,
              child: SingleChildScrollView(
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
                        userpic,
                        const SizedBox(
                          width: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              feedModel.feed!.data[postindex]
                                  .comments[commentindex].userName,
                              style: const TextStyle(
                                fontFamily: "Avenir LT Std",
                                color: Color(0xFF4078A6),
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Container(
                                width: size.width * 0.75,
                                color: const Color(0xFFF6F6F6),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "  " +
                                        feedModel.feed!.data[postindex]
                                            .comments[commentindex].text,
                                    style: const TextStyle(
                                      fontFamily: "Avenir LT Std",
                                      color: Colors.black,
                                      fontSize: 13,
                                      //fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            SizedBox(
                              height: size.height * 0.02,
                              width: size.width * 0.3,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    hrs,
                                    style: const TextStyle(
                                      fontFamily: "Avenir LT Std",
                                      color: Colors.black,
                                      fontSize: 10,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      if (!feedModel.feed!.data[postindex]
                                          .currentUserPost) {
                                        if (!feedModel
                                            .feed!
                                            .data[postindex]
                                            .comments[commentindex]
                                            .currentUserHasLiked) {
                                          feedModel.commnetLike(
                                              feedModel
                                                  .feed!.data[postindex].uuid,
                                              postindex,
                                              commentindex);
                                        } else {
                                          feedModel.commentUnlike(
                                              feedModel
                                                  .feed!.data[postindex].uuid,
                                              postindex,
                                              commentindex);
                                        }
                                      }
                                    },
                                    child: Text(
                                      feedModel.feed!.data[postindex]
                                              .comments[commentindex].likes
                                              .toString() +
                                          " likes",
                                      style: const TextStyle(
                                        fontFamily: "Avenir LT Std",
                                        color: Colors.black,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              )))
    ]);
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
