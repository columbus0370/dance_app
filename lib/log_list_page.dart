import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'log.dart';
import 'log_detail_page.dart';
import 'provider/log_provider.dart';

class LogListPage
    extends ConsumerWidget {
  const LogListPage({
    super.key,
  });

  Color getCardColor(
      int minutes) {
    if (minutes < 30) {
      return const Color(
          0xFF06B6D4);
    } else if (minutes < 60) {
      return const Color(
          0xFF3B82F6);
    } else if (minutes < 90) {
      return const Color(
          0xFF8B5CF6);
    } else if (minutes < 120) {
      return const Color(
          0xFFEC4899);
    } else {
      return const Color(
          0xFFEF4444);
    }
  }

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final logs = ref.watch(
      filteredLogsProvider,
    );

    return Scaffold(
      backgroundColor:
          const Color(
              0xFF09090F),
      appBar: AppBar(
        backgroundColor:
            Colors.black,
        title: const Text(
          'SESSION LIST',
          style: TextStyle(
            color:
                Colors.cyan,
            fontWeight:
                FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets
                    .all(12),
            child: TextField(
              style:
                  const TextStyle(
                color:
                    Colors.white,
              ),
              decoration:
                  InputDecoration(
                labelText:
                    'タグ検索',
                labelStyle:
                    const TextStyle(
                  color: Colors
                      .cyan,
                ),
                prefixIcon:
                    const Icon(
                  Icons.search,
                  color: Colors
                      .cyan,
                ),
                filled: true,
                fillColor:
                    const Color(
                        0xFF111827),
                border:
                    OutlineInputBorder(
                  borderRadius:
                      BorderRadius
                          .circular(
                              18),
                ),
              ),
              onChanged:
                  (value) {
                ref
                    .read(
                      tagFilterProvider
                          .notifier,
                    )
                    .state = value;
              },
            ),
          ),

          Expanded(
            child: logs.isEmpty
                ? const Center(
                    child: Text(
                      'NO SESSION',
                      style:
                          TextStyle(
                        color: Colors
                            .white54,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount:
                        logs.length,
                    itemBuilder:
                        (
                      context,
                      index,
                    ) {
                      final log =
                          logs[index];

                      return Container(
                        margin:
                            const EdgeInsets.symmetric(
                          horizontal:
                              12,
                          vertical:
                              6,
                        ),
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
                              BorderRadius.circular(
                                  18),
                          border:
                              Border.all(
                            color: getCardColor(
                                log.practiceMinutes),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: getCardColor(
                                      log.practiceMinutes)
                                  .withOpacity(
                                      0.25),
                              blurRadius:
                                  14,
                            ),
                          ],
                        ),
                        child:
                            ListTile(
                          title:
                              Text(
                            "${log.date.year}/${log.date.month}/${log.date.day}",
                            style: const TextStyle(
                                color: Colors.white),
                          ),
                          subtitle:
                              Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${log.practiceMinutes}分',
                                style: const TextStyle(
                                    color: Colors.cyan),
                              ),
                              Text(
                                log.memo,
                                style: const TextStyle(
                                    color: Colors.white70),
                              ),
                              const SizedBox(
                                  height:
                                      6),
                              Wrap(
                                spacing:
                                    6,
                                children: log
                                    .tags
                                    .map(
                                      (
                                        tag,
                                      ) =>
                                          Chip(
                                        backgroundColor:
                                            Colors.pinkAccent,
                                        label:
                                            Text(
                                          tag,
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ],
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
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}