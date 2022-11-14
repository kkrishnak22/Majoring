

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:rating_dialog/rating_dialog.dart';

import '../models/review_model.dart';
import '../providers/user_details_provider.dart';
import '../services/cloudfirestore_methods.dart';


class ReviewDialog extends StatelessWidget {
  final String productUid;
  const ReviewDialog({Key? key, required this.productUid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RatingDialog(
      // your app's name?
      title: Text(
        'Type a review for this product',
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
      // encourage your user to leave a high rating?

      // your app's logo
      submitButtonText: 'Send',
      commentHint: 'Type here',
     // onCancelled: () => print('cancelled'),
      onSubmitted: (RatingDialogResponse res) async{
      CloudFirestoreClass().uploadReviewToDataBAse(
          productUid: productUid, 
          model: ReviewModel(senderName: Provider.of<UserDetailsProvider>(context,listen: false).userDetails.name, description: res.comment, rating: res.rating.toInt()));

      },
    );

  }
}
