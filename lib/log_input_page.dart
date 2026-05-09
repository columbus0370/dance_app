import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'log.dart';
import 'log_list_page.dart';
import 'calendar_page.dart';

class LogInputPage extends StatefulWidget {
  final Log? editLog;

  const LogInputPage({
    super.key,
    this.editLog,
  });

  @override
  State<LogInputPage> createState() =>
      _LogInputPageState();
}

class _LogInputPageState
    extends State<LogInputPage> {
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
              now.weekday -
                  1),
    );

    return box.values
        .where(
          (log) =>
              log.date.isAfter(
                  start.subtract(
                      const Duration(
                          days:
                              1))),
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
            dates.length -
                1;
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

    if (tags.contains(text)) {
      return;
    }

    setState(() {
      tags.add(text);
      tagController.clear();
    });
  }

  void saveLog() async {
    final log = Log(
      date: selectedDate,
      practiceMinutes:
          int.tryParse(
                timeController
                    .text,
              ) ??
              0,
      memo:
          memoController.text,
      tags: List.from(
          tags),
      videoUrl:
          urlController.text,
    );

    if (widget.editLog !=
        null) {
      await box.put(
        widget.editLog!.key,
        log,
      );
    } else {
      await box.add(log);
    }

    if (!mounted) return;
    Navigator.pop(context);
  }

  Widget neonCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Expanded(
      child: Container(
        margin:
            const EdgeInsets.all(
                6),
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
                    icon: Icons
                        .bolt,
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
                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius
                          .circular(
                              20),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets
                          .all(16),
                  child: Column(
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
                          fontWeight:
                              FontWeight
                                  .bold,
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

              TextField(
                controller:
                    timeController,
                style:
                    const TextStyle(
                        color:
                            Colors.white),
                decoration:
                    const InputDecoration(
                  labelText:
                      '練習時間',
                  labelStyle:
                      TextStyle(
                          color: Colors
                              .cyan),
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
                        color:
                            Colors.white),
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
                style:
                    const TextStyle(
                        color:
                            Colors.white),
                onSubmitted:
                    (_) =>
                        addTag(),
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
                        color:
                            Colors.white),
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