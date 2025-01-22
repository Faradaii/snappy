import 'package:flutter/material.dart';
import 'dart:math';

class RotatingWidget extends StatefulWidget {
  final Widget widget;
  final double? radius;
  const RotatingWidget({super.key, required this.widget, this.radius});

  @override
  _RotatingWidgetState createState() => _RotatingWidgetState();
}

class _RotatingWidgetState extends State<RotatingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  late Animation<double> _circleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    _rotationAnimation =
        Tween<double>(begin: 0, end: 2 * pi).animate(_controller);

    _circleAnimation =
        Tween<double>(begin: 0, end: 2 * pi).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        double radius = widget.radius ?? 20;
        double dx = radius * cos(_circleAnimation.value);
        double dy = radius * sin(_circleAnimation.value);

        return Transform.translate(
          offset: Offset(dx, dy),
          child: Transform.rotate(
            angle: _rotationAnimation.value,
            child: child,
          ),
        );
      },
      child: widget.widget,
    );
  }
}
