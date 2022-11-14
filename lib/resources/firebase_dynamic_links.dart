import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eduk/models/course_model.dart';
import 'package:eduk/screens/coursescreentest.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

import 'package:flutter/material.dart';

FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;

class FirebaseDynamicLinkService{

  static Future<String> createDynamicLink(
      bool  short,
      Map<String,dynamic> documentSnapshotOFCourse) async{
    String _linkMessage;

    final dynamicLinkParams = DynamicLinkParameters(
      uriPrefix: 'https://majoring.page.link',
      link: Uri.parse("https://majoring.page.link/"),
      androidParameters:const  AndroidParameters(
        packageName: 'com.example.eduk',
        minimumVersion: 30,
      ),
    );
    final dynamicLink =
    await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams);
    Uri url;
    if (short) {
      final ShortDynamicLink shortLink = await dynamicLinks.buildShortLink(dynamicLinkParams);
      url = shortLink.shortUrl;
    } else {
      url = await dynamicLinks.buildLink(dynamicLinkParams);
    }

    _linkMessage = url.toString();
    return _linkMessage;
  }

   static Future<void> initDynamicLink(BuildContext context)async {
     FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData){

       Navigator.pushNamed(context, dynamicLinkData.link.path);
     }).onError((error) {
       print(error);
     });

     final PendingDynamicLinkData? initialLink = await FirebaseDynamicLinks.instance.getInitialLink();

    try{
      final Uri deepLink = initialLink!.link;
      var isDocumentSnapshotOFCourse = deepLink.pathSegments.contains('documentSnapshotOFCourse');
      print(isDocumentSnapshotOFCourse);
      if(isDocumentSnapshotOFCourse){ // TODO :Modify Accordingly
        String? id = deepLink.queryParameters['courseId']; // TODO :Modify Accordingly
          print(id);
        // TODO : Navigate to your pages accordingly here

       if(deepLink!=null){
         try{
           await firebaseFirestore.collection('courses').doc("105986").get()
               .then((snapshot) {
             CourseModel courseModel = CourseModel.fromSnap(snapshot);

             return Navigator.push(context, MaterialPageRoute(builder: (context) =>
                 CourseScreenTest(
                     documentSnapshotOFCourse: courseModel.getJson())
             ));
           });
         }catch(e){
           print(e);
         }
       }
       else{

       }
      }
    }catch(e){
      print('No deepLink found');
    }
  }
}