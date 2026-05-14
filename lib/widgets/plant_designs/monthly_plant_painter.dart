import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../models/monthly_flower.dart';

abstract class MonthlyPlantPainter extends CustomPainter {
  final int level;
  final MonthlyFlower flower;

  MonthlyPlantPainter({
    required this.level,
    required this.flower,
  });

  @override
  bool shouldRepaint(MonthlyPlantPainter oldDelegate) {
    return oldDelegate.level != level || oldDelegate.flower.month != flower.month;
  }

  @override
  bool shouldRebuildSemantics(MonthlyPlantPainter oldDelegate) {
    return oldDelegate.level != level;
  }

  void drawFlowerBase(Canvas canvas, Size size);

  void drawFlowerPetals(Canvas canvas, Size size);

  void drawFlowerCenter(Canvas canvas, Size size);

  void drawGrowthStage(Canvas canvas, Size size) {
    // ステージに応じた描画の追加処理
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));

    drawFlowerBase(canvas, size);
    drawFlowerPetals(canvas, size);
    drawFlowerCenter(canvas, size);
    drawGrowthStage(canvas, size);
  }
}

class MonthlyPlantPainterFactory {
  static MonthlyPlantPainter createPainter({
    required int month,
    required int level,
  }) {
    final flower = MonthlyFlowerRepository.getFlowerByMonth(month);

    // 月別のPainterを返す（後で実装）
    // 今は仮のPainterを返す
    return DefaultMonthlyPlantPainter(level: level, flower: flower);
  }
}

class DefaultMonthlyPlantPainter extends MonthlyPlantPainter {
  DefaultMonthlyPlantPainter({
    required int level,
    required MonthlyFlower flower,
  }) : super(level: level, flower: flower);

  @override
  void drawFlowerBase(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = flower.primaryColors[0]
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.width / 2, size.height * 0.7),
      size.width * 0.08,
      paint,
    );
  }

  @override
  void drawFlowerPetals(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = flower.accentColors[0]
      ..style = PaintingStyle.fill;

    final petalCount = 5 + level;
    for (int i = 0; i < petalCount; i++) {
      final angle = (i * 360 / petalCount) * 3.14159 / 180;
      final x = size.width / 2 + size.width * 0.15 * 0.7 * Math.cos(angle);
      final y = size.height * 0.7 + size.height * 0.15 * 0.7 * Math.sin(angle);

      canvas.drawCircle(Offset(x, y), size.width * 0.05, paint);
    }
  }

  @override
  void drawFlowerCenter(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.yellow
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.width / 2, size.height * 0.7),
      size.width * 0.04,
      paint,
    );
  }
}

class Math {
  static double cos(double radians) => math.cos(radians);
  static double sin(double radians) => math.sin(radians);
}
