import 'dart:math';
import 'package:flutter/material.dart';

class Capturer extends StatelessWidget {
  static final Random random = Random();

  final GlobalKey<OverRepaintBoundaryState> overRepaintKey;

  Widget child = null;
  Capturer({Key key, this.child, this.overRepaintKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: OverRepaintBoundary(
        key: overRepaintKey,
        child: RepaintBoundary(
            child: Container(color: Colors.white, child: child == null? Container(): child)
        ),
      ),
    );
  }
}

class OverRepaintBoundary extends StatefulWidget {
  final Widget child;

  const OverRepaintBoundary({Key key, this.child}) : super(key: key);

  @override
  OverRepaintBoundaryState createState() => OverRepaintBoundaryState();
}

class OverRepaintBoundaryState extends State<OverRepaintBoundary> {
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
