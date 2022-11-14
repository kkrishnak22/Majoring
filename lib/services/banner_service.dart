import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/carouselmodel.dart';

class BannerService{
  final bannersRef=FirebaseFirestore.instance.collection("banners").withConverter(
      fromFirestore: (snapshot,_)=>
          CarouselModel.getModelFromJson(
          json:snapshot.data()!),
      toFirestore: (poster,_)=>poster.toJson(),
  );
  Future<List<CarouselModel>> getBanners() async{
    var querySnapshot=await bannersRef.get();
    var carouselItemList = querySnapshot.docs.map((e) => e.data()).toList();
    return carouselItemList;
  }
}