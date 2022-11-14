import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eduk/models/course_model.dart';
import 'package:eduk/resources/firestore_methods.dart';
import 'package:flutter/cupertino.dart';



class CourseModelProvider with ChangeNotifier {

  CourseModel? _courseModel;

  CourseModel get getCourseModel =>_courseModel!;

  Future<void> refreshCourseModel() async {
    //User user = await _authMethods.getUserDetails();
    DocumentSnapshot documentSnapshot = await FireStoreMethods()
        .getCourseDetails("postId");

    CourseModel courseModel  = await CourseModel
        .fromSnap(documentSnapshot);
    //_user = user;
    notifyListeners();
  }
}