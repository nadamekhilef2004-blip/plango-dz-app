import 'package:flutter/material.dart';

class FadeAnimation extends StatelessWidget {
  final double delay;
  final Widget child;
  
  const FadeAnimation(this.delay, this.child, {super.key});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: (500 + delay * 100).toInt()),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}