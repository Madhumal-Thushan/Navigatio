import 'package:cloud_firestore/cloud_firestore.dart';

class CampingGear {
  final String discription;
  final String name;
  final String uid;
  final String username;
  final String gearId;
  final datePublished;
  final String postUrl;
  final String profImage;
  final likes;

  const CampingGear({
    required this.discription,
    required this.name,
    required this.uid,
    required this.username,
    required this.gearId,
    required this.datePublished,
    required this.postUrl,
    required this.profImage,
    required this.likes,
  });

  Map<String, dynamic> toJson() => {
        "discription": discription,
        "name": name,
        "uid": uid,
        "username": username,
        "gearId": gearId,
        "datePublished": datePublished,
        "postUrl": postUrl,
        "profImage": profImage,
        "likes": likes,
      };

  static CampingGear fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return CampingGear(
      discription: snapshot['discription'],
      name: snapshot['name'],
      uid: snapshot['uid'],
      username: snapshot['username'],
      gearId: snapshot['gearId'],
      datePublished: snapshot['datePublished'],
      postUrl: snapshot['postUrl'],
      profImage: snapshot['profImage'],
      likes: snapshot['likes'],
    );
  }
}
