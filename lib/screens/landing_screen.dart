import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:navigatio/screens/main_event_screen.dart';
import 'package:navigatio/screens/login_screen.dart';
import 'package:navigatio/screens/signup_screen.dart';
import 'package:navigatio/utils/colors.dart';
import 'package:slidable_button/slidable_button.dart';

class LandingScreen extends StatefulWidget {
  @override
  _LandingState createState() => _LandingState();
}

class _LandingState extends State<LandingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Image(
                  image: AssetImage('assets/hiker.png'),
                  height: 100.0,
                ),
              ),
            ),
            Text(
              'N A V i G A T i O ',
              style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.w900,
                fontFamily: 'Ubuntu-Regular',
              ),
            ),
            SizedBox(
              height: 100,
            ),
            SlidableButton(
              height: 50,
              width: MediaQuery.of(context).size.width / 1.5,
              buttonWidth: 60.0,
              color: Color(0xFFC6DCE3),
              buttonColor: mobileBackgroundColor,
              dismissible: false,
              label: Center(child: Text('Events')),
              onChanged: (SlidableButtonPosition value) {
                Navigator.of(context).pushReplacement(
                  CupertinoPageRoute(
                    builder: (_) => MainEventScreen(),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(''),
                    Text(
                      'Slide to Events',
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0.0,
        color: mobileBackgroundColor,
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushReplacement(
                    CupertinoPageRoute(
                      builder: (_) => LoginScreen(),
                    ),
                  );
                },
                child: Container(
                  height: 45.0,
                  width: 130.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40.0),
                    border: Border.all(color: Colors.grey),
                    color: mobileBackgroundColor,
                  ),
                  child: Center(
                    child: Text(
                      'LOGIN',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushReplacement(
                      CupertinoPageRoute(builder: (_) => SignupScreen()));
                },
                child: Container(
                  height: 45.0,
                  width: 130.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40.0),
                    border: Border.all(color: Colors.white),
                    color: mobileBackgroundColor,
                  ),
                  child: Center(
                    child: Text(
                      'SIGN UP',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
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
