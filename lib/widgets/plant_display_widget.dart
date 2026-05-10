import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../plant_avatar.dart';
import '../provider/plant_avatar_provider.dart';

class PlantDisplayWidget extends ConsumerWidget {
  const PlantDisplayWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plant = ref.watch(plantAvatarProvider);

    final currentLevel =
        plant.getLevel(plant.currentExp);
    final nextLevelMinutes =
        plant.getMinutesUntilNextLevel(
            plant.currentExp);
    final progress = plant.getProgressToNextLevel(
        plant.currentExp);
    final emoji = plant.getEmoji(plant.currentExp);

    return Container(
      margin: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF111827),
            Color(0xFF1E1B4B),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color:
                Colors.cyan.withOpacity(0.45),
            blurRadius: 18,
          )
        ],
        border: Border.all(
          color: Colors.cyan,
          width: 1.4,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              emoji,
              style: const TextStyle(
                fontSize: 48,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              plant.getName(plant.currentExp),
              style: const TextStyle(
                color: Colors.cyan,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Lv. ${currentLevel + 1}',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius:
                  BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor:
                    Colors.white10,
                valueColor:
                    const AlwaysStoppedAnimation<
                        Color>(Colors.cyan),
              ),
            ),
            const SizedBox(height: 8),
            if (currentLevel <
                PlantAvatar
                    .levelThresholds.length -
                    1)
              Text(
                'Next: ${nextLevelMinutes}分',
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 12,
                ),
              )
            else
              const Text(
                'Max Level',
                style: TextStyle(
                  color: Colors.cyan,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
