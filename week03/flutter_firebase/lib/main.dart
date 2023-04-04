import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_firebase/widget/theme_changer.dart';
import 'package:flutter_firebase/windows/add_notes.dart';
import 'package:flutter_firebase/windows/notes_details.dart';
import 'package:provider/provider.dart';

import 'package:flutter_firebase/Splash%20Screen/splash_screen.dart';
import 'package:flutter_firebase/model/auth_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => ThemeChanger(),
        ),
      ],
      child: Builder(
        builder: (context) {
          final theme = Provider.of<ThemeChanger>(context);
          return MaterialApp(
            title: 'Flutter FireBase',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              brightness: Brightness.light,
              primarySwatch: Colors.purple,
              buttonTheme: const ButtonThemeData(
                buttonColor: Colors.white,
              ),
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
            ),
            themeMode: theme.themMode,
            home: const SplashScreen(),
            routes: {
              NotesDetails.routName: (context) => const NotesDetails(),
              AddNotes.routeName: (context) => const AddNotes(),
            },
          );
        },
      ),
    );
  }
}
