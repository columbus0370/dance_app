import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repository/log_repository.dart';
import '../log.dart';

/// Repository を提供
final logRepositoryProvider = Provider((ref) => LogRepository());

/// ログ一覧を管理する StateNotifier
final logListProvider =
    StateNotifierProvider<LogListNotifier, List<Log>>((ref) {
  final repo = ref.watch(logRepositoryProvider);
  return LogListNotifier(repo);
});

class LogListNotifier extends StateNotifier<List<Log>> {
  final LogRepository repo;

  LogListNotifier(this.repo) : super(repo.getLogs());

  Future<void> add(Log log) async {
    await repo.addLog(log);
    state = repo.getLogs();
  }

  Future<void> update(int key, Log log) async {
    await repo.updateLog(key, log);
    state = repo.getLogs();
  }

  Future<void> delete(int key) async {
    await repo.deleteLog(key);
    state = repo.getLogs();
  }
}

/// ★ タグ検索キーワードを保持する Provider
final tagFilterProvider = StateProvider<String>((ref) => "");

/// ★ 検索後のログ一覧を返す Provider
final filteredLogsProvider = Provider<List<Log>>((ref) {
  final logs = ref.watch(logListProvider);
  final keyword = ref.watch(tagFilterProvider);

  if (keyword.isEmpty) return logs;

  return logs.where((log) {
    return log.tags.any((tag) => tag.contains(keyword));
  }).toList();
});
