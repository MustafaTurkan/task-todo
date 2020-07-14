import 'package:flutter/material.dart';

class FormFieldPadding extends StatelessWidget {
  const FormFieldPadding({Key key, @required this.child}) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(
          right: 10,
          left: 10,
          top: 5,
          bottom: 5,
        ),
        child: child);
  }
}
