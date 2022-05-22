import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:navigatio/providers/user_provider.dart';
import 'package:navigatio/resources/firestore_methods.dart';
import 'package:navigatio/utils/colors.dart';
import 'package:navigatio/widgets/comment_card.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';

class EventCommentsScreen extends StatefulWidget {
  final snap;

  const EventCommentsScreen({Key? key, required this.snap}) : super(key: key);

  @override
  _EventCommentsScreenState createState() => _EventCommentsScreenState();
}

class _EventCommentsScreenState extends State<EventCommentsScreen> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: const Text("Comments"),
        centerTitle: false,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('events')
            .doc(widget.snap['eventId'])
            .collection('comments')
            .orderBy('datePublished', descending: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: const CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: (snapshot.data! as dynamic).docs.length,
            itemBuilder: (context, index) => CommentCard(
              snap: (snapshot.data! as dynamic).docs[index].data(),
            ),
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: kToolbarHeight,
          margin:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          padding: const EdgeInsets.only(
            left: 16,
            right: 8,
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(
                  user.photoUrl,
                ),
                radius: 18,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 8),
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                        hintText: 'Comment as ${user.username}',
                        border: InputBorder.none),
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  await FirestoreMethods().eventComment(
                    widget.snap['eventId'],
                    _commentController.text,
                    user.uid,
                    user.username,
                    user.photoUrl,
                  );
                  setState(() {
                    _commentController.text = "";
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: const Text(
                    'Post',
                    style: TextStyle(
                      color: Color(0xFF46B7F1),
                      fontSize: 17,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
