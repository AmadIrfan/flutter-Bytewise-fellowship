import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'Utils/theme_changer.dart';
import 'Windows/add_data.dart';
import 'Windows/splash_screen.dart';

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
          create: (context) => ThemeChanger(),
        ),
      ],
      child: Builder(
        builder: (context) {
          ThemeChanger theme = Provider.of<ThemeChanger>(context);
          //Provider.of<ThemeChanger>(context, listen: false).setTheme();
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'My Chat App',
            theme: ThemeData(
              brightness: Brightness.light,
              // drawerTheme: DrawerThemeData(
              //   width: 20,
              //  surfaceTintColor: Colors.blue,
              //   scrimColor: Colors.blue,
              // ),
              appBarTheme: const AppBarTheme(
                titleTextStyle: TextStyle(
                  color: Colors.blue,
                  fontSize: 30,
                ),
                iconTheme: IconThemeData(
                  color: Colors.blue,
                ),
              ),
              primarySwatch: Colors.blue,
            ),
            themeMode: theme.themeMode,
            darkTheme: ThemeData(
              primarySwatch: Colors.blue,
              brightness: Brightness.dark,
              appBarTheme: const AppBarTheme(
                titleTextStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                ),
                iconTheme: IconThemeData(
                  color: Colors.white,
                ),
              ),
            ),
            home: const SplashScreen(),
            routes: {
              MyDetails.routeName: (context) => const MyDetails(),
            },
          );
        },
      ),
    );
  }
}
