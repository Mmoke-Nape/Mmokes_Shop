import 'package:flutter/material.dart';

class AuthClipper extends CustomClipper<Path> {
  // AppClipper(
  //     {required this.cornerSize,
  //     required this.diagonalHeight,
  //     this.roundedBottom = true});

  @override
  Path getClip(Size size) {
    Path path = Path();
    // path.lineTo(size.width * .1, 0);
    path.cubicTo(size.width / 4, 3 * size.height / 4, 3 * size.width / 4,
        size.height / 4, size.width, size.height);

    // path.cubicTo(size.width / 4, 4.5 * size.height / 4, 3 * size.width / 4,
    //     size.height / 4, size.width * .9, size.height);
    // // path.conicTo(x1, y1, x2, y2, w)
    // path.lineTo(0, size.height);

    // path.cubicTo(size.width * .1, size.height * .1, size.width * .6,
    // size.height * .2, size.width * .9, size.height * .9);
    // path.quadraticBezierTo(0, 0, size.width * .4, size.height * .3);
    // path.quadraticBezierTo(
    //     size.width * .4, size.height * .3, size.width * .8, size.height * .6);
    // path.close();
    // path.lineTo(0, size.height);
    // path.lineTo(size.width, size.height);
    // path.lineTo(size.width * .2, size.height);
    // path.lineTo(0, size.height);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
