import 'package:cloud_firestore/cloud_firestore.dart';

import 'course_model.dart';

class OnlineMeetingModel{
  final CourseModel courseModel;
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

  OnlineMeetingModel({
    required this.courseModel,
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
    required this.courseuid

  });

  Map<String, dynamic> toJson() => {
    "courseModel": courseModel.toJson(),
    "courseTitle":courseModel.courseTitle.toString(),
    'courseDescription': courseModel.courseDescription.toString(),
    "coursePrice":courseModel.coursePrice.toString(),
    "courseDiscountPrice": courseModel.courseDiscountPrice.toString(),
    "courseThumbnail":courseModel.courseThumbnail.toString() ,
    'courseBackgroundImage': courseModel.courseBackgroundImage.toString(),
    "courseVideoLink":courseModel.courseVideoLink.toString(),
    'courseWhoIsThisFor': courseModel.courseWhoIsThisFor.toString(),
    "courseSellerId":courseModel.courseSellerId.toString(),
    "courseSellerName":courseModel.courseSellerName.toString(),
  };

  factory OnlineMeetingModel.getModelFromJson(
      {required DocumentSnapshot  json}) {
    var snapshot = json.data() as Map<String, dynamic>;
    return OnlineMeetingModel(
      courseModel: snapshot["courseModel"] ,
      courseTitle: snapshot["courseTitle"],
      courseDescription:snapshot["courseDescription"],
      coursePrice:snapshot["coursePrice"],
      courseDiscountPrice:snapshot["courseDiscountPrice"],
      courseThumbnail :snapshot["courseThumbnail"] as String,
      courseBackgroundImage:snapshot["courseBackgroundImage"]as String,
      courseVideoLink:snapshot["courseVideoLink"] as String,
      courseWhoIsThisFor:snapshot['courseWhoIsThisFor'],
      courseuid: snapshot["uid"],
      courseSellerId:snapshot["courseSellerId"],
      courseSellerName:snapshot["courseSellerName"],

    );
  }
  factory OnlineMeetingModel.getModelFromJsonFromMap(
      {required var  json}) {
    var snapshot = json.data() as Map<String, dynamic>;
    return OnlineMeetingModel(
      courseModel: snapshot["courseModel"],
      courseTitle: snapshot["courseTitle"],
      courseDescription:snapshot["courseDescription"],
      coursePrice:snapshot["coursePrice"],
      courseDiscountPrice:snapshot["courseDiscountPrice"],
      courseThumbnail :snapshot["courseThumbnail"] as String,
      courseBackgroundImage:snapshot["courseBackgroundImage"]as String,
      courseVideoLink:snapshot["courseVideoLink"] as String,
      courseWhoIsThisFor:snapshot['courseWhoIsThisFor'],
      courseuid: snapshot["uid"],
      courseSellerId:snapshot["courseSellerId"],
      courseSellerName:snapshot["courseSellerName"],

    );
  }
}