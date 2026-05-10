import 'package:flutter/material.dart';

/// 植物系モンスターを各レベルに応じて描画するウィジェット
/// Lv0: 種（眠り中） → Lv5: 満開のモンスター王
class PlantMonsterWidget extends StatelessWidget {
  final int level;
  final double size;

  const PlantMonsterWidget({
    super.key,
    required this.level,
    this.size = 120,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _PlantMonsterPainter(level: level.clamp(0, 5)),
      ),
    );
  }
}

class _PlantMonsterPainter extends CustomPainter {
  final int level;
  _PlantMonsterPainter({required this.level});

  // カラーパレット
  static const _skinGreen   = Color(0xFF4CAF50);
  static const _darkGreen   = Color(0xFF2E7D32);
  static const _lightGreen  = Color(0xFF81C784);
  static const _soilBrown   = Color(0xFF6D4C41);
  static const _seedBrown   = Color(0xFF8D6E63);
  static const _flowerPink  = Color(0xFFFF80AB);
  static const _flowerYellow= Color(0xFFFFD740);
  static const _white       = Color(0xFFFFFFFF);
  static const _black       = Color(0xFF212121);
  static const _blush       = Color(0xFFFF8A80);

  @override
  void paint(Canvas canvas, Size size) {
    switch (level) {
      case 0: _drawSeed(canvas, size);    break;
      case 1: _drawSprout(canvas, size);  break;
      case 2: _drawYoung(canvas, size);   break;
      case 3: _drawMature(canvas, size);  break;
      case 4: _drawFlower(canvas, size);  break;
      case 5: _drawFullBloom(canvas, size); break;
    }
  }

  // ── Lv0: 種（土から丸い種、目を閉じて眠り中）──────────────────
  void _drawSeed(Canvas canvas, Size s) {
    final cx = s.width / 2;
    final cy = s.height * 0.62;

    // 土
    _drawSoil(canvas, s);

    // 種の本体
    final body = Paint()..color = _seedBrown;
    canvas.drawOval(Rect.fromCenter(center: Offset(cx, cy - 10), width: 46, height: 38), body);

    // ハイライト
    final hl = Paint()..color = _white.withOpacity(0.3);
    canvas.drawOval(Rect.fromCenter(center: Offset(cx - 8, cy - 18), width: 14, height: 10), hl);

    // 閉じた目
    final eyePaint = Paint()..color = _black..strokeWidth = 2.5..style = PaintingStyle.stroke;
    _drawClosedEye(canvas, Offset(cx - 9, cy - 10), eyePaint);
    _drawClosedEye(canvas, Offset(cx + 9, cy - 10), eyePaint);

    // zzz
    final zStyle = TextStyle(color: _lightGreen, fontSize: s.width * 0.11, fontWeight: FontWeight.bold);
    _drawText(canvas, 'z', Offset(cx + 18, cy - 30), zStyle);
    _drawText(canvas, 'z', Offset(cx + 25, cy - 40), TextStyle(color: _lightGreen, fontSize: s.width * 0.085, fontWeight: FontWeight.bold));
  }

  // ── Lv1: 芽（土から小さな芽、キョロキョロした目）────────────────
  void _drawSprout(Canvas canvas, Size s) {
    final cx = s.width / 2;

    // 土
    _drawSoil(canvas, s);

    // 茎
    final stem = Paint()..color = _darkGreen..strokeWidth = 5..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(cx, s.height * 0.72), Offset(cx, s.height * 0.44), stem);

    // 小さな葉（左）
    _drawLeaf(canvas, Offset(cx, s.height * 0.56), -0.6, 22, 12);

    // 頭（本体）
    final bodyPaint = Paint()..color = _skinGreen;
    canvas.drawCircle(Offset(cx, s.height * 0.38), 24, bodyPaint);
    _drawGreenShading(canvas, Offset(cx, s.height * 0.38), 24);

    // 目（大きくてキョロキョロ）
    _drawEye(canvas, Offset(cx - 8, s.height * 0.36), 7);
    _drawEye(canvas, Offset(cx + 8, s.height * 0.36), 7);

    // 口（小さなO型）
    final mouth = Paint()..color = _black..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(cx, s.height * 0.42), 3, mouth);
  }

  // ── Lv2: 若葉（葉2枚、笑顔）────────────────────────────────────
  void _drawYoung(Canvas canvas, Size s) {
    final cx = s.width / 2;

    // 土
    _drawSoil(canvas, s);

    // 茎
    final stem = Paint()..color = _darkGreen..strokeWidth = 6..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(cx, s.height * 0.72), Offset(cx, s.height * 0.40), stem);

    // 葉（左右）
    _drawLeaf(canvas, Offset(cx, s.height * 0.54), -0.7, 28, 14);
    _drawLeaf(canvas, Offset(cx, s.height * 0.54),  0.7, 28, 14);

    // 頭
    final bodyPaint = Paint()..color = _skinGreen;
    canvas.drawCircle(Offset(cx, s.height * 0.33), 28, bodyPaint);
    _drawGreenShading(canvas, Offset(cx, s.height * 0.33), 28);

    // 頭の上の小さな葉っぱ
    _drawLeaf(canvas, Offset(cx, s.height * 0.07), 0, 18, 10);

    // 目
    _drawEye(canvas, Offset(cx - 9, s.height * 0.31), 7);
    _drawEye(canvas, Offset(cx + 9, s.height * 0.31), 7);

    // ほっぺ
    _drawBlush(canvas, Offset(cx - 18, s.height * 0.36));
    _drawBlush(canvas, Offset(cx + 18, s.height * 0.36));

    // 笑顔
    _drawSmile(canvas, Offset(cx, s.height * 0.38), 9);
  }

  // ── Lv3: 成長（手のような葉、元気な表情）───────────────────────
  void _drawMature(Canvas canvas, Size s) {
    final cx = s.width / 2;

    // 土
    _drawSoil(canvas, s);

    // 茎
    final stem = Paint()..color = _darkGreen..strokeWidth = 7..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(cx, s.height * 0.72), Offset(cx, s.height * 0.36), stem);

    // 腕のような葉（左右に伸びる）
    _drawArmLeaf(canvas, Offset(cx - 10, s.height * 0.50), isLeft: true);
    _drawArmLeaf(canvas, Offset(cx + 10, s.height * 0.50), isLeft: false);

    // 頭
    final bodyPaint = Paint()..color = _skinGreen;
    canvas.drawCircle(Offset(cx, s.height * 0.28), 32, bodyPaint);
    _drawGreenShading(canvas, Offset(cx, s.height * 0.28), 32);

    // 頭の上の葉（2枚）
    _drawLeaf(canvas, Offset(cx - 8, s.height * 0.00), -0.3, 20, 11);
    _drawLeaf(canvas, Offset(cx + 8, s.height * 0.00),  0.3, 20, 11);

    // 目（やや大きく）
    _drawEye(canvas, Offset(cx - 10, s.height * 0.25), 8);
    _drawEye(canvas, Offset(cx + 10, s.height * 0.25), 8);

    // ほっぺ
    _drawBlush(canvas, Offset(cx - 21, s.height * 0.31));
    _drawBlush(canvas, Offset(cx + 21, s.height * 0.31));

    // 元気な口
    _drawSmile(canvas, Offset(cx, s.height * 0.33), 10);
  }

  // ── Lv4: 開花（つぼみを頭に、誇らしげ）──────────────────────────
  void _drawFlower(Canvas canvas, Size s) {
    final cx = s.width / 2;

    // 土
    _drawSoil(canvas, s);

    // 茎
    final stem = Paint()..color = _darkGreen..strokeWidth = 7..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(cx, s.height * 0.72), Offset(cx, s.height * 0.33), stem);

    // 腕（より大きく）
    _drawArmLeaf(canvas, Offset(cx - 12, s.height * 0.48), isLeft: true, size: 1.2);
    _drawArmLeaf(canvas, Offset(cx + 12, s.height * 0.48), isLeft: false, size: 1.2);

    // 頭
    final bodyPaint = Paint()..color = _skinGreen;
    canvas.drawCircle(Offset(cx, s.height * 0.26), 34, bodyPaint);
    _drawGreenShading(canvas, Offset(cx, s.height * 0.26), 34);

    // 花のつぼみ（頭の上）
    _drawBud(canvas, Offset(cx, s.height * -0.01));

    // 目（しっかりした目）
    _drawEye(canvas, Offset(cx - 11, s.height * 0.22), 8.5);
    _drawEye(canvas, Offset(cx + 11, s.height * 0.22), 8.5);

    // ほっぺ
    _drawBlush(canvas, Offset(cx - 22, s.height * 0.29));
    _drawBlush(canvas, Offset(cx + 22, s.height * 0.29));

    // 誇らしげな口
    _drawSmile(canvas, Offset(cx, s.height * 0.32), 11);
  }

  // ── Lv5: 満開（花冠をつけたモンスター王）───────────────────────
  void _drawFullBloom(Canvas canvas, Size s) {
    final cx = s.width / 2;

    // 土
    _drawSoil(canvas, s);

    // 茎（太め）
    final stem = Paint()..color = _darkGreen..strokeWidth = 9..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(cx, s.height * 0.72), Offset(cx, s.height * 0.32), stem);

    // 大きな腕
    _drawArmLeaf(canvas, Offset(cx - 14, s.height * 0.46), isLeft: true, size: 1.5);
    _drawArmLeaf(canvas, Offset(cx + 14, s.height * 0.46), isLeft: false, size: 1.5);

    // 頭
    final bodyPaint = Paint()..color = _skinGreen;
    canvas.drawCircle(Offset(cx, s.height * 0.24), 36, bodyPaint);
    _drawGreenShading(canvas, Offset(cx, s.height * 0.24), 36);

    // 満開の花（頭の上に大きな花）
    _drawFullFlower(canvas, Offset(cx, s.height * -0.02));

    // きらきらエフェクト
    _drawSparkles(canvas, s);

    // 目（自信満々）
    _drawEye(canvas, Offset(cx - 12, s.height * 0.20), 9);
    _drawEye(canvas, Offset(cx + 12, s.height * 0.20), 9);

    // ほっぺ
    _drawBlush(canvas, Offset(cx - 24, s.height * 0.27));
    _drawBlush(canvas, Offset(cx + 24, s.height * 0.27));

    // 大きな笑顔
    _drawSmile(canvas, Offset(cx, s.height * 0.30), 13);
  }

  // ── パーツ描画ヘルパー ────────────────────────────────────────

  void _drawSoil(Canvas canvas, Size s) {
    final soil = Paint()..color = _soilBrown;
    final path = Path()
      ..moveTo(0, s.height * 0.76)
      ..lineTo(s.width, s.height * 0.76)
      ..lineTo(s.width, s.height)
      ..lineTo(0, s.height)
      ..close();
    canvas.drawPath(path, soil);

    // 土の質感（砂利）
    final gravel = Paint()..color = _soilBrown.withOpacity(0.6);
    for (var i = 0; i < 5; i++) {
      canvas.drawCircle(Offset(s.width * (0.15 + i * 0.18), s.height * 0.80), 3, gravel);
    }
  }

  void _drawLeaf(Canvas canvas, Offset base, double angle, double w, double h) {
    canvas.save();
    canvas.translate(base.dx, base.dy);
    canvas.rotate(angle);
    final leaf = Paint()..color = _darkGreen;
    final path = Path()
      ..moveTo(0, 0)
      ..quadraticBezierTo(-w / 2, -h / 2, 0, -h)
      ..quadraticBezierTo(w / 2, -h / 2, 0, 0);
    canvas.drawPath(path, leaf);
    // 葉脈
    final vein = Paint()..color = _lightGreen..strokeWidth = 1..style = PaintingStyle.stroke;
    canvas.drawLine(const Offset(0, 0), Offset(0, -h * 0.8), vein);
    canvas.restore();
  }

  void _drawArmLeaf(Canvas canvas, Offset base, {required bool isLeft, double size = 1.0}) {
    canvas.save();
    canvas.translate(base.dx, base.dy);
    canvas.scale(size);
    final leaf = Paint()..color = _darkGreen;
    final path = Path();
    if (isLeft) {
      path
        ..moveTo(0, 0)
        ..quadraticBezierTo(-28, -8, -36, 4)
        ..quadraticBezierTo(-28, 16, 0, 10)
        ..close();
    } else {
      path
        ..moveTo(0, 0)
        ..quadraticBezierTo(28, -8, 36, 4)
        ..quadraticBezierTo(28, 16, 0, 10)
        ..close();
    }
    canvas.drawPath(path, leaf);
    // 葉脈
    final vein = Paint()..color = _lightGreen..strokeWidth = 1.2..style = PaintingStyle.stroke;
    canvas.drawLine(const Offset(0, 5), isLeft ? const Offset(-28, 5) : const Offset(28, 5), vein);
    canvas.restore();
  }

  void _drawBud(Canvas canvas, Offset center) {
    // 茎
    final stem = Paint()..color = _darkGreen..strokeWidth = 4..style = PaintingStyle.stroke;
    canvas.drawLine(center + const Offset(0, 16), center + const Offset(0, 4), stem);
    // つぼみ
    final bud = Paint()..color = _flowerPink;
    canvas.drawOval(Rect.fromCenter(center: center, width: 20, height: 22), bud);
    final budTip = Paint()..color = _flowerYellow;
    canvas.drawCircle(center + const Offset(0, -8), 5, budTip);
  }

  void _drawFullFlower(Canvas canvas, Offset center) {
    // 花びら（8枚）
    final petalPaint = Paint()..color = _flowerPink;
    for (int i = 0; i < 8; i++) {
      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(i * 3.14159 / 4);
      canvas.drawOval(Rect.fromCenter(center: const Offset(0, -16), width: 12, height: 20), petalPaint);
      canvas.restore();
    }
    // 中央（黄色）
    final center_ = Paint()..color = _flowerYellow;
    canvas.drawCircle(center, 12, center_);
    // 中央の模様
    final dot = Paint()..color = _flowerYellow.withRed(220);
    canvas.drawCircle(center, 6, dot);
  }

  void _drawGreenShading(Canvas canvas, Offset center, double r) {
    final hl = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.4, -0.4),
        radius: 0.9,
        colors: [_lightGreen.withOpacity(0.5), Colors.transparent],
      ).createShader(Rect.fromCircle(center: center, radius: r));
    canvas.drawCircle(center, r, hl);
  }

  void _drawEye(Canvas canvas, Offset center, double r) {
    // 白目
    canvas.drawCircle(center, r, Paint()..color = _white);
    // 黒目
    canvas.drawCircle(center + Offset(r * 0.15, r * 0.1), r * 0.55, Paint()..color = _black);
    // ハイライト
    canvas.drawCircle(center + Offset(r * -0.2, r * -0.3), r * 0.22, Paint()..color = _white);
  }

  void _drawClosedEye(Canvas canvas, Offset center, Paint paint) {
    final path = Path()
      ..moveTo(center.dx - 7, center.dy)
      ..quadraticBezierTo(center.dx, center.dy - 5, center.dx + 7, center.dy);
    canvas.drawPath(path, paint);
  }

  void _drawBlush(Canvas canvas, Offset center) {
    final paint = Paint()..color = _blush.withOpacity(0.45);
    canvas.drawOval(Rect.fromCenter(center: center, width: 14, height: 8), paint);
  }

  void _drawSmile(Canvas canvas, Offset center, double width) {
    final path = Path()
      ..moveTo(center.dx - width, center.dy)
      ..quadraticBezierTo(center.dx, center.dy + width * 0.7, center.dx + width, center.dy);
    canvas.drawPath(path, Paint()..color = _black..strokeWidth = 2.5..style = PaintingStyle.stroke..strokeCap = StrokeCap.round);
  }

  void _drawSparkles(Canvas canvas, Size s) {
    final paint = Paint()..color = _flowerYellow..style = PaintingStyle.stroke..strokeWidth = 1.5;
    final positions = [
      Offset(s.width * 0.12, s.height * 0.15),
      Offset(s.width * 0.88, s.height * 0.12),
      Offset(s.width * 0.80, s.height * 0.40),
    ];
    for (final pos in positions) {
      for (int i = 0; i < 4; i++) {
        canvas.save();
        canvas.translate(pos.dx, pos.dy);
        canvas.rotate(i * 3.14159 / 4);
        canvas.drawLine(const Offset(0, -6), const Offset(0, 6), paint);
        canvas.restore();
      }
    }
  }

  void _drawText(Canvas canvas, String text, Offset offset, TextStyle style) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant _PlantMonsterPainter old) => old.level != level;
}
