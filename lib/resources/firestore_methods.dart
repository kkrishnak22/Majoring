import 'dart:typed_data';

import 'package:eduk/models/product_model.dart';
import 'package:eduk/models/user_details_models.dart';
import 'package:eduk/resources/storage_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:uuid/uuid.dart';
import '../models/user.dart' as models_user;
import '../models/course_model.dart';
import '../models/course_order.dart';
import '../models/post.dart';
import '../models/yourCourses.dart';

class FireStoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  Future<String> uploadPost(
   String courseTitle ,
   String coursePrice,
   String courseDiscountPrice,
   String courseWhoIsThisFor,
   String courseBackgroundImage,
   String courseThumbnail,
   String courseDescription,
      //String description,
      Uint8List file,
      String uid,
      String username,
      String profImage
      ) async {
    // asking uid here because we dont want to make extra calls to firebase auth when we can just get from our state management
    String res = "Some error occurred";
    try {
      String photoUrl =
          await StorageMethods().uploadImageToStorage('posts', file, true);
      String postId = const Uuid().v1(); // creates unique id based on time
      Post post = Post(
        isFav: false,
        // courseTitle: courseTitle,
        // courseBackgroundImage: courseBackgroundImage,
        // courseDiscountPrice: courseDiscountPrice,
        // coursePrice: coursePrice,
        // courseThumbnail: courseThumbnail,
        // courseWhoIsThisFor: courseWhoIsThisFor,
        // courseDescription: courseDescription,
        uid: uid,
        username: username,
        likes: [],
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profImage: profImage,
      );
      _firestore.collection('posts').doc(postId).set(post.toJson());
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
  Future<Object> sendCourseToYourCourses(
  {
    required yourCourseDetails,
    required models_user.User user}) async {
    var r;
    try{
      var result= await firebaseFirestore
          .collection("users")
          .doc(firebaseAuth.currentUser!.uid)
          .collection("yourCourses")
          .add(yourCourseDetails);
      await sendCourseAndDetailsToTeacherOrSellerOfCourse(
        yourCourseDetails:yourCourseDetails,
        user: user, );
      print("course sent to orders");
        r=result;
    }catch(e){

    }
    return r;
  }
  Future sendCourseAndDetailsToTeacherOrSellerOfCourse ({
    required yourCourseDetails,
    required models_user.User user})async{
    CourseOrderModel courseOrderModel = CourseOrderModel(
        courseOrderName: yourCourseDetails['courseTitle'],
        currentUserId: user.uid,
        emailId: user.email,
        courseUserName:user.username
    );
    try{
      print("orders sending");
      await firebaseFirestore
          .collection("users")
          .doc(yourCourseDetails['courseSellerId']).collection("courseOrders")
          .add(courseOrderModel.getJson());
    }catch(e){

    }
  }
  Future sendDetailsForOnlineMeeting({
    required yourCourseDetails,
  }) async {

}
  Future addCourseToFav(String postId, String uid, bool ifFav) async{
    try{
      if(!ifFav){
      await  _firestore.collection('posts')
            .doc(postId)
            .update({
        'isFav':true
      });
      await firebaseFirestore
          .collection('users')
          .doc(firebaseAuth.currentUser!.uid)
          .collection('favCourses')
          .add({
        "postId":postId,
        "uid":uid,
      });
      }else{
        await _firestore.collection('posts')
            .doc(postId)
            .update(
          {
            'isFav':false
          }
        );

      }
    }catch(e){}
  }
  Future<String> likePost(String postId, String uid, List likes) async {
    String res = "Some error occurred";
    try {
      if (likes.contains(uid)) {
        // if the likes list contains the user uid, we need to remove it
        _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        // else we need to add uid to the likes array
        _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Post comment
  Future<void> postComment(String postId, String text, String uid,
      String name, String profilePic) async {
   // String res = "Some error occurred";
    try {
      if (text.isNotEmpty) {
        // if the likes list contains the user uid, we need to remove it
        String commentId = const Uuid().v1();
      await  _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
        });
       // res = 'success';
      } else {
        print("Please enter text");
      }
    } catch (e) {
     print(
         e.toString());
    };

  }

  // Delete Post
  Future<void> deletePost(String postId) async {
    String res = "Some error occurred";
    try {
      await _firestore.collection('posts').doc(postId).delete();
      res = 'success';
    } catch (err) {
      res = err.toString();
    }

  }

  Future<void> followUser(
    String uid,
    String followId
  ) async {
    try {
      DocumentSnapshot snap = await _firestore.collection('users').doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];

      if(following.contains(followId)) {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId])
        });
      } else {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId])
        });
      }

    } catch(e) {
      print(e.toString());
    }
  }
  Future<DocumentSnapshot> getCourseDetails(postId) async {
    DocumentSnapshot documentSnapshot =
    await _firestore.collection('posts').doc(postId).get();
     return documentSnapshot;
  }
}
