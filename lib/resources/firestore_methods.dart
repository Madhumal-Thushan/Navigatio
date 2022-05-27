import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:navigatio/models/post.dart';
import 'package:navigatio/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';
import 'package:navigatio/models/event.dart';
import 'package:navigatio/models/gear.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // upload post
  Future<String> uploadPost(
    String discription,
    Uint8List file,
    String uid,
    String username,
    String profImage,
  ) async {
    String res = "some error comes up";
    try {
      String photoUrl = await StorageMethods()
          .uploadImageToStorage('Posts', file, true, false, false);

      String postId = const Uuid().v1();

      Post post = Post(
        discription: discription,
        uid: uid,
        username: username,
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profImage: profImage,
        likes: [],
      );
      _firestore.collection('posts').doc(postId).set(
            post.toJson(),
          );
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  //Upload Event
  Future<String> uploadEvent(
    String discription,
    Uint8List file,
    String uid,
    String username,
    String profImage,
  ) async {
    String res = "some error comes up";
    try {
      String photoUrl = await StorageMethods()
          .uploadImageToStorage('Events', file, false, true, false);

      String eventId = const Uuid().v1();

      Event event = Event(
        discription: discription,
        uid: uid,
        username: username,
        eventId: eventId,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profImage: profImage,
        likes: [],
      );
      _firestore.collection('events').doc(eventId).set(
            event.toJson(),
          );
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> uploadCampingItem(
    String discription,
    String name,
    Uint8List file,
    String uid,
    String username,
    String profImage,
  ) async {
    String res = "some error comes up";
    try {
      String photoUrl = await StorageMethods()
          .uploadImageToStorage('CampingGears', file, false, false, true);

      String gearId = const Uuid().v1();

      CampingGear gear = CampingGear(
        discription: discription,
        name: name,
        uid: uid,
        username: username,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profImage: profImage,
        likes: [],
        gearId: gearId,
      );
      _firestore.collection('camping gears').doc(gearId).set(
            gear.toJson(),
          );
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Like Post
  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      print(
        e.toString(),
      );
    }
  }

  //Like Event
  Future<void> likeEvent(String eventId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection('events').doc(eventId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        await _firestore.collection('events').doc(eventId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      print(
        e.toString(),
      );
    }
  }

  Future<void> likeItems(String itemId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection('camping gears').doc(itemId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        await _firestore.collection('camping gears').doc(itemId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      print(
        e.toString(),
      );
    }
  }

  //Post's comment
  Future<void> postComment(String postId, String text, String uid, String name,
      String profilepic) async {
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilepic': profilepic,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
        });
      } else {
        print("text is empty");
      }
    } catch (e) {
      print(
        e.toString(),
      );
    }
  }

  //Event's Comment
  Future<void> eventComment(String eventId, String text, String uid,
      String name, String profilepic) async {
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();
        await _firestore
            .collection('events')
            .doc(eventId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilepic': profilepic,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
        });
      } else {
        print("text is empty");
      }
    } catch (e) {
      print(
        e.toString(),
      );
    }
  }

  // deleting the post
  Future<void> deletePost(String postId) async {
    try {
      await _firestore.collection('posts').doc(postId).delete();
    } catch (e) {
      print(e.toString());
    }
  }

  // deleting the Event
  Future<void> deleteEvent(String eventId) async {
    try {
      await _firestore.collection('events').doc(eventId).delete();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> followUser(String uid, String followId) async {
    try {
      DocumentSnapshot snap =
          await _firestore.collection('users').doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];

      if (following.contains(followId)) {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid]),
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId]),
        });
      } else {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid]),
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId]),
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
