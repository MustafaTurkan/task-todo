import 'package:flutter/material.dart';
import 'package:animations/animations.dart';

class FadeScaleTransaction extends StatefulWidget {
  FadeScaleTransaction({Key key, this.child}) : super(key: key);
  final Widget child;
  @override
  _FadeScaleTransactionState createState() => _FadeScaleTransactionState();
}

class _FadeScaleTransactionState extends State<FadeScaleTransaction> with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      value: 0,
      duration: const Duration(milliseconds: 300),
      reverseDuration: const Duration(milliseconds: 0),
      vsync: this,
    )..addStatusListener((AnimationStatus status) {
        setState(() {});
      });
    _controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext context, Widget child) {
          return FadeScaleTransition(
            animation: _controller,
            child: widget.child,
          );
        },
      ),
    );
  }
}
