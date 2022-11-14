import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eduk/models/online_meeting_model.dart';
import 'package:eduk/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants/utils.dart';
import '../models/course_model.dart';
import '../models/order_request_model.dart';
import '../models/product_model.dart';
import '../models/user.dart' as models_user;
import '../models/review_model.dart';
import '../models/user_details_models.dart';

import '../widgets/simple_product_widget.dart';




class CloudFirestoreClass {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future uploadUserNameAndOtherDetails(
      {required UserDetailsModels user}) async {
    //creating or adding to the collection
    await firebaseFirestore
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .set(user.getJon());
  }
  // Future updateProfile() async{
  //   await firebaseFirestore
  //       .collection('users')
  //       .doc(firebaseAuth.currentUser!.uid).set();
  // }

  Future<UserDetailsModels> getNameAndOtherDetails() async {
    DocumentSnapshot snap = await firebaseFirestore
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .get();
    UserDetailsModels userDetailsModel =
        UserDetailsModels.getModelFromJson(snap.data() as dynamic);
    return userDetailsModel;
  }
        Future addToFavToDb({
          required UserDetailsModels userDetailsModels,
          required courseTitle
            }) async{
          DocumentReference<Map<String, dynamic>> output= await firebaseFirestore
              .collection("users")
              .doc(firebaseAuth.currentUser!.uid)
              .collection("favCourses")
              .add({
              "courseTitle":courseTitle
              }
          );
          if(output!=null){
            print(output.id);
          }else print("unsuc");
        }
  Future<DocumentSnapshot<Map<String,dynamic>>> getCourseModel(courseId) async {
    DocumentSnapshot<Map<String,dynamic>> courseModel = await firebaseFirestore
        .collection('allCourses')
        .doc(courseId)
        .get();
    return courseModel;
  }
  Future<String> uploadCourseToDB({
    required currentUserId,
    required courseDescription,
    required coursePrice,
    required courseBackgroundImage,
    required courseDiscountPrice,
    required courseThumbnail,
    required courseTitle,
    required courseWhoIsThisFor,
    required courseuid,
    required courseVideoLink,
    //required user,
    //required  sellerId,
    // required String coursePrice,
    // required String courseVideoLink,
    // required String uid,
  }) async {
    courseTitle.trim();
    coursePrice.trim();
    courseuid.trim();
    courseThumbnail.trim();
    String demoid=courseuid.toString();

    String output = "Something went wrong";

    if (courseThumbnail != "" && courseTitle != "" && coursePrice != ""&&courseuid!="") {
      try{
        String userId =  firebaseAuth.currentUser!.uid.toString();
        DocumentSnapshot documentSnapshot=
        await firebaseFirestore.collection("users").doc(userId).get();
        models_user.User userModel =models_user.User.getModelFromJsonOrSnap(
            snap: documentSnapshot);


        double cost = double.parse(coursePrice);

        CourseModel course = CourseModel(
            courseuid: courseuid,
            courseDescription: courseDescription,
            coursePrice: coursePrice,
            courseBackgroundImage: courseBackgroundImage,
            courseDiscountPrice: courseDiscountPrice,
            courseThumbnail: courseThumbnail,
            courseTitle: courseTitle,
            courseWhoIsThisFor: courseWhoIsThisFor,
            courseSellerId: userModel.uid,
            courseSellerName:userModel.sellingName,
            courseVideoLink:courseVideoLink,
        ) ;
        await firebaseFirestore.collection("allCourses").doc(demoid).set(course.toJson());
        output ="Success";

      }catch(e){
        output = e.toString();
      }
    }else{
      output ="Please make sure all fields are not empty";
    }
    return output;
  }
  Future<String> uploadProductToDatabase({
    required Uint8List? image,
    required String productName,
    required String rawCost,
    required int discount,
    required String sellerName,
    required String sellerUid,
  }) async {
    productName.trim();
    rawCost.trim();
    String output = "Something went wrong";

    if (image != null && productName != "" && rawCost != "") {
      try {
        String uid = Utils().getUid();
        String url = await uploadImageToDatabase(image: image, uid: uid);
        double cost = double.parse(rawCost);
        cost = cost - (cost * (discount / 100));
        ProductModel product = ProductModel(
            url: url,
            productName: productName,
            cost: cost,
            discount: discount,
            uid: uid,
            sellerName: sellerName,
            sellerUid: sellerUid,
            rating: 5,
            noOfRating: 0);

        await firebaseFirestore
            .collection("products")
            .doc(uid)
            .set(product.getJson());
        output = "success";
      } catch (e) {
        output = e.toString();
      }
    } else {
      output = "Please make sure all the fields are not empty";
    }

    return output;
  }
Future<String> getCurrentUserId()async{
    String uid=FirebaseAuth.instance.currentUser!.uid.toString();
    return uid;
    print(uid);
}
  Future<String> uploadImageToDatabase(
      {required Uint8List image, required String uid}) async {
    Reference storageRef =
        FirebaseStorage.instance.ref().child("products").child(uid);
    UploadTask uploadToask = storageRef.putData(image);
    TaskSnapshot task = await uploadToask;
    return task.ref.getDownloadURL();
  }

  Future deleteProductFromCart({required String uid}) async {
    await firebaseFirestore
        .collection("users")
        .doc(firebaseAuth.currentUser!.uid)
        .collection("cart")
        .doc(uid)
        .delete();
  }

  Future buyAllItemsInCart({required UserDetailsModels userDetails}) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await firebaseFirestore
        .collection("users")
        .doc(firebaseAuth.currentUser!.uid)
        .collection("cart")
        .get();

    for (int i = 0; i < snapshot.docs.length; i++) {
      ProductModel model =
          ProductModel.getModelFromJson(json: snapshot.docs[i].data());
      addProductToOrders(model: model, userDetails: userDetails);
      await deleteProductFromCart(uid: model.uid);
    }
  }

  Future addProductToOrders(
      {
        required ProductModel model,
      required UserDetailsModels userDetails}) async {
    await firebaseFirestore
        .collection("users")
        .doc(firebaseAuth.currentUser!.uid)
        .collection("orders")
        .add(model.getJson());
    await sendOrderRequest(model: model, userDetails: userDetails);
  }
  Future addCourseToOnlineMeetingList({
    required Map<String,dynamic> snapshotOfCourse,
  }) async{
    // OnlineMeetingModel onlineMeetingModelCourse =  OnlineMeetingModel
    //     .getModelFromJsonFromMap(json: snapshotOfCourse);
    // print(onlineMeetingModelCourse);
    await firebaseFirestore
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .collection('onlineMeeting').add({
         "courseTitle": snapshotOfCourse["courseTitle"],
         "courseDescription":snapshotOfCourse["courseDescription"],
         "coursePrice":snapshotOfCourse["coursePrice"],
         "courseDiscountPrice":snapshotOfCourse["courseDiscountPrice"],
         'courseThumbnail' :snapshotOfCourse["courseThumbnail"] as String,
         'courseBackgroundImage':snapshotOfCourse["courseBackgroundImage"]as String,
         'courseVideoLink':snapshotOfCourse["courseVideoLink"] as String,
         'courseWhoIsThisFor':snapshotOfCourse['courseWhoIsThisFor'],
         'courseuid': snapshotOfCourse["uid"],
         'courseSellerId':snapshotOfCourse["courseSellerId"],
         'courseSellerName':snapshotOfCourse["courseSellerName"],
    });
    await firebaseFirestore.collection('onlineMeetingList').add({
      "courseTitle": snapshotOfCourse["courseTitle"],
      "courseDescription":snapshotOfCourse["courseDescription"],
      "coursePrice":snapshotOfCourse["coursePrice"],
      "courseDiscountPrice":snapshotOfCourse["courseDiscountPrice"],
      'courseThumbnail' :snapshotOfCourse["courseThumbnail"] as String,
      'courseBackgroundImage':snapshotOfCourse["courseBackgroundImage"]as String,
      'courseVideoLink':snapshotOfCourse["courseVideoLink"] as String,
      'courseWhoIsThisFor':snapshotOfCourse['courseWhoIsThisFor'],
      'courseuid': snapshotOfCourse["uid"],
      'courseSellerId':snapshotOfCourse["courseSellerId"],
      'courseSellerName':snapshotOfCourse["courseSellerName"],
    });
  }


  Future sendOrderRequest(
      {
        required ProductModel model,
      required UserDetailsModels userDetails}) async {
    OrderRequestModel orderRequestModel = OrderRequestModel(
        orderName: model.productName, buyersAddress: userDetails.gmail);
    await firebaseFirestore
        .collection("users")
        .doc(model.sellerUid)
        .collection("orderRequests")
        .add(orderRequestModel.getJson());
  }

  Future changeAverageRating(
      {required String productUid, required ReviewModel reviewModel}) async {
    DocumentSnapshot snapshot =
        await firebaseFirestore.collection("products").doc(productUid).get();
    ProductModel model =
        ProductModel.getModelFromJson(json: (snapshot.data() as dynamic));
    int currentRating = model.rating;
    int newRating = (currentRating + reviewModel.rating) ~/ 2;
    await firebaseFirestore
        .collection("products")
        .doc(productUid)
        .update({"rating": newRating});
  }

  Future<List<Widget>> getProductsFromDiscount(int discount) async {
    List<Widget> children = [];
    QuerySnapshot<Map<String, dynamic>> snap = await firebaseFirestore
        .collection('products')
        .where('discount', isEqualTo: discount)
        .get();
    for (int i = 0; i < snap.docs.length; i++) {
      DocumentSnapshot docSnap = snap.docs[i];
      ProductModel productModel =
          ProductModel.getModelFromJson(json: (docSnap.data() as dynamic));
      children.add(SimpleProductWidget(productModel: productModel));
    }
    return children;
  }

  Future uploadReviewToDataBAse(
      {required String productUid,
        required ReviewModel model
   }) async {
    await firebaseFirestore
        .collection('products')
        .doc(productUid)
        .collection('reviews')
        .add(model.getJson());
  }
  Future addProductToCart({required ProductModel productModel}) async{
   await firebaseFirestore
       .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .collection('cart')
       .doc(productModel.uid)
       .set(productModel.getJson());
  }
  // Future<List<Widget>> getCoursesFromDb(int discount) async {
  //   List<Widget> allCourses = [];
  //  try{
  //    DocumentSnapshot documentSnapshot =
  //    await FirebaseFirestore.instance
  //        .collection('users')
  //        .doc(FirebaseAuth.instance.currentUser!.uid).get();
  //    models_user.User user = models_user.User
  //        .getModelFromJsonOrSnap(snap: documentSnapshot) ;
  //    QuerySnapshot<Map<String, dynamic>> snap = await firebaseFirestore
  //        .collection('allCourses')
  //        .get();
  //    for (int i = 0; i < snap.docs.length; i++) {
  //      DocumentSnapshot documentSnapshot =snap.docs[i];
  //      CourseModel courseModel =CourseModel.getModelFromJson(json: (documentSnapshot.data() as dynamic));
  //
  //      allCourses.add(
  //          SimpleCourseWidget(
  //            snap: documentSnapshot,
  //          //  courseModel: courseModel,
  //            user:models_user.User
  //                .getModelFromJsonOrSnap(snap: documentSnapshot),
  //          )
  //      );
  //      print(allCourses);
  //  }
  //   }catch(e){
  //     print(e.toString());
  //  }
  //   return allCourses;
  // }
  
}
