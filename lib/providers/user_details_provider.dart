import 'package:flutter/material.dart';

import '../models/user_details_models.dart';
import '../services/cloudfirestore_methods.dart';



class UserDetailsProvider with ChangeNotifier{

  UserDetailsModels userDetails;

  UserDetailsProvider()
  : userDetails = UserDetailsModels(
      name: 'loading', city: 'loading', gmail: 'loading');

   Future getData() async {
     userDetails = await CloudFirestoreClass().getNameAndOtherDetails();
     notifyListeners();
   }
}