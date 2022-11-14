import 'package:cloud_firestore/cloud_firestore.dart';

class CarouselModel {
  final String id;
  final String image;

  CarouselModel({
    required this.id,
    required this.image});

  factory CarouselModel.getModelFromJson({required Map<String, dynamic> json}) {
    return CarouselModel(
      id: json["id"] as String,
      image:json["image"] as String,

    );
  }
  Map<String, dynamic> toJson() =>{
    "id":id,
    'image': image,

  };
}