import 'dart:convert';

class FeedData {
  FeedData({
    required this.status,
    required this.detail,
    required this.data,
  });

  final int status;
  final String detail;
  final List<Datum> data;

  factory FeedData.fromRawJson(String str) =>
      FeedData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FeedData.fromJson(Map<String, dynamic> json) => FeedData(
        status: json["status"],
        detail: json["detail"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "detail": detail,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    required this.uuid,
    required this.text,
    required this.created,
    required this.comments,
    required this.likes,
    required this.flagged,
    required this.userEmail,
    required this.userName,
    required this.userCondition,
    required this.userYearOfDiagnosis,
    required this.userRole,
    required this.photo,
    required this.currentUserPost,
    required this.currentUserHasLiked,
    required this.currentUserHasBookmarked,
    this.isPostVisible = true,
    this.isCommentsVisible = false,
    this.commentCount = 0,
  }) {
    commentCount = comments.length;
  }
  final String uuid;
  final String text;
  final DateTime created;
  final List<Comment> comments;
  int likes;
  int commentCount;
  final bool flagged;
  final String userEmail;
  final String userName;
  final String userCondition;
  final DateTime userYearOfDiagnosis;
  final String userRole;
  final String photo;
  final bool currentUserPost;
  bool currentUserHasLiked;
  bool currentUserHasBookmarked;
  bool isPostVisible;
  bool isCommentsVisible;

  factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        uuid: json["uuid"],
        text: json["text"],
        created: DateTime.parse(json["created"]),
        comments: List<Comment>.from(
            json["comments"].map((x) => Comment.fromJson(x))),
        likes: json["likes"],
        flagged: json["flagged"],
        userEmail: json["user_email"],
        userName: json["user_name"],
        userCondition: json["user_condition"],
        userYearOfDiagnosis: json["user_year_of_diagnosis"] == null
            ? DateTime.now()
            : DateTime.parse(json["user_year_of_diagnosis"]),
        userRole: json["user_role"],
        photo: json["photo"].toString(),
        currentUserPost: json["current_user_post"],
        currentUserHasLiked: json["current_user_has_liked"],
        currentUserHasBookmarked: json["current_user_has_bookmarked"],
      );

  Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "text": text,
        "created": created.toIso8601String(),
        "comments": List<dynamic>.from(comments.map((x) => x.toJson())),
        "likes": likes,
        "flagged": flagged,
        "user_email": userEmail,
        "user_name": userName,
        "user_condition": userCondition,
        "user_year_of_diagnosis": userYearOfDiagnosis.toIso8601String(),
        "user_role": userRole,
        "photo": photo,
        "current_user_post": currentUserPost,
        "current_user_has_liked": currentUserHasLiked,
        "current_user_has_bookmarked": currentUserHasBookmarked,
      };
}

class Comment {
  Comment({
    required this.uuid,
    required this.text,
    required this.created,
    required this.updated,
    required this.userName,
    required this.userEmail,
    required this.postUuid,
    required this.userPhoto,
    required this.currentUserHasLiked,
    required this.likes,
  });

  final String uuid;
  final String text;
  final DateTime created;
  final DateTime updated;
  final String userName;
  final String userEmail;
  final String postUuid;
  final String userPhoto;
  bool currentUserHasLiked;
  int likes;

  factory Comment.fromRawJson(String str) => Comment.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        uuid: json["uuid"],
        text: json["text"],
        created: DateTime.parse(json["created"]),
        updated: DateTime.parse(json["updated"]),
        userName: json["user_name"],
        userEmail: json["user_email"],
        postUuid: json["post_uuid"],
        userPhoto: json["user_photo"] == null ? "null" : json["user_photo"],
        currentUserHasLiked: json["current_user_has_liked"],
        likes: json["likes"],
      );

  Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "text": text,
        "created": created.toIso8601String(),
        "updated": updated.toIso8601String(),
        "user_name": userName,
        "user_email": userEmail,
        "post_uuid": postUuid,
        "user_photo": userPhoto == null ? null : userPhoto,
        "current_user_has_liked": currentUserHasLiked,
        "likes": likes,
      };
}
