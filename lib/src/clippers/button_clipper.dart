import 'package:flutter/widgets.dart';

class ButtonClipper extends CustomClipper<Path> {
  final double rightPerc;
  final double radius;
  const ButtonClipper({
    required this.rightPerc,
    required this.radius,
  });
  @override
  getClip(Size size) {
    return Path()
      ..addRRect(
        RRect.fromLTRBAndCorners(
          0,
          0,
          size.width * rightPerc,
          size.height,
          topLeft: Radius.circular(radius),
          bottomLeft: Radius.circular(radius),
          topRight: Radius.circular(radius / 3),
          bottomRight: Radius.circular(radius / 3),
        ),
      );
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) => true;
}
