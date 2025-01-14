import 'package:flutter/material.dart';

class TCustomCurvedEdges extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height);

    final firstCuve = Offset(0, size.height - 20);
    final lastCuve = Offset(30, size.height - 20);
    path.quadraticBezierTo(
        firstCuve.dx, firstCuve.dy, lastCuve.dx, lastCuve.dy);

    final seconfFirstCuve = Offset(0, size.height - 20);
    final seconfLastCuve = Offset(size.width + 30, size.height - 20);
    path.quadraticBezierTo(seconfFirstCuve.dx, seconfFirstCuve.dy,
        seconfLastCuve.dx, seconfLastCuve.dy);

    final thirdFirstCuve = Offset(size.width, size.height - 20);
    final thirdLastCuve = Offset(size.width, size.height);
    path.quadraticBezierTo(thirdFirstCuve.dx, thirdFirstCuve.dy,
        thirdLastCuve.dx, thirdLastCuve.dy);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
