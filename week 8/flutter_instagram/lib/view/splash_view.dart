import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram/view/home_page.dart';
import 'package:flutter_instagram/view/login_view.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void initState() {
    _navigate();
    super.initState();
  }

  void _navigate() async {
    Timer(
      const Duration(
        seconds: 3,
      ),
      () {
        if (_auth.currentUser == null) {
          Navigator.of(
            context,
          ).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const LoginView(),
            ),
          );
        } else {
          Navigator.of(
            context,
          ).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const MyHomePage(),
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      resizeToAvoidBottomInset: true,
      // backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage(
                'assets/images/insta.png',
              ),
              color: Colors.purple,
            ),
            SizedBox(
              height: 24.0,
            ),
            // const    Text(
            //       'Instagram',
            //       style: TextStyle(
            //         fontSize: 24.0,
            //         fontWeight: FontWeight.bold,
            //         color: Colors.purple,
            //       ),
            //     ),
            // SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }
}
