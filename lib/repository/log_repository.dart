import 'package:hive_flutter/hive_flutter.dart';
import '../log.dart';

class LogRepository {
  final Box<Log> box = Hive.box<Log>('logs');

  Future<void> addLog(Log log) async {
    await box.add(log);
  }

  Future<void> updateLog(int key, Log log) async {
    await box.put(key, log);
  }

  Future<void> deleteLog(int key) async {
    await box.delete(key);
  }

  List<Log> getLogs() {
    final entries =
        box.entries.toList();

    entries.sort((a, b) {
      final dateCompare =
          b.value.date.compareTo(
              a.value.date);
      if (dateCompare != 0) {
        return dateCompare;
      }
      return b.key.compareTo(
          a.key);
    });

    return entries
        .map((e) => e.value)
        .toList();
  }
}
