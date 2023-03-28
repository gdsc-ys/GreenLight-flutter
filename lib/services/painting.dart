import 'package:flutter/material.dart';
import 'dart:math';


double deg2rad(double deg) => deg * pi / 180;

double rad2deg(double rad) => rad * 180 / pi;

class PainterView extends CustomPainter {
  final double borderThickness;
  final double degree;
  final Color borderColor;

  PainterView({
    required this.degree,
    required this.borderThickness,
    required this.borderColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    Paint ratioPaint = Paint()
      ..color = borderColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderThickness;

    canvas.drawArc(
        Rect.fromCenter(center: center, width: size.width, height: size.height),
        deg2rad(270),
        deg2rad(degree),
        false,
        ratioPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
