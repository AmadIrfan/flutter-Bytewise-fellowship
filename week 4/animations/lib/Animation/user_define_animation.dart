import 'package:flutter/material.dart';

class UserDefineAnimation extends StatefulWidget {
  const UserDefineAnimation({Key? key}) : super(key: key);

  @override
  State<UserDefineAnimation> createState() => _UserDefineAnimationState();
}

class _UserDefineAnimationState extends State<UserDefineAnimation>
    with TickerProviderStateMixin {
  bool onClicked = false;
  late final Animation _curve;
  late final Animation colorAnimation;
  late final AnimationController controller;
  late final Animation sizeAnimate;
  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 200,
      ),
    );
    _curve = CurvedAnimation(
      parent: controller,
      curve: Curves.bounceIn,
    );
    sizeAnimate = TweenSequence(<TweenSequenceItem<double>>[
      TweenSequenceItem<double>(
        tween: Tween(begin: 50, end: 70),
        weight: 50,
      ),
      TweenSequenceItem<double>(
        tween: Tween(begin: 70, end: 50),
        weight: 50,
      ),
    ]).animate(controller);
    // sizeAnimate = Tween<double>(
    //   begin: 30.0,
    //   end: 60.0,
    // ).animate(controller);
    colorAnimation = ColorTween(
      begin: Colors.grey,
      end: Colors.red,
    ).animate(controller);
    controller.addListener(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: AnimatedBuilder(
                animation: controller,
                builder: (context, _) {
                  return IconButton(
                    onPressed: () {
                      onClicked = !onClicked;
                      if (onClicked) {
                        controller.forward();
                      } else {
                        controller.reverse();
                      }

                      setState(() {});
                    },
                    icon: Icon(
                      Icons.favorite,
                      color: colorAnimation.value,
                      size: sizeAnimate.value,
                    ),
                  );
                }),
          ),
          // Center(
          //   child: IconButton(
          //     onPressed: () {
          //       onClicked = !onClicked;
          //       setState(() {});
          //     },
          //     icon: onClicked
          //         ? const Icon(
          //             Icons.help_rounded,
          //             size: 70,
          //           )
          //         : const Icon(
          //             Icons.help_outline,
          //             size: 70,
          //           ),
          //   ),
          // ),
        ],
      ), //  Center(
      //   child: ElevatedButton(
      //     onPressed: () {},
      //     child:Icon
      //   ),
      // ),
    );
  }
}
