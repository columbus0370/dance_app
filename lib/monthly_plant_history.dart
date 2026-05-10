import 'package:hive/hive.dart';

part 'monthly_plant_history.g.dart';

@HiveType(typeId: 2)
class MonthlyPlantHistory extends HiveObject {
  @HiveField(0)
  int year;

  @HiveField(1)
  int month;

  @HiveField(2)
  int maxLevel;

  @HiveField(3)
  int totalExp;

  @HiveField(4)
  DateTime createdAt;

  MonthlyPlantHistory({
    required this.year,
    required this.month,
    required this.maxLevel,
    required this.totalExp,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  String getEmoji() {
    const levelEmojis = [
      '🌰',
      '🌱',
      '🌿',
      '🌳',
      '🌸',
      '🌻',
    ];
    return levelEmojis[
        maxLevel >= levelEmojis.length
            ? levelEmojis.length - 1
            : maxLevel];
  }

  String getLevelName() {
    const levelNames = [
      'Seed',
      'Sprout',
      'Young',
      'Mature',
      'Flower',
      'Full Bloom',
    ];
    return levelNames[
        maxLevel >= levelNames.length
            ? levelNames.length - 1
            : maxLevel];
  }

  String getDisplayText() {
    return '$year年${month}月：${getEmoji()} ${getLevelName()} (${totalExp}分)';
  }
}
