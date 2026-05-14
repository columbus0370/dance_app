import 'package:flutter/material.dart';
import '../models/monthly_flower.dart';
import 'plant_designs/monthly_plant_painter.dart';

/// 月別デザインに対応した植物成長ウィジェット
/// 毎月異なるデザインの花を表示します
class MonthlyPlantMonsterWidget extends StatelessWidget {
  final int level;
  final double size;
  final int month;

  const MonthlyPlantMonsterWidget({
    super.key,
    required this.level,
    this.size = 120,
    int? month,
  }) : month = month ?? 0; // 0 = 現在の月

  int get _currentMonth {
    if (month == 0) {
      return DateTime.now().month;
    }
    return month.clamp(1, 12);
  }

  @override
  Widget build(BuildContext context) {
    final flower = MonthlyFlowerRepository.getFlowerByMonth(_currentMonth);
    final painter = MonthlyPlantPainterFactory.createPainter(
      month: _currentMonth,
      level: level.clamp(0, 5),
    );

    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: painter,
      ),
    );
  }
}

/// 月別花情報を表示するインフォカード
class MonthlyFlowerInfoCard extends StatelessWidget {
  final int month;

  const MonthlyFlowerInfoCard({
    super.key,
    int? month,
  }) : month = month ?? 0; // 0 = 現在の月

  int get _currentMonth {
    if (month == 0) {
      return DateTime.now().month;
    }
    return month.clamp(1, 12);
  }

  @override
  Widget build(BuildContext context) {
    final flower = MonthlyFlowerRepository.getFlowerByMonth(_currentMonth);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.cyan, width: 1),
        borderRadius: BorderRadius.circular(8),
        color: Colors.cyan.withOpacity(0.05),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_currentMonth}月の花',
                style: const TextStyle(
                  color: Colors.cyan,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                flower.season,
                style: TextStyle(
                  color: Colors.cyan.withOpacity(0.6),
                  fontSize: 10,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            flower.flowerName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            flower.symbolism,
            style: TextStyle(
              color: Colors.white54,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            flower.description,
            style: TextStyle(
              color: Colors.white54,
              fontSize: 10,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
