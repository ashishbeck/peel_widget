import 'package:flutter/material.dart';
import 'package:peel_widget/src/clippers/button_clipper.dart';
import 'package:peel_widget/src/clippers/text_clipper.dart';
import 'package:peel_widget/src/painters/dotted_painter.dart';
import 'package:peel_widget/src/painters/underside_painter.dart';
import 'package:peel_widget/src/utils/utils.dart';

class PeelWidget extends StatefulWidget {
  const PeelWidget({
    super.key,
    this.height = 56.0,
    this.radius = 16.0,
    this.hiddenMargin = 0.97,
    this.maxRevealOnDrag = 0.75,
    this.dashedBorderMargin = -8,
    this.text = 'Get Started!',
    this.color = const Color(0xFF9093FF),
    this.textStyle = const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 16,
    ),
    this.onSuccessfulPeel,
    this.duration = const Duration(milliseconds: 500),
    this.curve = Curves.easeOutCubic,
  }) : assert(
          hiddenMargin < 1 && hiddenMargin > 0,
          'The hidden margin has to be between 0 and 1',
        );

  final double height;
  final double radius;
  final double hiddenMargin;
  final double maxRevealOnDrag;
  final double dashedBorderMargin;
  final String text;
  final Color color;
  final TextStyle textStyle;
  final Duration duration;
  final Curve curve;
  final void Function()? onSuccessfulPeel;

  @override
  State<PeelWidget> createState() => _PeelWidgetState();
}

class _PeelWidgetState extends State<PeelWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  double get _hiddenMargin => widget.hiddenMargin;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      lowerBound: -0.1,
      upperBound: 0.98,
      duration: widget.duration,
    )..value = _hiddenMargin;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final utils = Utils();
    return LayoutBuilder(builder: (context, constraints) {
      final maxWidth = constraints.maxWidth;
      return ListenableBuilder(
          listenable: controller,
          builder: (context, _) {
            final stickerEdge = utils.mapRange(
              utils.stickerLeading(
                maxWidth,
                controller.value,
              ),
              0,
              maxWidth,
              -maxWidth / 2,
              maxWidth / 2,
            );
            return GestureDetector(
              onTap: () => _onTap(),
              onPanUpdate: (DragUpdateDetails details) =>
                  _onPanUpdate(details, maxWidth),
              onPanEnd: (DragEndDetails details) => _onPanEnd(details),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Base dashed border
                  CustomPaint(
                    size: Size(maxWidth, widget.height),
                    painter: DottedPainter(
                      radius: widget.radius,
                      color: Colors.black,
                      margin: widget.dashedBorderMargin,
                    ),
                  ),

                  // Button
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ClipPath(
                      clipper: ButtonClipper(
                        rightPerc: controller.value,
                        radius: widget.radius,
                      ),
                      child: Container(
                        constraints: BoxConstraints.expand(
                            height: widget.height, width: maxWidth),
                        color: widget.color,
                        child: Center(
                          child: Text(
                            widget.text,
                            style: widget.textStyle,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Shadow for Sticker
                  Transform.translate(
                    offset: Offset(
                      stickerEdge - 2,
                      0,
                    ),
                    child: Container(
                      width: 24,
                      height: widget.height,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(widget.radius),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 50,
                            blurStyle: BlurStyle.solid,
                          )
                        ],
                      ),
                    ),
                  ),

                  // Underside Widget
                  CustomPaint(
                    size: Size(maxWidth, widget.height),
                    painter: UndersidePainter(
                      color: widget.color,
                      dragPerc: controller.value * 1,
                      radius: widget.radius,
                      text: widget.text,
                      textStyle: widget.textStyle,
                    ),
                  ),

                  // Glow
                  Transform.translate(
                    offset: Offset(
                      stickerEdge + maxWidth / 2 - 8,
                      0,
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        width: maxWidth * (1 - controller.value) + 8,
                        height: widget.height,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(widget.radius),
                          boxShadow: [
                            BoxShadow(
                              color: widget.color.withOpacity(0.5),
                              blurRadius: 30,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Underside Text
                  ClipPath(
                    clipper: TextClipper(dragPerc: controller.value),
                    child: Container(
                      constraints: BoxConstraints.expand(
                          height: widget.height, width: maxWidth),
                      child: Transform.translate(
                        offset: Offset(
                          utils.mapRange(controller.value, 0, 1,
                              -maxWidth / 2 - 150, maxWidth / 2 + 120),
                          0,
                        ),
                        child: Transform.scale(
                          scaleX: 1.1,
                          child: Transform.flip(
                            flipX: true,
                            child: Center(
                                child: Text(
                              widget.text,
                              style: widget.textStyle,
                            )),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Hint Arrow
                  Opacity(
                    opacity: utils
                        .mapRange(controller.value, 0.85, _hiddenMargin, 0, 1)
                        .clamp(0, 1),
                    child: Transform.translate(
                        offset: Offset(
                          stickerEdge - 32,
                          0,
                        ),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        )),
                  )
                ],
              ),
            );
          });
    });
  }

  _onTap() async {
    const duration = Duration(milliseconds: 400);
    await controller.animateTo(
      _hiddenMargin * 0.95,
      duration: duration,
      curve: Curves.easeOut,
    );
    await controller.animateTo(
      _hiddenMargin,
      duration: duration,
      curve: Curves.easeIn,
    );
  }

  Future<void> _onPanEnd(DragEndDetails details) async {
    final isFlick = details.velocity.pixelsPerSecond.dx.isNegative;
    final isValidRelease = controller.value < 0.4;
    if (isFlick || isValidRelease) {
      await controller.animateTo(
        -0.1,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
      );
      if (widget.onSuccessfulPeel != null) widget.onSuccessfulPeel!();
    } else {
      controller.animateTo(_hiddenMargin, curve: widget.curve);
    }
  }

  void _onPanUpdate(DragUpdateDetails details, double maxWidth) {
    final dx = details.delta.dx / maxWidth;
    final value = (controller.value + dx)
        .clamp(1 - widget.maxRevealOnDrag, _hiddenMargin);
    controller.value = value;
  }
}
