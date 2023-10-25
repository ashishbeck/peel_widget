import 'package:flutter/widgets.dart';
import 'package:peel_widget/src/utils/dash_path.dart';

class DottedPainter extends CustomPainter {
  final double radius;
  final Color color;
  final double margin;
  final double dashWidth; // Adjust the dash width as needed
  final double dashSpace;
  DottedPainter({
    required this.radius,
    required this.color,
    required this.margin,
    this.dashWidth = 5,
    this.dashSpace = 5,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = color;
    final rect = RRect.fromLTRBR(
        0 - margin / 2,
        0 - margin / 2,
        size.width + margin / 2,
        size.height + margin / 2,
        Radius.circular(radius));
    canvas.drawPath(
      dashPath(
        Path()..addRRect(rect),
        dashArray: CircularIntervalList<double>(
          <double>[dashWidth, dashSpace],
        ),
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
