import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../plant_avatar.dart';
import '../provider/plant_avatar_provider.dart';
import 'plant_monster_widget.dart';

class PlantDisplayWidget extends ConsumerWidget {
  const PlantDisplayWidget({super.key});

  void _showGoalSettingDialog(
      BuildContext context, WidgetRef ref, int currentGoal) {
    final TextEditingController controller =
        TextEditingController(text: currentGoal.toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('月間目標分数を設定'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: '月間目標 (100分以上)',
              hintText: '例: 600',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('キャンセル'),
            ),
            TextButton(
              onPressed: () {
                final newGoal = int.tryParse(controller.text);
                if (newGoal != null && newGoal >= 100) {
                  ref
                      .read(plantAvatarProvider.notifier)
                      .setMonthlyGoal(newGoal);
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('目標を${newGoal}分に設定しました')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('100分以上を入力してください')),
                  );
                }
              },
              child: const Text('設定'),
            ),
          ],
        );
      },
    );
    controller.dispose();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plant = ref.watch(plantAvatarProvider);

    final currentLevel = plant.getLevel(plant.currentExp);
    final thresholds = plant.getLevelThresholds();
    final nextLevelMinutes =
        plant.getMinutesUntilNextLevel(plant.currentExp);
    final progress = plant.getProgressToNextLevel(plant.currentExp);

    return Container(
      margin: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF111827),
            Color(0xFF1E1B4B),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.cyan.withOpacity(0.45),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PlantMonsterWidget(
                        level: currentLevel,
                        size: 110,
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
                    ],
                  ),
                ),
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.cyan,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.cyan.withOpacity(0.1),
                      ),
                      child: Column(
                        children: [
                          Text(
                            '月間目標',
                            style: TextStyle(
                              color: Colors.cyan.withOpacity(0.7),
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${plant.monthlyGoal}分',
                            style: const TextStyle(
                              color: Colors.cyan,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: () => _showGoalSettingDialog(
                                context, ref, plant.monthlyGoal),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.cyan,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                '変更',
                                style: TextStyle(
                                  color: Colors.cyan,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: Colors.white10,
                valueColor:
                    const AlwaysStoppedAnimation<Color>(Colors.cyan),
              ),
            ),
            const SizedBox(height: 8),
            if (currentLevel < thresholds.length - 1)
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
