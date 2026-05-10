import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'log.dart';
import 'log_detail_page.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() =>
      _CalendarPageState();
}

class _CalendarPageState
    extends State<CalendarPage> {
  DateTime selectedDay =
      DateTime.now();
  DateTime focusedDay =
      DateTime.now();

  Box<Log> get box =>
      Hive.box<Log>('logs');

  List<Log> getMonthlyLogs() {
    return box.values.where((log) {
      return log.date.year ==
              focusedDay.year &&
          log.date.month ==
              focusedDay.month;
    }).toList();
  }

  int getMonthlyTotalMinutes() {
    return getMonthlyLogs().fold(
      0,
      (sum, log) =>
          sum +
          log.practiceMinutes,
    );
  }

  int getMonthlyPracticeDays() {
    return getMonthlyLogs()
        .map(
          (log) =>
              '${log.date.year}-${log.date.month}-${log.date.day}',
        )
        .toSet()
        .length;
  }

  int getMonthlyAverage() {
    final days =
        getMonthlyPracticeDays();

    if (days == 0) return 0;

    return (getMonthlyTotalMinutes() /
            days)
        .round();
  }

  int getPracticeMinutes(
      DateTime day) {
    return box.values
        .where(
          (log) => isSameDay(
            log.date,
            day,
          ),
        )
        .fold(
          0,
          (sum, log) =>
              sum +
              log.practiceMinutes,
        );
  }

  Color getDayColor(
      DateTime day) {
    final minutes =
        getPracticeMinutes(day);

    if (minutes == 0) {
      return const Color(
          0xFF1F2937);
    } else if (minutes < 15) {
      return const Color(
          0xFF0EA5E9);
    } else if (minutes < 30) {
      return const Color(
          0xFF06B6D4);
    } else if (minutes < 45) {
      return const Color(
          0xFF3B82F6);
    } else if (minutes < 60) {
      return const Color(
          0xFF6366F1);
    } else if (minutes < 75) {
      return const Color(
          0xFF8B5CF6);
    } else if (minutes < 90) {
      return const Color(
          0xFFA855F7);
    } else if (minutes < 105) {
      return const Color(
          0xFFD946EF);
    } else if (minutes < 120) {
      return const Color(
          0xFFEC4899);
    } else {
      return const Color(
          0xFFEF4444);
    }
  }

  Widget statCard(
      String title,
      String value,
      IconData icon) {
    return Expanded(
      child: Container(
        margin:
            const EdgeInsets.all(
                6),
        decoration:
            BoxDecoration(
          gradient:
              const LinearGradient(
            colors: [
              Color(
                  0xFF111827),
              Color(
                  0xFF1E1B4B),
            ],
          ),
          borderRadius:
              BorderRadius
                  .circular(18),
          border: Border.all(
              color:
                  Colors.cyan),
        ),
        child: Padding(
          padding:
              const EdgeInsets
                  .all(14),
          child: Column(
            children: [
              Icon(icon,
                  color:
                      Colors.cyan),
              const SizedBox(
                  height: 6),
              Text(
                title,
                style:
                    const TextStyle(
                  color: Colors
                      .white70,
                ),
              ),
              Text(
                value,
                style:
                    const TextStyle(
                  color: Colors
                      .white,
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

  Widget _buildColorLegend() {
    final colorSteps = [
      ('～15分', 0xFF0EA5E9),
      ('15～30分', 0xFF06B6D4),
      ('30～45分', 0xFF3B82F6),
      ('45～60分', 0xFF6366F1),
      ('60～75分', 0xFF8B5CF6),
      ('75～90分', 0xFFA855F7),
      ('90～105分', 0xFFD946EF),
      ('105～120分',
          0xFFEC4899),
      ('120分～', 0xFFEF4444),
    ];

    return Container(
      padding:
          const EdgeInsets.all(
              12),
      decoration:
          BoxDecoration(
        color: const Color(
            0xFF111827),
        borderRadius:
            BorderRadius
                .circular(12),
        border: Border.all(
          color: Colors.cyan,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment
                .start,
        children: [
          const Text(
            '練習時間の色分け',
            style: TextStyle(
              color: Colors.cyan,
              fontSize: 12,
              fontWeight:
                  FontWeight.bold,
            ),
          ),
          const SizedBox(
              height: 8),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: colorSteps
                .map(
                  (step) => Row(
                    mainAxisSize:
                        MainAxisSize
                            .min,
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        decoration:
                            BoxDecoration(
                          color: Color(
                              step.$2),
                          borderRadius:
                              BorderRadius
                                  .circular(
                                      3),
                        ),
                      ),
                      const SizedBox(
                          width: 6),
                      Text(
                        step.$1,
                        style:
                            const TextStyle(
                          color: Colors
                              .white70,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(
      BuildContext context) {
    final selectedLogs =
        box.values
            .where(
              (log) =>
                  isSameDay(
                log.date,
                selectedDay,
              ),
            )
            .toList();

    return Scaffold(
      backgroundColor:
          const Color(
              0xFF09090F),
      appBar: AppBar(
        title: const Text(
          'CALENDAR',
          style: TextStyle(
            color:
                Colors.cyan,
            letterSpacing: 2,
          ),
        ),
      ),
      body: SafeArea(
        child:
            SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints:
                  const BoxConstraints(
                maxWidth: 900,
              ),
              child: Padding(
                padding:
                    const EdgeInsets
                        .all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        statCard(
                          'TOTAL',
                          '${getMonthlyTotalMinutes()}分',
                          Icons
                              .local_fire_department,
                        ),
                        statCard(
                          'DAYS',
                          '${getMonthlyPracticeDays()}',
                          Icons
                              .calendar_today,
                        ),
                        statCard(
                          'AVG',
                          '${getMonthlyAverage()}分',
                          Icons
                              .timeline,
                        ),
                      ],
                    ),
                    const SizedBox(
                        height: 20),
                    Container(
                      decoration:
                          BoxDecoration(
                        color: const Color(
                            0xFF111827),
                        borderRadius:
                            BorderRadius.circular(
                                20),
                        border:
                            Border.all(
                          color: Colors
                              .cyan,
                        ),
                      ),
                      child:
                          TableCalendar(
                        firstDay:
                            DateTime(
                                2020),
                        lastDay:
                            DateTime(
                                2100),
                        focusedDay:
                            focusedDay,
                        rowHeight:
                            52,
                        selectedDayPredicate:
                            (day) =>
                                isSameDay(
                          selectedDay,
                          day,
                        ),
                        onDaySelected:
                            (
                          selected,
                          focused,
                        ) {
                          setState(() {
                            selectedDay =
                                selected;
                            focusedDay =
                                focused;
                          });
                        },
                        headerStyle:
                            const HeaderStyle(
                          formatButtonVisible:
                              false,
                          titleTextStyle:
                              TextStyle(
                            color: Colors
                                .cyan,
                            fontSize:
                                18,
                          ),
                        ),
                        calendarBuilders:
                            CalendarBuilders(
                          defaultBuilder:
                              (
                            context,
                            day,
                            _,
                          ) {
                            return Container(
                              margin:
                                  const EdgeInsets.all(
                                      4),
                              decoration:
                                  BoxDecoration(
                                color:
                                    getDayColor(
                                        day),
                                borderRadius:
                                    BorderRadius.circular(
                                        10),
                              ),
                              child:
                                  Center(
                                child:
                                    Text(
                                  '${day.day}',
                                  style:
                                      const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                        height: 20),
                    _buildColorLegend(),
                    const SizedBox(
                        height: 20),
                    SizedBox(
                      height: 400,
                      child:
                          selectedLogs
                                  .isEmpty
                              ? const Center(
                                  child:
                                      Text(
                                    'NO SESSION',
                                    style: TextStyle(
                                        color: Colors.white54),
                                  ),
                                )
                              : ListView.builder(
                                  itemCount:
                                      selectedLogs.length,
                                  itemBuilder:
                                      (
                                    context,
                                    index,
                                  ) {
                                    final log =
                                        selectedLogs[
                                            index];

                                    return ListTile(
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
                                      onTap:
                                          () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (_) =>
                                                    LogDetailPage(
                                              log:
                                                  log,
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}