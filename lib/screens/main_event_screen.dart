import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:navigatio/screens/camping_gear_screen.dart';
import 'package:navigatio/screens/event_screen.dart';
import 'package:navigatio/screens/map_show_screen.dart';
import 'package:navigatio/screens/profile_screen.dart';

import '../utils/colors.dart';
import 'landing_screen.dart';

class MainEventScreen extends StatefulWidget {
  const MainEventScreen({Key? key}) : super(key: key);

  @override
  State<MainEventScreen> createState() => _MainEventScreenState();
}

class _MainEventScreenState extends State<MainEventScreen> {
  List pages = [
    EventScreen(),
    MapScreen(),
    CampingGearScreen(),
  ];

  int currentIndex = 0;
  void onTap(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: mobileBackgroundColor,
        onTap: onTap,
        currentIndex: currentIndex,
        selectedItemColor: blueColor,
        unselectedItemColor: Colors.grey.withOpacity(0.5),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        elevation: 0,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Event',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on_outlined),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore_outlined),
            label: 'Gears',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'profile',
          ),
        ],
      ),
      appBar: AppBar(
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
    );
  }
}
