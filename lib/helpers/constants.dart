import 'package:auto_animated/auto_animated.dart';
import 'package:flutter/material.dart';

// const grey = Color(0xffbec4cc);
const grey = Color(0xffe3e4e8);
const orange = Color(0xfff8530d);

final options = LiveOptions(
  delay: Duration(seconds: 1),
  showItemInterval: Duration(milliseconds: 100),
  showItemDuration: Duration(seconds: 1),
  visibleFraction: 0.05,
  reAnimateOnVisibility: false,
);
