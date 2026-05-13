import 'package:flutter/material.dart';
import 'dart:math' as math;

/// A custom painter that draws animated sun rays / sparkle around the logo
class SunRayPainter extends CustomPainter {
  final double progress; // 0.0 → 1.0
  final Color color;

  SunRayPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..color = color.withOpacity((1 - progress) * 0.8)
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    const rayCount = 12;
    const innerRadius = 90.0;
    const outerRadius = 140.0;

    for (int i = 0; i < rayCount; i++) {
      final angle = (2 * math.pi / rayCount) * i + (progress * math.pi);
      final start = Offset(
        center.dx + innerRadius * math.cos(angle),
        center.dy + innerRadius * math.sin(angle),
      );
      final end = Offset(
        center.dx + (innerRadius + (outerRadius - innerRadius) * progress) * math.cos(angle),
        center.dy + (innerRadius + (outerRadius - innerRadius) * progress) * math.sin(angle),
      );
      canvas.drawLine(start, end, paint);
    }
  }

  @override
  bool shouldRepaint(SunRayPainter old) =>
      old.progress != progress || old.color != color;
}

/// Animated wave painter for the bottom of the splash screen
class WavePainter extends CustomPainter {
  final double wavePhase;
  final Color color;
  final double amplitude;

  WavePainter({required this.wavePhase, required this.color, required this.amplitude});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height * 0.6);

    for (double x = 0; x <= size.width; x++) {
      final y = size.height * 0.6 +
          amplitude * math.sin((x / size.width * 2 * math.pi) + wavePhase);
      path.lineTo(x, y);
    }

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(WavePainter old) =>
      old.wavePhase != wavePhase || old.amplitude != amplitude;
}
