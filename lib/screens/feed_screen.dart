import 'package:flutter/material.dart';
import 'package:navigatio/utils/colors.dart';
import 'package:navigatio/widgets/post_card.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        centerTitle: true,
        title: Image(
          image: AssetImage('assets/navigatio5.png'),
          height: 32,
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.chat),
          )
        ],
      ),
      body: const PostCard(),
    );
  }
}
