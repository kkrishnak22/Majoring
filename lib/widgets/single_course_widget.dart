import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/user_details_models.dart';
import '../screens/coursescreentest.dart';
import '../theme/color.dart';
import 'custom_image.dart';
import 'favorite_box.dart';
import 'package:eduk/models/user.dart';

class SingleCourseWidget extends StatefulWidget {
  final Map<String, dynamic> courseSnapShot;

  //final data;

  final GestureTapCallback? onTapFavorite;

  const SingleCourseWidget({
   // required this.data,

    this.onTapFavorite,
    required this.courseSnapShot,
    Key? key}) : super(key: key);

  @override
  State<SingleCourseWidget> createState() => _SingleCourseWidgetState();
}

class _SingleCourseWidgetState extends State<SingleCourseWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.push(context,
              MaterialPageRoute(builder: (context)=>
                  CourseScreenTest(
                      documentSnapshotOFCourse: widget.courseSnapShot,

                  ),
              ));
      },
      child: Container(
        width: MediaQuery.of(context).size.width -10,
        height: MediaQuery.of(context).size.height * 0.35,
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.only(bottom: 5, top: 5),
        decoration: BoxDecoration(
          color: Colors.black38,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: shadowColor.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 1,
              offset: Offset(1, 1), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomImage(
              widget.courseSnapShot["courseThumbnail"],
              width: double.infinity,
              height: 160,
              radius: 15,
            ),
            Container(
              width: MediaQuery.of(context).size.width -50,
              padding: EdgeInsets.fromLTRB(5, 10, 5, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.courseSnapShot["courseTitle"],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 18,
                        color: textColor,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.courseSnapShot["courseDescription"],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: labelColor, fontSize: 13),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            widget.courseSnapShot["coursePrice"],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: primary,
                                fontSize: 15,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      // FavoriteBox(
                      //   size: 16,
                      //   onTap: widget.onTapFavorite,
                      //   isFavorited: false
                      // )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
