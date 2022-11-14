import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/dimensions.dart';

class ShowCourseOrders extends StatefulWidget {

  const ShowCourseOrders({
    Key? key,

  }) : super(key: key);

  @override
  State<ShowCourseOrders> createState() => _ShowCourseOrdersState();
}

class _ShowCourseOrdersState extends State<ShowCourseOrders> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return
    Scaffold(
      appBar: AppBar(title: const Text("Course Orders"),),
      body:   StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("courseOrders")
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
                final DocumentSnapshot courseOrder =
                snapshot.data!.docs[index];
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
                                    Text(" Course Name :" +courseOrder['courseOrderName']),
                                    Text(" username:"+courseOrder['courseUserName']),
                                    Text(" Userid:"+courseOrder['currentUserId']),
                                    Text(" email:"+courseOrder['emailId']),

                                  ],
                                )
                              ] ,
                            )
                          ],
                        ),
                      ),
                    ));
              });
        },
      ),
    );
  }
}
