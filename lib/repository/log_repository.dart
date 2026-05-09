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
    final logs = box.values.toList();
    logs.sort((a, b) => b.date.compareTo(a.date));
    return logs;
  }
}
