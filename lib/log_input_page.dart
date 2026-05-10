import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'log.dart';
import 'log_list_page.dart';
import 'calendar_page.dart';
import 'help_page.dart';
import 'plant_gallery_page.dart';
import 'provider/plant_avatar_provider.dart';
import 'widgets/plant_display_widget.dart';
import 'widgets/level_up_dialog.dart';

class LogInputPage extends ConsumerStatefulWidget {
  final Log? editLog;

  const LogInputPage({
    super.key,
    this.editLog,
  });

  @override
  ConsumerState<LogInputPage> createState() =>
      _LogInputPageState();
}

class _LogInputPageState
    extends ConsumerState<LogInputPage> {
  DateTime selectedDate =
      DateTime.now();

  final timeController =
      TextEditingController();
  final memoController =
      TextEditingController();
  final tagController =
      TextEditingController();
  final urlController =
      TextEditingController();

  List<String> tags = [];

  Box<Log> get box =>
      Hive.box<Log>('logs');

  @override
  void initState() {
    super.initState();

    if (widget.editLog != null) {
      final log =
          widget.editLog!;

      selectedDate = log.date;
      timeController.text =
          log.practiceMinutes
              .toString();
      memoController.text =
          log.memo;
      urlController.text =
          log.videoUrl;
      tags = List.from(
        log.tags,
      );
    }
  }

  int getTodayPracticeMinutes() {
    final now =
        DateTime.now();

    return box.values
        .where(
          (log) =>
              log.date.year ==
                  now.year &&
              log.date.month ==
                  now.month &&
              log.date.day ==
                  now.day,
        )
        .fold(
          0,
          (sum, log) =>
              sum +
              log.practiceMinutes,
        );
  }

  int getWeeklyPracticeMinutes() {
    final now =
        DateTime.now();
    final start =
        now.subtract(
      Duration(
          days:
              now.weekday - 1),
    );

    return box.values
        .where(
          (log) =>
              log.date.isAfter(
                  start.subtract(
                      const Duration(
                          days: 1))),
        )
        .fold(
          0,
          (sum, log) =>
              sum +
              log.practiceMinutes,
        );
  }

  int getStreakDays() {
    final dates = box.values
        .map(
          (log) => DateTime(
            log.date.year,
            log.date.month,
            log.date.day,
          ),
        )
        .toSet()
        .toList()
      ..sort(
        (a, b) =>
            b.compareTo(a),
      );

    if (dates.isEmpty) {
      return 0;
    }

    int streak = 1;

    for (int i = 0;
        i <
            dates.length - 1;
        i++) {
      final diff =
          dates[i]
              .difference(
                  dates[i + 1])
              .inDays;

      if (diff == 1) {
        streak++;
      } else {
        break;
      }
    }

    return streak;
  }

  int countVideoUploads() {
    return box.values
        .where((log) =>
            log.videoUrl
                .isNotEmpty)
        .length;
  }

  List<Log> getRecentLogs() {
    final logs =
        box.values.toList();

    logs.sort(
      (a, b) =>
          b.date.compareTo(
              a.date),
    );

    return logs.take(3).toList();
  }

  void addTag() {
    final text =
        tagController.text
            .trim();

    if (text.isEmpty) return;
    if (tags.contains(text)) return;

    setState(() {
      tags.add(text);
      tagController.clear();
    });
  }

  void saveLog() async {
    try {
      final practiceMinutes =
          int.tryParse(
                timeController
                    .text,
              ) ??
              0;

      final log = Log(
        date: selectedDate,
        practiceMinutes:
            practiceMinutes,
        memo:
            memoController.text,
        tags:
            List.from(tags),
        videoUrl:
            urlController.text,
      );

      if (widget.editLog !=
          null) {
        await box.put(
          widget.editLog!.key,
          log,
        );

        if (!mounted) return;
        Navigator.pop(context);
      } else {
        await box.add(log);

        final plantNotifier =
            ref.read(
                plantAvatarProvider
                    .notifier);

        await plantNotifier
            .addExp(
          practiceMinutes:
              practiceMinutes,
          streakDays:
              getStreakDays(),
          videoUploads:
              countVideoUploads(),
        );

        if (!mounted) return;

        final levelUpDiff =
            plantNotifier
                .getLevelUpDifference();

        if (levelUpDiff != null &&
            levelUpDiff > 0) {
          final plant = ref.read(
              plantAvatarProvider);
          showDialog(
            context: context,
            barrierDismissible:
                false,
            builder: (context) =>
                LevelUpDialog(
              newLevel: plant.level +
                  1,
              emoji: plant.getEmoji(
                  plant.currentExp),
              levelName:
                  plant.getName(
                      plant.currentExp),
            ),
          );
          plantNotifier
              .resetLevelUpFlag();
        }

        FocusScope.of(context)
            .unfocus();

        ScaffoldMessenger.of(
                context)
            .showSnackBar(
          const SnackBar(
            content:
                Text('保存しました'),
          ),
        );

        timeController.clear();
        memoController.clear();
        tagController.clear();
        urlController.clear();

        setState(() {
          tags.clear();
          selectedDate =
              DateTime.now();
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(
              context)
          .showSnackBar(
        SnackBar(
          content: Text(
              '保存失敗: $e'),
        ),
      );
    }
  }

  Widget neonCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Expanded(
      child: Container(
        margin:
            const EdgeInsets
                .all(6),
        decoration:
            BoxDecoration(
          borderRadius:
              BorderRadius
                  .circular(20),
          gradient:
              const LinearGradient(
            colors: [
              Color(
                  0xFF111827),
              Color(
                  0xFF1E1B4B),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors
                  .cyan
                  .withOpacity(
                      0.45),
              blurRadius: 18,
            ),
          ],
          border: Border.all(
            color: Colors.cyan,
            width: 1.4,
          ),
        ),
        child: Padding(
          padding:
              const EdgeInsets
                  .all(18),
          child: Column(
            mainAxisSize:
                MainAxisSize.min,
            children: [
              Icon(
                icon,
                color:
                    Colors.cyan,
                size: 28,
              ),
              const SizedBox(
                  height: 10),
              Text(
                title,
                style:
                    const TextStyle(
                  color: Colors
                      .white70,
                ),
              ),
              const SizedBox(
                  height: 8),
              Text(
                value,
                style:
                    const TextStyle(
                  color: Colors
                      .white,
                  fontSize: 22,
                  fontWeight:
                      FontWeight
                          .bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(
      BuildContext context) {
    final recentLogs =
        getRecentLogs();

    return Scaffold(
      backgroundColor:
          const Color(
              0xFF09090F),
      appBar: AppBar(
        backgroundColor:
            Colors.black,
        title:
            const Text(
          'Dance Log',
          style: TextStyle(
            color:
                Colors.cyan,
            fontWeight:
                FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            color:
                Colors.cyan,
            icon: const Icon(
                Icons.list),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      const LogListPage(),
                ),
              );
            },
          ),
          IconButton(
            color:
                Colors.pinkAccent,
            icon: const Icon(Icons
                .calendar_month),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      const CalendarPage(),
                ),
              );
            },
          ),
          IconButton(
            color:
                Colors.greenAccent,
            icon: const Icon(
                Icons.help_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      const HelpPage(),
                ),
              );
            },
          ),
          IconButton(
            color:
                Colors.orangeAccent,
            icon: const Icon(
                Icons.image),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      const PlantGalleryPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration:
            const BoxDecoration(
          gradient:
              LinearGradient(
            begin:
                Alignment
                    .topLeft,
            end: Alignment
                .bottomRight,
            colors: [
              Color(
                  0xFF09090F),
              Color(
                  0xFF111827),
              Color(
                  0xFF1E1B4B),
            ],
          ),
        ),
        child: Padding(
          padding:
              const EdgeInsets
                  .all(16),
          child: ListView(
            children: [
              const Text(
                'STREET MODE',
                style:
                    TextStyle(
                  color: Colors
                      .pinkAccent,
                  fontSize: 24,
                  fontWeight:
                      FontWeight
                          .bold,
                  letterSpacing:
                      3,
                ),
              ),
              const SizedBox(
                  height: 18),
              const PlantDisplayWidget(),
              const SizedBox(
                  height: 18),
              Row(
                children: [
                  neonCard(
                    icon: Icons
                        .local_fire_department,
                    title:
                        'TODAY',
                    value:
                        '${getTodayPracticeMinutes()}分',
                  ),
                  neonCard(
                    icon: Icons
                        .timeline,
                    title:
                        'WEEK',
                    value:
                        '${getWeeklyPracticeMinutes()}分',
                  ),
                ],
              ),
              Row(
                children: [
                  neonCard(
                    icon: Icons.bolt,
                    title:
                        'STREAK',
                    value:
                        '${getStreakDays()}日',
                  ),
                ],
              ),
              const SizedBox(
                  height: 20),
              Card(
                color: const Color(
                    0xFF111827),
                child: Padding(
                  padding:
                      const EdgeInsets
                          .all(16),
                  child: Column(
                    mainAxisSize:
                        MainAxisSize
                            .min,
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                    children: [
                      const Text(
                        'RECENT SESSION',
                        style:
                            TextStyle(
                          color: Colors
                              .cyan,
                        ),
                      ),
                      ...recentLogs.map(
                        (log) =>
                            ListTile(
                          title:
                              Text(
                            '${log.practiceMinutes}分',
                            style: const TextStyle(
                                color: Colors.white),
                          ),
                          subtitle:
                              Text(
                            log.memo,
                            style: const TextStyle(
                                color: Colors.white70),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                  height: 20),
              GestureDetector(
                onTap: () async {
                  final picked =
                      await showDatePicker(
                    context:
                        context,
                    initialDate:
                        selectedDate,
                    firstDate:
                        DateTime(
                            2024),
                    lastDate:
                        DateTime(
                            2100),
                  );

                  if (picked !=
                      null) {
                    setState(() {
                      selectedDate =
                          picked;
                    });
                  }
                },
                child: Container(
                  padding:
                      const EdgeInsets
                          .all(16),
                  decoration:
                      BoxDecoration(
                    border: Border.all(
                        color: Colors
                            .cyan),
                    borderRadius:
                        BorderRadius
                            .circular(
                                14),
                  ),
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment
                            .spaceBetween,
                    children: [
                      const Text(
                        '練習日',
                        style:
                            TextStyle(
                          color: Colors
                              .white70,
                        ),
                      ),
                      Text(
                        '${selectedDate.year}/${selectedDate.month}/${selectedDate.day}',
                        style:
                            const TextStyle(
                          color: Colors
                              .cyan,
                          fontWeight:
                              FontWeight
                                  .bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                  height: 16),
              TextField(
                controller:
                    timeController,
                keyboardType:
                    TextInputType
                        .number,
                style:
                    const TextStyle(
                        color: Colors
                            .white),
                decoration:
                    const InputDecoration(
                  labelText:
                      '練習時間',
                  border:
                      OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                  height: 12),
              Wrap(
                spacing: 8,
                children: [
                  15,
                  30,
                  45,
                  60,
                  90
                ]
                    .map(
                      (m) =>
                          ElevatedButton(
                        onPressed:
                            () {
                          timeController
                                  .text =
                              '$m';
                        },
                        child: Text(
                            '$m分'),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(
                  height: 12),
              TextField(
                controller:
                    memoController,
                style:
                    const TextStyle(
                        color: Colors
                            .white),
                decoration:
                    const InputDecoration(
                  labelText:
                      'メモ',
                  border:
                      OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                  height: 12),
              TextField(
                controller:
                    tagController,
                onSubmitted:
                    (_) =>
                        addTag(),
                style:
                    const TextStyle(
                        color: Colors
                            .white),
                decoration:
                    const InputDecoration(
                  labelText:
                      'タグ',
                ),
              ),
              Wrap(
                spacing: 8,
                children: tags
                    .map(
                      (tag) =>
                          Chip(
                        label: Text(
                            tag),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(
                  height: 12),
              TextField(
                controller:
                    urlController,
                style:
                    const TextStyle(
                        color: Colors
                            .white),
                decoration:
                    const InputDecoration(
                  labelText:
                      '動画URL',
                  border:
                      OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                  height: 80),
            ],
          ),
        ),
      ),
      bottomNavigationBar:
          Padding(
        padding:
            const EdgeInsets
                .all(16),
        child:
            ElevatedButton(
          onPressed:
              saveLog,
          child:
              const Text(
                  '保存'),
        ),
      ),
    );
  }
}
