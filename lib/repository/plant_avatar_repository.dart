import 'package:hive_flutter/hive_flutter.dart';
import '../plant_avatar.dart';

class PlantAvatarRepository {
  final Box<PlantAvatar> box =
      Hive.box<PlantAvatar>('plant_avatars');

  PlantAvatar getOrCreate() {
    if (box.isEmpty) {
      final plant = PlantAvatar();
      box.put('main', plant);
      return plant;
    }
    return box.get('main') ?? PlantAvatar();
  }

  Future<void> updatePlant(PlantAvatar plant) async {
    await box.put('main', plant);
  }

  PlantAvatar getPlant() {
    return box.get('main') ?? PlantAvatar();
  }
}
