import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String discription;
  final String uid;
  final String username;
  final String eventId;
  final datePublished;
  final String postUrl;
  final String profImage;
  final likes;

  const Event({
    required this.discription,
    required this.uid,
    required this.username,
    required this.eventId,
    required this.datePublished,
    required this.postUrl,
    required this.profImage,
    required this.likes,
  });

  Map<String, dynamic> toJson() => {
        "discription": discription,
        "uid": uid,
        "username": username,
        "eventId": eventId,
        "datePublished": datePublished,
        "postUrl": postUrl,
        "profImage": profImage,
        "likes": likes,
      };

  static Event fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Event(
      discription: snapshot['discription'],
      uid: snapshot['uid'],
      username: snapshot['username'],
      eventId: snapshot['eventId'],
      datePublished: snapshot['datePublished'],
      postUrl: snapshot['postUrl'],
      profImage: snapshot['profImage'],
      likes: snapshot['likes'],
    );
  }
}
