import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String description;
  final String uid;
  final String username;
  final dynamic likes;
  final String postId;
  final DateTime datePublished;
  final String postUrl;
  final String profImage;
  final List<String> categoryIds;
  final bool isVideo;

  const Post(
      {required this.description,
      required this.uid,
      required this.username,
      required this.likes,
      required this.postId,
      required this.datePublished,
      required this.postUrl,
      required this.profImage,
      required this.categoryIds,
      required this.isVideo});

  Map<String, dynamic> toJson() => {
        'Description': description,
        "Uid": uid,
        "Likes": likes,
        "PostId": postId,
        "DatePublished": datePublished,
        "Username": username,
        "PostUrl": postUrl,
        "ProfImage": profImage,
        "CategoryIds": categoryIds,
        "IsVideo": isVideo,
      };

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Post(
      description: snapshot['Description'] ?? '',
      uid: snapshot["Uid"] ?? '',
      likes: snapshot["Likes"] ?? [],
      postId: snapshot["PostId"],
      datePublished: (snapshot["DatePublished"] as Timestamp).toDate(),
      username: snapshot["Username"] ?? '',
      postUrl: snapshot["PostUrl"] ?? '',
      profImage: snapshot["ProfImage"] ?? '',
      categoryIds: List<String>.from(snapshot["CategoryIds"] ?? []),
      isVideo: snapshot['IsVideo'] ?? false,
    );
  }
}
