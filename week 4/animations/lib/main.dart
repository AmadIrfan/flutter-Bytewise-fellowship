import 'package:animations/Animation/built_in_animation.dart';
import 'package:animations/Animation/user_define_animation.dart';
import 'package:flutter/material.dart';

import 'Animation/tween_animation_build.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Animation',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 1,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Animations'),
          bottom: const TabBar(
            tabs: [
              Tab(
                text: "Built in Animation",
                icon: Icon(Icons.animation),
              ),
              Tab(
                text: "Tween Animation",
                icon: Icon(Icons.animation),
              ),
              Tab(
                text: "Built in Animation",
                icon: Icon(Icons.animation),
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            BuiltInAnimation(),
            TweenAnimationBuild(),
            UserDefineAnimation(),
          ],
        ),
      ),
    );
  }
}
