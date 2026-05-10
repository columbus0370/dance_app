import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../plant_avatar.dart';
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

  PlantAvatarNotifier(this.repo)
      : super(repo.getOrCreate());

  Future<void> addExp({
    required int practiceMinutes,
    required int streakDays,
    required int videoUploads,
  }) async {
    final newExp = state.calculateExp(
      practiceMinutes: practiceMinutes,
      streakDays: streakDays,
      videoUploads: videoUploads,
    );

    final updatedPlant = PlantAvatar(
      exp: state.currentExp + newExp,
      level: state.getLevel(state.currentExp + newExp),
      createdAt: state.createdAt,
    );

    await repo.updatePlant(updatedPlant);
    state = updatedPlant;
  }

  void setExp(int exp) {
    state = PlantAvatar(
      exp: exp,
      level: state.getLevel(exp),
      createdAt: state.createdAt,
    );
  }
}
