import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:estella/core/theme/app_colors.dart';
import 'package:estella/core/theme/app_theme.dart';

class Loader extends StatefulWidget {
  Loader({ this.color, this.backgroundColor, this.value, this.strokeWidth,});

  Color? color;
  Color? backgroundColor;
  double? value;
  double? strokeWidth;

  @override
  State<Loader> createState() => _LoaderState();
}

class _LoaderState extends State<Loader> {
  @override
  Widget build(BuildContext context) {
    return SlowCircularProgressIndicator(
      value: widget.value,
      backgroundColor: widget.backgroundColor??Colors.white,
      color: widget.color??AppColors.primary,
      strokeWidth: widget.strokeWidth??3.0,
    );
  }
}


class SlowCircularProgressIndicator extends StatefulWidget {
  final double? value;
  final Color? backgroundColor;
  final Color? color;
  final double strokeWidth;
  final Duration duration;

  const SlowCircularProgressIndicator({
    Key? key,
    this.value,
    this.backgroundColor,
    this.color,
    required this.strokeWidth,
    this.duration = const Duration(seconds: 5), // Add duration for slower animation
  }) : super(key: key);

  @override
  _SlowCircularProgressIndicatorState createState() => _SlowCircularProgressIndicatorState();
}

class _SlowCircularProgressIndicatorState extends State<SlowCircularProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration, // Set the duration to make it slower
    )..repeat();
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
        return CircularProgressIndicator(
          value: widget.value,
          strokeCap: StrokeCap.round,
          backgroundColor: widget.backgroundColor ?? Color(0xffF1F7FF),
          color: widget.color ?? Theme.of(context).primaryColor,
          strokeWidth: widget.strokeWidth,
          valueColor: AlwaysStoppedAnimation<Color>(widget.color ?? Theme.of(context).primaryColor),
        );
      },
    );
  }
}
