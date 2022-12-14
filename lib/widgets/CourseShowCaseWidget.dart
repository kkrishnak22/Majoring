import 'package:flutter/material.dart';

import '../constants/utils.dart';



class CourseShowcaseListView extends StatelessWidget{
  final String title;
  final List<Widget> children;
  const CourseShowcaseListView({Key? key ,
    required this.title,
    required this.children}) :super (key: key);
  @override
  Widget build(BuildContext context) {
    Size screenSize = Utils().getScreenSize();
    double height = screenSize.height / 4;
    double titleHeight = 25;
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(8),
      height: height,
      width: screenSize.width,
      color: Colors.black12,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            height:titleHeight ,
            child:  Row(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold
                  ),
                ),
                const Padding(
                  padding:  EdgeInsets.only(left: 14),
                  child:  Text('Show more',style: TextStyle(color: Colors.purple), ),
                )
              ],
            ),
          ),
          SizedBox(
            height: height- (titleHeight+26),
            width: MediaQuery.of(context).size.width,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: children,
            ),
          ),
        ],
      ),
    );
  }

}