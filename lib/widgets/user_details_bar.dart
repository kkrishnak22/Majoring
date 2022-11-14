import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/constant.dart';
import '../models/user_details_models.dart';
import '../providers/user_details_provider.dart';


class UserDetailsBar extends StatelessWidget{

final double offset;
final List<Color> color = [Color(0xFF604EFF),Colors.blueAccent];
 UserDetailsBar({
Key?key,
required this.offset,
}):super(key:key);
@override
Widget build(BuildContext context){
  UserDetailsModels userDetailsModels= Provider.of<UserDetailsProvider>(context).userDetails;
  return Positioned(
    top: -offset / 3,
    child: Container(
      height: kAppBarHeight/3,
        width: MediaQuery.of(context).size.width,
        decoration:BoxDecoration(
          gradient: LinearGradient(
            colors:color,
            begin: Alignment.centerLeft,
            end: Alignment.centerRight
          )
        ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 2,
          horizontal: 20,
        ) ,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(Icons.location_on_outlined, color: Colors.grey[900],),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width *0.7,
              child: Text('Deliver to ${userDetailsModels.name} - ${userDetailsModels.city}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              color: Colors.grey[900],
          ) ,
          ),
            ),

          ],
        ),
      ),
    ),
  );
}
}