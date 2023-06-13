import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Auth/log_in.dart';
import '../Utils/theme_changer.dart';
import 'my_home_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    Timer(
      const Duration(
        seconds: 3,
      ),
      () {
        if (_auth.currentUser == null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const LogIn(),
            ),
          );
        } else {
          //    print(_auth.currentUser!.emailVerified);
          // if (!_auth.currentUser!.emailVerified) {
          //   Navigator.pushReplacement(
          //     context,
          //     MaterialPageRoute(
          //       builder: (context) => const VerifyEmail(),
          //     ),
          //   );
          // } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const MyHomePage(),
            ),
          );
          // }
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<ThemeChanger>(
      context,
      listen: false,
    ).setTheme();
    return const Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 100,
                foregroundColor: Colors.green,
                child: Image(
                  image: AssetImage(
                    'Assets/Logo/logo.png',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Text(
                'My Blog App',
                style: TextStyle(
                  fontSize: 30,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
