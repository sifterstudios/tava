import 'package:flutter/material.dart';

/// Brand mark: metronome triangle over a stem, drawn so it stays crisp at any size.
class TavaMark extends StatelessWidget {
  const TavaMark({
    super.key,
    this.size = 48,
    this.color,
  });

  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final paintColor = color ?? Theme.of(context).colorScheme.primary;
    return Semantics(
      label: 'Tava',
      image: true,
      child: SizedBox(
        width: size,
        height: size,
        child: CustomPaint(
          painter: _TavaMarkPainter(paintColor),
        ),
      ),
    );
  }
}

class _TavaMarkPainter extends CustomPainter {
  _TavaMarkPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final w = size.width;
    final h = size.height;

    final triangle = Path()
      ..moveTo(w * 0.18, h * 0.12)
      ..lineTo(w * 0.82, h * 0.12)
      ..lineTo(w * 0.5, h * 0.52)
      ..close();
    canvas.drawPath(triangle, paint);

    final stemWidth = w * 0.14;
    final stem = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(w * 0.5, h * 0.72),
        width: stemWidth,
        height: h * 0.34,
      ),
      Radius.circular(stemWidth * 0.2),
    );
    canvas.drawRRect(stem, paint);
  }

  @override
  bool shouldRepaint(covariant _TavaMarkPainter oldDelegate) =>
      oldDelegate.color != color;
}
