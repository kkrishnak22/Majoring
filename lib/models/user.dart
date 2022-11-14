import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String uid;
  final String photoUrl;
  final String username;
  final String bio;
  final List followers;
  final List following;
  final String sellingName;
  final String mobileNumber;
  final String clgName;
 // String optionalField="";

  const User(
      //this.optionalField,
      {
        required this.username,
      required this.uid,
      required this.photoUrl,
      required this.email,
      required this.bio,
      required this.followers,
        required this.sellingName,
      required this.following,
        required this.mobileNumber,
        required this.clgName,
      }

      );

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
      username: snapshot["username"],
      uid: snapshot["uid"],
      email: snapshot["email"],
      photoUrl: snapshot["photoUrl"],
      bio: snapshot["bio"],
      followers: snapshot["followers"],
      following: snapshot["following"],
      sellingName: snapshot["sellingName"],
      mobileNumber: snapshot["mobileNumber"],
      clgName: snapshot['clgName']
      //optionalField:snapshot["optionalField"],
    );
  }
factory User.getModelFromJsonOrSnap({
    required snap
}){
  var snapshot = snap.data() as Map<String, dynamic>;
    return User(
      username: snapshot["username"],
      uid: snapshot["uid"],
      email: snapshot["email"],
      photoUrl: snapshot["photoUrl"],
      bio: snapshot["bio"],
      followers: snapshot["followers"],
      following: snapshot["following"],
      sellingName: snapshot["sellingName"],
      mobileNumber: snapshot["mobileNumber"],
        clgName: snapshot['clgName']
    );
}
  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "email": email,
        "photoUrl": photoUrl,
        "bio": bio,
        "followers": followers,
        "following": following,
        "sellingName":sellingName,
         "mobileNumber":mobileNumber,
        "clgName":clgName
      };
}
