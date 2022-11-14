// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/dimensions.dart';
import '../widgets/single_course_widget.dart';

class YourCoursesScreen extends StatefulWidget {
  const YourCoursesScreen({Key? key}) : super(key: key);

  @override
  State<YourCoursesScreen> createState() => _YourCoursesScreenState();
}

class _YourCoursesScreenState extends State<YourCoursesScreen> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("yourCourses")
          .snapshots(),
      builder: (context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView.builder(
            //    scrollDirection : Axis.horizontal,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (ctx, index) {
              final Map<String, dynamic> documentSnapshotOFCourse =
                  snapshot.data!.docs[index].data();
              return Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: width > webScreenSize ? width * 0.3 : 0,
                    vertical: width > webScreenSize ? 15 : 0,
                  ),
                  child: Card(
                      color: Colors.black,
                      elevation: 8.0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 16),
                        height: 200,
                        width: 350,
                        child: Column(
                          children: [
                          Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:  [
                             CircleAvatar(
                              radius: 50, //we give the image a radius of 50
                              backgroundImage: NetworkImage(
                                documentSnapshotOFCourse['courseBackgroundImage']
                                  ),
                                ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(right: 30,top: 8.0,
                                  ),
                                  width: 150,
                                  color: Colors.blueGrey,
                                  height: 2,
                                ),
                                const SizedBox(height: 4),
                                 Text(" Name :" +documentSnapshotOFCourse['courseTitle']),
                                 Text(" Description:"+documentSnapshotOFCourse['courseDescription']),
                                 Text(" Uploaded by:"+documentSnapshotOFCourse['courseSellerName']),
                                 Text(" Price:"+documentSnapshotOFCourse['coursePrice']),
                              ],
                            )
                             ] ,
                            )
                          ],
                        ),
                      ),
                    ),

              );
            });
      },
    );
  }
}
