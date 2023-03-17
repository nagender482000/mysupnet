import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mysupnet/Apicalls/addcomment.dart';
import 'package:mysupnet/Apicalls/bookmark.dart';
import 'package:mysupnet/Apicalls/feedAPI.dart';
import 'package:mysupnet/Apicalls/likeapi.dart';
import 'package:mysupnet/Apicalls/unbookmark.dart';
import 'package:mysupnet/Apicalls/unlikeapi.dart';
import 'package:mysupnet/home/feed/feed_Model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class FeedProvider extends ChangeNotifier {
  FeedData? feed;
  bool isloading = true;
  bool iscommenting = false;
  String userEmail = "";
  String userImg = "";
  String userName = "";
  getpost() async {
    isloading = true;
    var data = await postlist();
    feed = FeedData.fromJson(data);
    await profile();
    isloading = false;
    notifyListeners();
  }

  profile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token').toString();
    String email = prefs.getString('email').toString();

    var headers = {'Authorization': 'Bearer ' + token.toString()};
    var request = http.MultipartRequest('GET',
        Uri.parse('https://apis.mysupnet.org/api/v1/user?email=' + email));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    var responsed = await http.Response.fromStream(response);
    final responseData = json.decode(responsed.body);
    if (response.statusCode == 200) {
      var userdata = responseData["data"];
      userImg = userdata["photo"].toString();
      userName = userdata["name"].toString();
      userEmail = userdata["email"].toString();

      prefs.setString('img', userImg);
    }
    notifyListeners();
  }

  void postLike(String id, index) async {
    feed!.data[index].currentUserHasLiked = true;
    feed!.data[index].likes += 1;

    notifyListeners();
    await likeapi(id, "post");
  }

  void postUnlike(String id, index) async {
    feed!.data[index].currentUserHasLiked = false;
    feed!.data[index].likes -= 1;

    notifyListeners();
    await unlikeapi(id);
  }

  void bookmark(String id, index) async {
    feed!.data[index].currentUserHasBookmarked = true;

    notifyListeners();
    await bookmarkapi(id);
  }

  void unbookmark(String id, index) async {
    feed!.data[index].currentUserHasBookmarked = false;

    notifyListeners();
    await unbookmarkapi(id);
  }

  void showComments(
    int index,
  ) async {
    feed!.data[index].isCommentsVisible = true;
    notifyListeners();
  }

  void hideComments(int index) async {
    feed!.data[index].isCommentsVisible = false;
    notifyListeners();
  }

  void hidePost(
    int index,
  ) async {
    feed!.data[index].isPostVisible = false;
    notifyListeners();
  }

  void commnetLike(String id, postIndex, commentIndex) async {
    feed!.data[postIndex].comments[commentIndex].likes += 1;
    feed!.data[postIndex].comments[commentIndex].currentUserHasLiked = true;

    notifyListeners();
    await likeapi(id, "comment");
  }

  void commentUnlike(String id, postIndex, commentIndex) async {
    feed!.data[postIndex].comments[commentIndex].likes -= 1;
    feed!.data[postIndex].comments[commentIndex].currentUserHasLiked = false;

    notifyListeners();
    await unlikeapi(id);
  }

  void commenting(context, postindex, comment, userName, userEmail, postUuid,
      userPhoto) async {
    iscommenting = true;
    feed!.data[postindex].comments.add(Comment(
        uuid: "uuid",
        text: comment,
        created: DateTime.now(),
        updated: DateTime.now(),
        userName: userName,
        userEmail: userEmail,
        postUuid: postUuid,
        userPhoto: userPhoto,
        currentUserHasLiked: false,
        likes: 0));
    feed!.data[postindex].commentCount += 1;
    iscommenting = false;

    notifyListeners();
    await addcomment(
      context,
      feed!.data[postindex].uuid,
      comment,
    );
  }
}
