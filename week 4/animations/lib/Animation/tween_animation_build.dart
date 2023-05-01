import 'package:flutter/material.dart';

class TweenAnimationBuild extends StatefulWidget {
  const TweenAnimationBuild({super.key});

  @override
  State<TweenAnimationBuild> createState() => _TweenAnimationBuildState();
}

class _TweenAnimationBuildState extends State<TweenAnimationBuild> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: 1),
              duration: const Duration(seconds: 3),
              curve: Curves.ease,
              builder: (context, double dS, _) => TweenAnimationBuilder(
                duration: const Duration(seconds: 3),
                tween: ColorTween(begin: Colors.amber, end: Colors.red),
                builder: (_, Color? dc, a) => ColorFiltered(
                  colorFilter: ColorFilter.mode(dc!, BlendMode.modulate),
                  child: Icon(
                    Icons.star,
                    size: dS * 100,
                    color: dc,
                  ),
                ),
              ),
            ),
            TweenAnimationBuilder(
                tween: Tween<double>(begin: 0, end: 1),
                duration: const Duration(seconds: 2),
                curve: Curves.bounceIn,
                builder: (_, double d, c) {
                  return Text(
                    'Amad Irfan',
                    style: TextStyle(
                      fontSize: d * 20,
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }
}
