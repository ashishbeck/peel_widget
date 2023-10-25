import 'package:flutter/material.dart';
import 'package:peel_widget/src/utils/utils.dart';

class UndersidePainter extends CustomPainter {
  final Color color;
  final double dragPerc;
  final double radius;
  final String text;
  final TextStyle textStyle;
  UndersidePainter({
    required this.color,
    required this.dragPerc,
    required this.radius,
    required this.text,
    required this.textStyle,
  });
  @override
  void paint(Canvas canvas, Size size) {
    final gradient = LinearGradient(
      colors: [
        color.withRed((color.red + 50).clamp(0, 255)),
        color,
        color
            .withRed((color.red + 40).clamp(0, 255))
            .withGreen((color.green + 40).clamp(0, 255)),
      ],
      stops: const [0, 0.2, 1.5],
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
