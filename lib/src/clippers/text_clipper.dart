import 'package:flutter/widgets.dart';
import 'package:peel_widget/src/utils/utils.dart';

class TextClipper extends CustomClipper<Path> {
  final double dragPerc;
  const TextClipper({
    required this.dragPerc,
  });
  @override
  getClip(Size size) {
    return Path()
      ..addRect(
        Rect.fromLTRB(
          size.width * dragPerc,
          0,
          Utils().stickerLeading(size.width, dragPerc) - 8,
          size.height,
        ),
      );
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) => true;
}
