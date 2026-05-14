import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../plant_avatar.dart';
import '../monthly_plant_history.dart';
import '../repository/plant_avatar_repository.dart';
import '../log.dart';

final plantAvatarRepositoryProvider =
    Provider((ref) => PlantAvatarRepository());

final plantAvatarProvider =
    StateNotifierProvider<PlantAvatarNotifier, PlantAvatar>((ref) {
  final repo = ref.watch(plantAvatarRepositoryProvider);
  return PlantAvatarNotifier(repo);
});

class PlantAvatarNotifier extends StateNotifier<PlantAvatar> {
  final PlantAvatarRepository repo;
  int? previousLevel;

  PlantAvatarNotifier(this.repo)
      : super(repo.getOrCreate()) {
    _checkMonthlyReset();
    previousLevel = state.level;
  }

  void _checkMonthlyReset() {
    final now = DateTime.now();
    if (state.month != now.month ||
        state.year != now.year) {
      _saveMonthlyHistory();
      _resetForNewMonth();
    }
  }

  void _saveMonthlyHistory() {
    final box = Hive.box<
        MonthlyPlantHistory>(
        'monthly_plant_history');

    final history =
        MonthlyPlantHistory(
      year: state.year,
      month: state.month,
      maxLevel: state.level,
      totalExp: state.currentExp,
    );

    box.add(history);
  }

  void _resetForNewMonth() {
    final now = DateTime.now();
    final resetPlant = PlantAvatar(
      exp: 0,
      level: 0,
      createdAt:
          state.createdAt,
      month: now.month,
      year: now.year,
      monthlyGoal: state.monthlyGoal,
    );

    repo.updatePlant(resetPlant);
    state = resetPlant;
    previousLevel = 0;
  }

  Future<void> addExp({
    required int practiceMinutes,
    required int streakDays,
    required int videoUploads,
  }) async {
    _checkMonthlyReset();

    final newExp = state.calculateExp(
      practiceMinutes:
          practiceMinutes,
      streakDays: streakDays,
      videoUploads:
          videoUploads,
    );

    final totalExp =
        state.currentExp + newExp;
    final newLevel =
        state.getLevel(totalExp);

    final updatedPlant =
        PlantAvatar(
      exp: totalExp,
      level: newLevel,
      createdAt:
          state.createdAt,
      month: state.month,
      year: state.year,
      monthlyGoal: state.monthlyGoal,
    );

    previousLevel = state.level;
    await repo.updatePlant(
        updatedPlant);
    state = updatedPlant;
  }

  int? getLevelUpDifference() {
    if (previousLevel ==
        null) return null;
    final diff =
        state.level -
            previousLevel!;
    return diff > 0 ? diff : null;
  }

  void resetLevelUpFlag() {
    previousLevel = state.level;
  }

  Future<void> setExpDirect(
      int exp) async {
    final updatedPlant =
        PlantAvatar(
      exp: exp,
      level: state.getLevel(exp),
      createdAt:
          state.createdAt,
      month: state.month,
      year: state.year,
      monthlyGoal: state.monthlyGoal,
    );

    await repo.updatePlant(
        updatedPlant);
    state = updatedPlant;
  }

  Future<void> setMonthlyGoal(int goal) async {
    final minimumGoal = 100;
    final adjustedGoal = goal < minimumGoal ? minimumGoal : goal;

    final updatedPlant = PlantAvatar(
      exp: state.currentExp,
      level: state.level,
      createdAt: state.createdAt,
      month: state.month,
      year: state.year,
      monthlyGoal: adjustedGoal,
    );

    await repo.updatePlant(updatedPlant);
    state = updatedPlant;
  }

  List<int> getLevelThresholds() {
    return state.getLevelThresholds();
  }

  int getMinutesPerLevel() {
    return state.monthlyGoal ~/ 5;
  }
}
