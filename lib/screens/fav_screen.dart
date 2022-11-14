import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/course_model.dart';
import '../models/user.dart';
import '../providers/user_provider.dart';
import '../utils/dimensions.dart';
import '../widgets/post_card.dart';

import '../widgets/single_course_widget.dart';

class Fav_Screen extends StatefulWidget {
  const Fav_Screen({Key? key}) : super(key: key);

  @override
  State<Fav_Screen> createState() => _Fav_ScreenState();
}

class _Fav_ScreenState extends State<Fav_Screen> {
  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Feed Screen"),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[Colors.pink, Colors.blue]),
          ),
        ),
      ),
      body:  SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          children: [
            SizedBox(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection('posts').snapshots(),
                builder: (context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (ctx, index) => Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: width > webScreenSize ? width * 0.3 : 0,
                          vertical: width > webScreenSize ? 15 : 0,
                        ),
                        child: PostCard(
                          snap: snapshot.data!.docs[index].data(),
                          // courseModel:CourseModel(
                          //   coursePrice: snapshot.data!.docs[index]['coursePrice'],
                          //   courseSellerName: snapshot.data!.docs[index]['courseSellerName'],
                          //   courseSellerId: snapshot.data!.docs[index]['courseSellerId'],
                          //   courseDescription: snapshot.data!.docs[index]['courseDescription'],
                          //   courseBackgroundImage: snapshot.data!.docs[index]['courseBackgroundImage'],
                          //   courseDiscountPrice: snapshot.data!.docs[index]['courseDiscountPrice'],
                          //   courseThumbnail: snapshot.data!.docs[index]['courseThumbnail'],
                          //   courseTitle: snapshot.data!.docs[index]['courseTitle'],
                          //   courseWhoIsThisFor: snapshot.data!.docs[index]['courseWhoIsThisFor'],
                          //   courseuid: snapshot.data!.docs[index]['courseuid'],
                          // ), user: user,
                          user: user,
                        ),
                      )
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
