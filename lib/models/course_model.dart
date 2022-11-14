import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../constants/utils.dart';


class CourseModel{
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
   FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  // final courseRef =  FirebaseFirestore.instance
  //     .collection('products');
  final String courseTitle ;
  final String coursePrice;
  final String courseVideoLink;
  final String courseDiscountPrice;
  final String courseWhoIsThisFor;
  final String courseBackgroundImage;
  final String courseThumbnail;
  final String courseDescription;
  final String courseuid;
  final String courseSellerId;
  final String courseSellerName;
  //DateTime currentDate;

  CourseModel(
      {
        required this.courseSellerName,
        required this.courseSellerId,
        required this.courseDescription,
        required this.coursePrice,
        required this.courseBackgroundImage,
        required this.courseVideoLink,
        required this.courseDiscountPrice,
        required this.courseThumbnail,
        required this.courseTitle,
        required this.courseWhoIsThisFor,
        required this.courseuid,
    //required this.currentDate,
  }
  );

  Map<String, dynamic> toJson() =>{
    "courseTitle":courseTitle,
    'courseDescription': courseDescription,
    "coursePrice":coursePrice,
    "courseDiscountPrice": courseDiscountPrice,
    "courseThumbnail":courseThumbnail ,
    'courseBackgroundImage': courseBackgroundImage,
    "courseVideoLink":courseVideoLink,
    'courseWhoIsThisFor': courseWhoIsThisFor,
    "courseSellerId":courseSellerId,
    "courseSellerName":courseSellerName,
    "courseuid":courseuid,

    // "courseName":courseName,
    // "coursePrice":coursePrice,
    // "courseVideoLink":courseVideoLink,
    // "discount":discount
  };

  static CourseModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return CourseModel(
      courseTitle: snapshot["courseTitle"],
      courseDescription:snapshot["courseDescription"],
      coursePrice:snapshot["coursePrice"],
      courseDiscountPrice:snapshot["courseDiscountPrice"],
      courseThumbnail :snapshot["courseThumbnail"] as String,
      courseBackgroundImage:snapshot["courseBackgroundImage"]as String,
      courseVideoLink:snapshot["courseVideoLink"] as String,
      courseWhoIsThisFor:snapshot['courseWhoIsThisFor'],
      courseuid: snapshot["courseuid"],
        courseSellerId:snapshot["courseSellerId"],
        courseSellerName:snapshot["courseSellerName"],
      // discount: snapshot["discount"],
      //   courseName: snapshot["courseName"],
      //   uid: snapshot["uid"],
      //   coursePrice: snapshot["coursePrice"],
      //   courseVideoLink: snapshot["courseVideoLink"],

    );
  }
  factory CourseModel.getModelFromJson({required Map<String, dynamic> json}) {
    return CourseModel(
      courseTitle: json["courseTitle"]as String,
      courseDescription:json["courseDescription"]as String,
       coursePrice:json["coursePrice"]as String,
       courseDiscountPrice:json["courseDiscountPrice"]as String,
      courseThumbnail :json["courseThumbnail"]as String,
      courseBackgroundImage:json["courseBackgroundImage"]as String,
      courseVideoLink:json["courseVideoLink"] as String,
       courseWhoIsThisFor:json['courseWhoIsThisFor']as String,
      courseuid: json["courseuid"]as String,
        courseSellerId:json["courseSellerId"]as String,
      courseSellerName:json["courseSellerName"]as String,
        // discount: json["discount"],
        // courseName: json["courseName"],
        // uid: json["uid"],
        // coursePrice: json["coursePrice"],
        // courseVideoLink: json["courseVideoLink"],
    );
  }



  Map<String, dynamic> getJson() {
    return {
      "courseTitle":courseTitle,
      'courseDescription': courseDescription,
      "coursePrice":coursePrice,
      "courseDiscountPrice": courseDiscountPrice,
      "courseThumbnail":courseThumbnail ,
      'courseBackgroundImage': courseBackgroundImage,
      "courseVideoLink":courseVideoLink,
      'courseWhoIsThisFor': courseWhoIsThisFor,
      "courseSellerId":courseSellerId,
      "courseSellerName": courseSellerName,
      "courseuid":courseuid,
    };
  }
}