import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../models/monthly_flower.dart';
import 'monthly_plant_painter.dart';

/// テンプレート：各月のCustomPainterはこの形式で実装してください
/// 使用例：plant_painter_jan.dartなど
class PlantPainterTemplate extends MonthlyPlantPainter {
  PlantPainterTemplate({
    required int level,
    required MonthlyFlower flower,
  }) : super(level: level, flower: flower);

  @override
  void drawFlowerBase(Canvas canvas, Size size) {
    // 茎や葉の描画
    final paint = Paint()
      ..color = flower.primaryColors[0]
      ..style = PaintingStyle.fill
      ..strokeWidth = 2;

    // 例：茎を描く
    canvas.drawLine(
      Offset(size.width / 2, size.height),
      Offset(size.width / 2, size.height * 0.5),
      paint,
    );
  }

  @override
  void drawFlowerPetals(Canvas canvas, Size size) {
    // 花びら描画
    final paint = Paint()
      ..color = flower.accentColors[0]
      ..style = PaintingStyle.fill;

    final petalCount = 5 + level;
    final baseRadius = size.width * 0.1;

    for (int i = 0; i < petalCount; i++) {
      final angle = (i * 360 / petalCount) * math.pi / 180;
      final x = size.width / 2 + baseRadius * math.cos(angle);
      final y = size.height * 0.5 + baseRadius * math.sin(angle);

      canvas.drawCircle(
        Offset(x, y),
        size.width * 0.06,
        paint,
      );
    }
  }

  @override
  void drawFlowerCenter(Canvas canvas, Size size) {
    // 花の中心
    final paint = Paint()
      ..color = Colors.yellow
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.width / 2, size.height * 0.5),
      size.width * 0.05,
      paint,
    );
  }

  @override
  void drawGrowthStage(Canvas canvas, Size size) {
    // レベルに応じた追加表現
    if (level >= 5) {
      final paint = Paint()
        ..color = Colors.white.withOpacity(0.3)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(size.width / 2, size.height * 0.5),
        size.width * 0.15,
        paint,
      );
    }
  }
}
