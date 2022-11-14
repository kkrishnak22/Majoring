import 'package:flutter/material.dart';

import '../theme/color.dart';
import 'custom_image.dart';
import 'favorite_box.dart';

class FeatureItem extends StatefulWidget {
  final Map<String, dynamic> courseSnapShot;
  const FeatureItem(
      {Key? key,
        required  this.courseSnapShot,
      required this.data,
      this.width = 280,
      this.height = 300,
      this.onTap,
      this.onTapFavorite,
      })
      : super(key: key);
  final data;
  final double width;
  final double height;
  final GestureTapCallback? onTapFavorite;
  final GestureTapCallback? onTap;

  @override
  State<FeatureItem> createState() => _FeatureItemState();
}

class _FeatureItemState extends State<FeatureItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: widget.width,
        height: widget.height,
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.only(bottom: 5, top: 5),
        decoration: BoxDecoration(
          color: Colors.white,
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
            Image.network(
              widget.courseSnapShot["courseThumbnail"],
              width: double.infinity,
              height: 160,
             // radius: 15,
            ),
            Container(
              width: widget.width - 20,
              padding: EdgeInsets.fromLTRB(5, 10, 5, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.data["name"],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 18,
                        color: textColor,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.data["type"],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: labelColor, fontSize: 13),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            widget.data["price"],
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
                      //   isFavorited: widget.data["is_favorited"],
                      // ),
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
