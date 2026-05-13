import 'package:flutter/material.dart';
import 'package:own_holiday_app/utils/app_colors.dart';
import 'dart:math' as math;

class AdvancedLoader extends StatefulWidget {
  final double size;
  const AdvancedLoader({super.key, this.size = 60});

  @override
  State<AdvancedLoader> createState() => _AdvancedLoaderState();
}

class _AdvancedLoaderState extends State<AdvancedLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: _QuantumPainter(
              progress: _controller.value,
              color: AppColors.primaryYellow,
            ),
          );
        },
      ),
    );
  }
}

class _QuantumPainter extends CustomPainter {
  final double progress;
  final Color color;

  _QuantumPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    // Draw 3 orbital rings
    for (int i = 0; i < 3; i++) {
      final rotation = (progress * 2 * math.pi) + (i * math.pi / 3);
      final scale = 0.5 + 0.5 * math.sin(progress * 2 * math.pi + i);
      
      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(rotation);
      
      final rect = Rect.fromCenter(
        center: Offset.zero,
        width: size.width * (0.6 + i * 0.2),
        height: size.height * 0.3,
      );
      
      canvas.drawOval(
        rect,
        paint..color = color.withOpacity(0.3 + 0.2 * i),
      );

      // Draw an electron
      final electronPaint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;
      
      final angle = progress * 2 * math.pi;
      final electronX = (rect.width / 2) * math.cos(angle);
      final electronY = (rect.height / 2) * math.sin(angle);
      
      canvas.drawCircle(Offset(electronX, electronY), 4, electronPaint);
      
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
