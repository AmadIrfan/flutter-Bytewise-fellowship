import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_instagram/model_view/firestore_methods.dart';
import 'package:flutter_instagram/model_view/provider/user_provider.dart';
import 'package:flutter_instagram/res/colors.dart';
import 'package:flutter_instagram/view/splash_view.dart';
import 'package:provider/provider.dart';

import './model_view/model/auth_methods.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthMethods(),
        ),
        ChangeNotifierProvider(
          create: (context) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => FireStoreMethost(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Instagram',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: mobileBgColor,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
