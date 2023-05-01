import 'package:flutter/material.dart';

class BuiltInAnimation extends StatefulWidget {
  const BuiltInAnimation({Key? key}) : super(key: key);

  @override
  State<BuiltInAnimation> createState() => _BuiltInAnimationState();
}

class _BuiltInAnimationState extends State<BuiltInAnimation> {
  Color color = Colors.red;
  double height = 50;
  double ops = 0.0;
  AlignmentGeometry alg = Alignment.topLeft;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
              ),
              onPressed: () {
                if (color == Colors.red) {
                  height = 100;
                  color = Colors.green;
                  ops = 1.0;
                } else {
                  height = 50;
                  color = Colors.red;
                  ops = 0.0;
                }
                setState(() {});
              },
              child: const Text('Animate'),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          AnimatedContainer(
            margin: const EdgeInsets.all(10),
            duration: const Duration(
              seconds: 2,
            ),
            alignment: Alignment.center,
            color: color,
            height: height,
            width: 50,
            child: const Text('Welcome'),
          ),
          const SizedBox(
            height: 20,
          ),
          AnimatedOpacity(
            duration: const Duration(seconds: 2),
            opacity: ops,
            child: AnimatedContainer(
              duration: const Duration(seconds: 2),
              margin: const EdgeInsets.all(10),
              alignment: Alignment.center,
              color: color,
              height: height,
              width: 50,
              child: const Text('To ByteWise Flutter FellowShip '),
            ),
          ),
          AnimatedAlign(
            alignment: alg,
            duration: const Duration(seconds: 2),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onHover: (v) {
                  if (v) {
                    if (alg == Alignment.topLeft) {
                      alg = Alignment.topRight;
                    } else {
                      alg = Alignment.topLeft;
                    }
                  }
                  setState(() {});
                },
                onPressed: () {
                  // setState(() {});
                  // alg = Alignment.topRight;
                },
                child: const Text('Animate'),
              ),
            ),
          ),
          // AnimatedSize(
          //   duration: Duration(seconds: 2),
          //   child: Text('Amad'),
          // ),
        ],
      ),
    );
  }
}
