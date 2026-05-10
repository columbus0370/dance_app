import 'package:hive/hive.dart';

part 'plant_avatar.g.dart';

@HiveType(typeId: 1)
class PlantAvatar extends HiveObject {
  @HiveField(0)
  int currentExp = 0;

  @HiveField(1)
  int level = 0;

  @HiveField(2)
  DateTime createdAt = DateTime.now();

  @HiveField(3)
  int month = 0;

  @HiveField(4)
  int year = 0;

  PlantAvatar({
    int exp = 0,
    int level = 0,
    DateTime? createdAt,
    int? month,
    int? year,
  })  : currentExp = exp,
        level = level,
        createdAt = createdAt ?? DateTime.now(),
        month = month ?? DateTime.now().month,
        year = year ?? DateTime.now().year;

  static const List<int> levelThresholds = [
    0,
    600,
    1200,
    1800,
    2400,
    3000,
  ];

  static const List<String> levelEmojis = [
    '🌰',
    '🌱',
    '🌿',
    '🌳',
    '🌸',
    '🌻',
  ];

  static const List<String> levelNames = [
    'Seed',
    'Sprout',
    'Young',
    'Mature',
    'Flower',
    'Full Bloom',
  ];

  int getLevel(int exp) {
    for (int i = levelThresholds.length - 1; i >= 0; i--) {
      if (exp >= levelThresholds[i]) {
        return i;
      }
    }
    return 0;
  }

  int getMinutesUntilNextLevel(int exp) {
    int currentLevel = getLevel(exp);
    if (currentLevel >= levelThresholds.length - 1) {
      return 0;
    }

    int nextThreshold = levelThresholds[currentLevel + 1];
    int minutesNeeded = nextThreshold - exp;
    return minutesNeeded > 0 ? minutesNeeded : 0;
  }

  double getProgressToNextLevel(int exp) {
    int currentLevel = getLevel(exp);
    if (currentLevel >= levelThresholds.length - 1) {
      return 1.0;
    }

    int currentThreshold = levelThresholds[currentLevel];
    int nextThreshold = levelThresholds[currentLevel + 1];
    int expInLevel = exp - currentThreshold;
    int expForLevel = nextThreshold - currentThreshold;

    return expInLevel / expForLevel;
  }

  String getEmoji(int exp) {
    int level = getLevel(exp);
    return levelEmojis[level];
  }

  String getName(int exp) {
    int level = getLevel(exp);
    return levelNames[level];
  }

  int calculateExp({
    required int practiceMinutes,
    required int streakDays,
    required int videoUploads,
  }) {
    return (practiceMinutes * 1.0).toInt() +
        (streakDays * 0.5).toInt() +
        (videoUploads * 50);
  }
}
