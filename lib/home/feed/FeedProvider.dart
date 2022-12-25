import 'package:flutter/material.dart';
import 'package:mysupnet/Apicalls/addcomment.dart';
import 'package:mysupnet/Apicalls/bookmark.dart';
import 'package:mysupnet/Apicalls/feedAPI.dart';
import 'package:mysupnet/Apicalls/likeapi.dart';
import 'package:mysupnet/Apicalls/unbookmark.dart';
import 'package:mysupnet/Apicalls/unlikeapi.dart';
import 'package:mysupnet/home/feed/feed_Model.dart';

class FeedProvider extends ChangeNotifier {
  FeedData? feed;
  bool isloading = true;
  bool iscommenting = false;

  getpost() async {
    isloading = true;
    var data = await postlist();
    feed = FeedData.fromJson(data);
    isloading = false;
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

  void commenting(context, postindex, commentController, userName, userEmail,
      postUuid, userPhoto) async {
    iscommenting = true;

    feed!.data[postindex].comments.add(Comment(
        uuid: "uuid",
        text: commentController.text,
        created: DateTime.now(),
        updated: DateTime.now(),
        userName: userName,
        userEmail: userEmail,
        postUuid: postUuid,
        userPhoto: userPhoto,
        currentUserHasLiked: false,
        likes: 0));
    commentController.text = "";
    feed!.data[postindex].commentCount += 1;
     iscommenting = false;

    notifyListeners();
    await addcomment(
      context,
      feed!.data[postindex].uuid,
      commentController.text,
    );
   
  }
}
