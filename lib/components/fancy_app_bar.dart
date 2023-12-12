import 'package:flutter/material.dart';
import 'package:flutter_seenickcode_one/styles.dart';

class FancyAppBar extends AppBar {
  @override
  final Widget title =
      Text("Tourism & Co.".toUpperCase(), style: Styles.navBarTitle);

  @override
  final IconThemeData iconTheme = IconThemeData(color: Colors.black);

  @override
  final Color backgroundColor = Colors.white;

  @override
  final bool centerTitle = true;

  @override
  final double elevation = 0.5;
}
