import 'package:cloud_firestore/cloud_firestore.dart';

class CourseOrderModel {
  final String courseOrderName;
  final String currentUserId;
  final String emailId;
  final String courseUserName;

  CourseOrderModel({
    required this.courseUserName,
    required this.courseOrderName,
    required this.currentUserId,
    required this.emailId
  });

  Map<String, dynamic> getJson() => {
    'courseUserName':courseUserName,
        'courseOrderName': courseOrderName,
        'currentUserId': currentUserId,
         "emailId":emailId
      };

  factory CourseOrderModel.getModelFromJson(
      {required DocumentSnapshot  json}) {
    var snapshot = json.data() as Map<String, dynamic>;
    return CourseOrderModel(
      courseUserName:snapshot["courseUserName"] as String,
        courseOrderName: snapshot["courseOrderName"] as String,
        currentUserId: snapshot["currentUserId"] as String,
        emailId: snapshot["emailId"] as String,
    );
  }
}
