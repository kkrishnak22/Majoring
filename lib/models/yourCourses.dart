import 'package:cloud_firestore/cloud_firestore.dart';

import 'course_model.dart';

class YourCourses{
   CourseModel courseModel;
  final String uid;
   YourCourses({
   required this.courseModel,
    required this.uid,
});

 Map<String, dynamic> toJson() =>{
   "courseModel":courseModel,
   "uid":uid,
 };
 static YourCourses fromSnap(DocumentSnapshot snap) {
   var snapshot = snap.data() as Map<String, dynamic>;
 return YourCourses(
     courseModel: snapshot["courseModel"],
     uid: snapshot["uid"],
 );
 }
 Map<String, dynamic> getJson() {
   return {
     "courseModel":courseModel,
     "uid":uid,
   };
 }
}