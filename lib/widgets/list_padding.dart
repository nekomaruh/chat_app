import 'package:flutter/material.dart';

class ListPadding extends StatelessWidget {
  final child;
  ListPadding({@required this.child});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: _setWidthPadding(width)),
      child: child,
    );
  }

  _setWidthPadding(double value) {
    if (value < 550) {
      return 20.0;
    } else if (value < 700) {
      return 60.0;
    } else if (value < 850) {
      return 120.0;
    } else {
      return value / 4;
    }
  }
}
