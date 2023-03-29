import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../theme_changer.dart';
import '/Auth/auth_provider.dart';
import 'home_page.dart';
import '../auth.dart';
import 'model/product.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ProductItem(),
        ),
        ChangeNotifierProvider(
          create: (context) => ThemeChanger(),
        ),
        ChangeNotifierProvider(
          create: (context) => AuthProvider(),
        ),
      ],
      child: Builder(builder: (context) {
        final theme = Provider.of<ThemeChanger>(context);
        return MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          themeMode: theme.themeMode,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
          ),
          home: const Auth(),
        );
      }),
    );
  }
}
