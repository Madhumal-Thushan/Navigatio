import 'package:flutter/material.dart';

import '../screens/add_post_screen.dart';
import '../screens/feed_screen.dart';

const webScreenSize = 600;

const HomeScreenItems = [
  FeedScreen(),
  Text("Search"),
  AddPostScreen(),
  Text("Notifi"),
  Text("Profile"),
];
