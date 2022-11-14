import 'package:flutter/material.dart';

import '../constants/utils.dart';



class ProductsShowcaseListView extends StatelessWidget{
  final String title;
  final List<Widget> children;
  const ProductsShowcaseListView({Key? key ,
    required this.title,
    required this.children}) :super (key: key);
  @override
  Widget build(BuildContext context) {
    Size screenSize = Utils().getScreenSize();
    double height = screenSize.height / 4;
    double titleHeight = 25;
    return Container(


      color: Colors.redAccent,
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
          // SizedBox(
          //   height: height- (titleHeight+26),
          //   width: MediaQuery.of(context).size.width,
          //   child: ListView(
          //     scrollDirection: Axis.horizontal,
          //     children: children,
          //   ),
          // ),
        ],
      ),
    );
  }

}