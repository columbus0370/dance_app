import 'package:flutter/material.dart';

class MonthlyFlower {
  final int month;
  final String flowerName;
  final String description;
  final List<Color> primaryColors;
  final List<Color> accentColors;
  final String symbolism;
  final String season;

  MonthlyFlower({
    required this.month,
    required this.flowerName,
    required this.description,
    required this.primaryColors,
    required this.accentColors,
    required this.symbolism,
    required this.season,
  });
}

class MonthlyFlowerRepository {
  static final List<MonthlyFlower> flowers = [
    // 1月
    MonthlyFlower(
      month: 1,
      flowerName: '待機中',
      description: '花屋さんから情報を取得予定',
      primaryColors: [Color(0xFF0A6B7F)],
      accentColors: [Color(0xFF14A085)],
      symbolism: '新年の始まり',
      season: '冬',
    ),
    // 2月
    MonthlyFlower(
      month: 2,
      flowerName: '待機中',
      description: '花屋さんから情報を取得予定',
      primaryColors: [Color(0xFF8B4789)],
      accentColors: [Color(0xFFD98DCF)],
      symbolism: 'バレンタイン',
      season: '冬',
    ),
    // 3月
    MonthlyFlower(
      month: 3,
      flowerName: '待機中',
      description: '花屋さんから情報を取得予定',
      primaryColors: [Color(0xFFE89AC7)],
      accentColors: [Color(0xFFFFC0D9)],
      symbolism: '春の訪れ',
      season: '春',
    ),
    // 4月
    MonthlyFlower(
      month: 4,
      flowerName: '待機中',
      description: '花屋さんから情報を取得予定',
      primaryColors: [Color(0xFFFFB7C5)],
      accentColors: [Color(0xFFFFF0F3)],
      symbolism: '新生活',
      season: '春',
    ),
    // 5月
    MonthlyFlower(
      month: 5,
      flowerName: '待機中',
      description: '花屋さんから情報を取得予定',
      primaryColors: [Color(0xFF2ECC71)],
      accentColors: [Color(0xFF82E0AA)],
      symbolism: 'フレッシュ',
      season: '春',
    ),
    // 6月
    MonthlyFlower(
      month: 6,
      flowerName: '待機中',
      description: '花屋さんから情報を取得予定',
      primaryColors: [Color(0xFF4A90E2)],
      accentColors: [Color(0xFF9ECBFF)],
      symbolism: '梅雨',
      season: '初夏',
    ),
    // 7月
    MonthlyFlower(
      month: 7,
      flowerName: '待機中',
      description: '花屋さんから情報を取得予定',
      primaryColors: [Color(0xFFFFA500)],
      accentColors: [Color(0xFFFFD700)],
      symbolism: '夏祭り',
      season: '夏',
    ),
    // 8月
    MonthlyFlower(
      month: 8,
      flowerName: '待機中',
      description: '花屋さんから情報を取得予定',
      primaryColors: [Color(0xFFFF6B6B)],
      accentColors: [Color(0xFFFF9999)],
      symbolism: '盛夏',
      season: '夏',
    ),
    // 9月
    MonthlyFlower(
      month: 9,
      flowerName: '待機中',
      description: '花屋さんから情報を取得予定',
      primaryColors: [Color(0xFF9B59B6)],
      accentColors: [Color(0xFFD7BDE2)],
      symbolism: '秋の入口',
      season: '秋',
    ),
    // 10月
    MonthlyFlower(
      month: 10,
      flowerName: '待機中',
      description: '花屋さんから情報を取得予定',
      primaryColors: [Color(0xFFE67E22)],
      accentColors: [Color(0xFFF8B88B)],
      symbolism: '秋の実り',
      season: '秋',
    ),
    // 11月
    MonthlyFlower(
      month: 11,
      flowerName: '待機中',
      description: '花屋さんから情報を取得予定',
      primaryColors: [Color(0xFF8B4513)],
      accentColors: [Color(0xFFD2691E)],
      symbolism: '収穫',
      season: '秋',
    ),
    // 12月
    MonthlyFlower(
      month: 12,
      flowerName: '待機中',
      description: '花屋さんから情報を取得予定',
      primaryColors: [Color(0xFFC41E3A)],
      accentColors: [Color(0xFFFFD700)],
      symbolism: 'クリスマス',
      season: '冬',
    ),
  ];

  static MonthlyFlower getFlowerByMonth(int month) {
    if (month < 1 || month > 12) {
      month = DateTime.now().month;
    }
    return flowers[month - 1];
  }
}
