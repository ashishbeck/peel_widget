import 'package:flutter/material.dart';
import 'package:peel_widget/src/utils/utils.dart';

class UndersidePainter extends CustomPainter {
  final double dragPerc;
  final double radius;
  final String text;
  final TextStyle textStyle;
  UndersidePainter({
    required this.dragPerc,
    required this.radius,
    required this.text,
    required this.textStyle,
  });
  @override
  void paint(Canvas canvas, Size size) {
    const gradient = LinearGradient(
      colors: [
        Color.fromARGB(255, 192, 144, 255),
        Color.fromARGB(255, 144, 147, 245),
        Color.fromARGB(255, 185, 187, 255),
      ],
      stops: [0, 0.2, 1.5],
    );
    const heightIncrease = 6;
    final rect = Rect.fromLTRB(
      size.width * dragPerc,
      -(1 - dragPerc) * heightIncrease,
      Utils().stickerLeading(size.width, dragPerc) - 8,
      size.height + heightIncrease * (1 - dragPerc),
    );
    final paint = Paint()..shader = gradient.createShader(rect);
    final path = Path()
      ..addRRect(
        RRect.fromRectAndCorners(
          rect,
          topLeft: Radius.circular(radius),
          bottomLeft: Radius.circular(radius),
          topRight: Radius.circular(radius / 3),
          bottomRight: Radius.circular(radius / 3),
        ),
      );
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
