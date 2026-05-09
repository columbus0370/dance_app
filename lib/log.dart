import 'package:hive/hive.dart';

part 'log.g.dart';

@HiveType(typeId: 0)
class Log extends HiveObject {
  @HiveField(0)
  DateTime date;

  @HiveField(1)
  int practiceMinutes;

  @HiveField(2)
  String memo;

  @HiveField(3)
  List<String> tags;

  @HiveField(4)
  String videoUrl;

  Log({
    required this.date,
    required this.practiceMinutes,
    required this.memo,
    required this.tags,
    required this.videoUrl,
  });
}