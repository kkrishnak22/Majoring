import 'package:flutter/material.dart';

import '../screens/coursescreentest.dart';
import '../theme/color.dart';
import 'custom_image.dart';

class RecommendItem extends StatefulWidget {
  final Map<String, dynamic> courseSnapShot;
  final data;
  RecommendItem({
    Key? key,
    required  this.courseSnapShot,
    required this.data,
  }) : super(key: key);


  @override
  State<RecommendItem> createState() => _RecommendItemState();
}

class _RecommendItemState extends State<RecommendItem> {


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context,
            MaterialPageRoute(builder: (context)=>
                CourseScreenTest(
                  documentSnapshotOFCourse: widget.courseSnapShot,

                ),
            ));
      },
      child: Container(
          margin: EdgeInsets.only(right: 10),
          padding: EdgeInsets.all(10),
          width: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 1,
                offset: Offset(1, 1), // changes position of shadow
              ),
            ],
          ),
          child: Row(
            children: [
              CustomImage(
                widget.courseSnapShot["courseThumbnail"],
                radius: 15,
                height: 80,
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.courseSnapShot["courseTitle"],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      widget.courseSnapShot["courseDescription"],
                      style: TextStyle(fontSize: 12, color: labelColor),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          size: 14,
                          color: yellow,
                        ),
                        SizedBox(
                          width: 3,
                        ),
                        Expanded(
                          child: Text(
                            '4.9',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ),
                        Text(
                         '\u{20B9}''${widget.courseSnapShot['courseDiscountPrice']}',

                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          )),
    );
  }
}
