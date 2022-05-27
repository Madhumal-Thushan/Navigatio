import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:navigatio/screens/add_camping_gear_screen.dart';

import '../utils/colors.dart';
import '../widgets/camping_gear_card.dart';
import 'landing_screen.dart';

class CampingGearScreen extends StatefulWidget {
  const CampingGearScreen({Key? key}) : super(key: key);

  @override
  _CampingGearScreenState createState() => _CampingGearScreenState();
}

class _CampingGearScreenState extends State<CampingGearScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddCampingGearScreen()),
              );
            },
            icon: Icon(Icons.add),
          )
        ],
        backgroundColor: mobileBackgroundColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              CupertinoPageRoute(
                builder: (_) => LandingScreen(),
              ),
            );
          },
        ),
      ),
      body: StreamBuilder(
        stream:
            FirebaseFirestore.instance.collection('camping gears').snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) => GearItemCard(
              snap: snapshot.data!.docs[index].data(),
            ),
          );
        },
      ),
    );
  }
}
