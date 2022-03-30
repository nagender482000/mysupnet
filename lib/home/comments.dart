import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mysupnet/Apicalls/addcomment.dart';
import 'package:http/http.dart' as http;
import 'package:mysupnet/Apicalls/likeapi.dart';
import 'package:mysupnet/Apicalls/unlikeapi.dart';
import 'package:mysupnet/home/feed.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class CommentsSec extends StatefulWidget {
  late String id;
  late int index;
  final bool vis;
  late List postdata;
  late Map<dynamic, dynamic> postdatamap;
  late List<dynamic> commentdata;

  CommentsSec(this.id, this.index, this.postdata, this.postdatamap,
      this.commentdata, this.vis,
      {Key? key})
      : super(key: key);
  @override
  _CommentsSecState createState() => _CommentsSecState();
}

class _CommentsSecState extends State<CommentsSec> {
  Map<dynamic, dynamic> commentdatamap = {};
  int lcc = 0;

  final commentController = TextEditingController();
  bool isloading = true;

  void clike(String id, i) {
    likeapi(context, id, "comment");

    setState(() {
      commentdatamap[id]["isliked"] = true;

      widget.commentdata[0][i]["likes"] = widget.commentdata[0][i]["likes"] + 1;
    });
  }

  void cunlike(String id, i) {
    unlikeapi(context, id);

    setState(() {
      commentdatamap[id]["isliked"] = false;

      widget.commentdata[0][i]["likes"] = widget.commentdata[0][i]["likes"] - 1;
    });
  }

  String name = "";
  @override
  void initState() {
    setState(() {
      isloading = true;
    });
    super.initState();

    setState(() {
      isloading = false;
    });
  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  updatecomment(id, comment, likes) async {
    await postlist();
  }

  postlist() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token').toString();
    name = prefs.getString('name').toString();

    var headers = {
      'Authorization':
          // 'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNjQyMzg0NjUwLCJpYXQiOjE2NDEwODg2NTAsImp0aSI6IjBhZjQxMjlkNjU0NjQ4YmFiMWE4ZTAxMmM3MGUzZWUxIiwidXNlcl9pZCI6NDcsIm5hbWUiOiJkZWVwaWthYSBzdWJyYW1hbmlhbSIsInN1cHBvcnRfZ3JvdXBfaWQiOjMsInN1cHBvcnRfZ3JvdXBfbmFtZSI6Imdyb3VwMTAiLCJpc19zdXBlcl9hZG1pbiI6ZmFsc2UsImlzX2FkbWluX3VzZXIiOnRydWV9.YZcUWPvRBBHMN75YPCN27oI5efWwIA0ysY73cZ_GS_A'
          'Bearer ' + token.toString(),
    };
    var request = http.MultipartRequest(
        'GET', Uri.parse('https://apis.mysupnet.org/api/v1/post/all'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    var responsed = await http.Response.fromStream(response);
    final responseData = json.decode(responsed.body);

    if (response.statusCode == 200) {
      setState(() {
        widget.postdata = responseData["data"];
        for (int i = 0; i < widget.postdata.length; i++) {
          int likes = widget.postdata[i]["likes"];
          int comments = widget.postdata[i]["comments"].length;

          widget.postdatamap[widget.postdata[i]["uuid"].toString()] = {
            "postvis": widget.vis,
            "isliked": false,
            "lclickcount": 0,
            "bclickcount": 0,
            "isbookmarked": false,
            "isvisible": false,
            "likecount": likes,
            "commentscount": comments,
            "editvisible": false,
            "imgvisible": true,
            "user_email": widget.postdata[i]["user_email"].toString()

          };
        }
      });
    } else {
      return responseData["detail"];
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return isloading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                padding: EdgeInsets.zero,
                itemCount: widget.postdata[widget.index]["comments"].length,
                itemBuilder: (context, i) {
                  for (int i = 0; i < widget.commentdata[0].length; i++) {
                    if (widget.commentdata[0][i]["current_user_has_liked"]) {
                      lcc = 1;
                    } else {
                      lcc = 0;
                    }
                    commentdatamap[widget.commentdata[0][i]["uuid"]] = {
                      "isliked": widget.commentdata[0][i]
                          ["current_user_has_liked"],
                      "lclickcount": lcc,
                    };
                  }
                  widget.commentdata.clear();
                  widget.commentdata
                      .add(widget.postdata[widget.index]["comments"]);

                  if (widget.postdata[widget.index]["comments"].length > 0) {
                    return Column(children: [
                      comments(
                        size,
                        widget.commentdata[0][i]["uuid"].toString(),
                        widget.commentdata[0][i]["user_name"].toString(),
                        widget.commentdata[0][i]["text"].toString(),
                        widget.postdatamap[widget.id]["isvisible"],
                        //widget.postdata[widget.index]["comments"].length,
                        widget.commentdata[0][i]["likes"],
                        TimeAgo.timeAgoSinceDate(
                            DateTime.parse(widget.commentdata[0][i]["created"])
                                .toString()),
                        i,
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
                      child: Image.asset("assets/images/user.png"),
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0))),
                        ),
                        autofocus: false,
                        controller: commentController,
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        setState(() {
                          isloading = true;
                        });
                        await addcomment(
                            context, widget.id, commentController.text);
                        updatecomment(widget.id, commentController.text, 0);
                        commentController.text = "";
                        setState(() {
                          isloading = false;
                        });
                      },
                      icon: const Icon(Icons.add_comment),
                    ),
                  ],
                ),
              ),
              Container(
                color: const Color(0xFFF6F6F6),
                height: 10,
              ),
            ],
          );
  }

  Column comments(
    Size size,
    String cid,
    String commentname,
    String commenttext,
    bool viewVisible,
    //int commentscount,
    likes,
    hrs,
    i,
  ) {
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
                        CircleAvatar(
                          radius: 20,
                          child: Image.asset("assets/images/user.png"),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              commentname,
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
                              borderRadius: BorderRadius.circular(20.0),
                              child: Container(
                                width: size.width * 0.75,
                                color: const Color(0xFFF6F6F6),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    commenttext,
                                    style: const TextStyle(
                                      fontFamily: "Avenir LT Std",
                                      color: Color(0xFF4078A6),
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
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
                                      if (commentdatamap[cid]["lclickcount"] %
                                              2 ==
                                          0) {
                                        clike(cid, i);
                                      }
                                      setState(() {
                                        commentdatamap[cid]["lclickcount"] =
                                            commentdatamap[cid]["lclickcount"] +
                                                1;
                                      });
                                    },
                                    child: Text(
                                      likes.toString() + " likes",
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
