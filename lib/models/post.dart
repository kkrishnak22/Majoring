import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
 // final String description;
  final String uid;
  final String username;
  final likes;
  final String postId;
  final DateTime datePublished;
  final String postUrl;
  final String profImage;
  // final String courseTitle ;
  // final String coursePrice;
  // final String courseDiscountPrice;
  // final String courseWhoIsThisFor;
  // final String courseBackgroundImage;
  // final String courseThumbnail;
  // final String courseDescription;
  final bool isFav;

  const Post(
      {
        //required this.description,
  //       required this.courseTitle,
  //       required this.courseDescription,
  //       required this.coursePrice,
  // required this.courseThumbnail,
  // required this.courseBackgroundImage,
  // required this.courseWhoIsThisFor,
  // required this.courseDiscountPrice,
  required this.datePublished,
  required this.likes,
required this.isFav,
      required this.uid,
      required this.username,

      required this.postId,

      required this.postUrl,
      required this.profImage,
      });

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Post(
    //  courseDescription: snapshot["description"],
      uid: snapshot["uid"],
      likes: snapshot["likes"],
      postId: snapshot["postId"],
      datePublished: snapshot["datePublished"],
      username: snapshot["username"],
      postUrl: snapshot['postUrl'],
      profImage: snapshot['profImage'],
      // courseBackgroundImage: snapshot['courseBackgroundImage'],
      // courseDiscountPrice:  snapshot['courseDiscountPrice'],
      // coursePrice: snapshot['coursePrice'] ,
      // courseThumbnail:  snapshot['courseThumbnail'],
      // courseTitle:  snapshot['courseTitle'],
      // courseWhoIsThisFor: snapshot['courseWhoIsThisFor'] ,
      isFav:snapshot["isFav"]
    );
  }

   Map<String, dynamic> toJson() => {
    //
    // 'courseTitle':courseTitle,
    //  'courseThumbnail':courseThumbnail,
    //     "description": courseDescription,
    //  'coursePrice':coursePrice,
    //  "courseBackgroundImage":courseBackgroundImage,
    //  "courseDiscountPrice":courseDiscountPrice,
        "uid": uid,
        "likes": likes,
        "username": username,
        "postId": postId,
        "datePublished": datePublished,
        'postUrl': postUrl,
        'profImage': profImage,
        // 'courseWhoIsThisFor':courseWhoIsThisFor,
        'isFav':isFav

      };
}
