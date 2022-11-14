
import 'package:eduk/screens/fav_screen.dart';
import 'package:eduk/screens/profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../screens/add_post_screen.dart';
import '../screens/feed_screen.dart';
import '../screens/search_screen.dart';
import '../widgets/alert_box.dart';

const webScreenSize = 600;

List<Widget> homeScreenItems = [
  const FeedScreen(),
  const SearchScreen(),
  const AddPostScreen(),
  const Fav_Screen(),

  ProfileScreen(
    uid: FirebaseAuth.instance.currentUser!.uid,)
];
