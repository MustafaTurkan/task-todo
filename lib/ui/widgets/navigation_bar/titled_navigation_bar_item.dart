import 'package:flutter/material.dart';

class TitledNavigationBarItem {
  TitledNavigationBarItem({
    @required this.icon,
    @required this.title,
    this.backgroundColor = Colors.white,
  });
   final Color backgroundColor;
   final Widget title;
   final IconData icon;
 
}
