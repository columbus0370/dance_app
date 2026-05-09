import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import 'log.dart';
import 'log_input_page.dart';
import 'provider/log_provider.dart';

class LogDetailPage
    extends ConsumerWidget {
  final Log log;

  const LogDetailPage({
    super.key,
    required this.log,
  });

  Future<void> openUrl(
      String url) async {
    final uri =
        Uri.parse(url);

    if (await canLaunchUrl(
        uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    return Scaffold(
      backgroundColor:
          const Color(
              0xFF09090F),
      appBar: AppBar(
        backgroundColor:
            Colors.black,
        title: const Text(
          'SESSION DETAIL',
          style: TextStyle(
            color:
                Colors.cyan,
            fontWeight:
                FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        actions: [
          IconButton(
            color:
                Colors.cyan,
            icon: const Icon(
                Icons.edit),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      LogInputPage(
                    key: ValueKey(
                        log.key),
                    editLog: log,
                  ),
                ),
              );
            },
          ),
          IconButton(
            color:
                Colors.pinkAccent,
            icon: const Icon(
                Icons.delete),
            onPressed:
                () async {
              await ref
                  .read(
                    logListProvider
                        .notifier,
                  )
                  .delete(
                    log.key
                        as int,
                  );

              Navigator.pop(
                  context);
            },
          ),
        ],
      ),
      body: Padding(
        padding:
            const EdgeInsets
                .all(20),
        child: Card(
          color: const Color(
              0xFF111827),
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius
                    .circular(24),
          ),
          child: Padding(
            padding:
                const EdgeInsets
                    .all(20),
            child: ListView(
              children: [
                Text(
                  '${log.date.year}/${log.date.month}/${log.date.day}',
                  style:
                      const TextStyle(
                    color: Colors
                        .cyan,
                    fontSize: 24,
                    fontWeight:
                        FontWeight
                            .bold,
                  ),
                ),

                const SizedBox(
                    height: 20),

                Text(
                  '練習時間: ${log.practiceMinutes}分',
                  style:
                      const TextStyle(
                    color: Colors
                        .white,
                    fontSize: 20,
                  ),
                ),

                const SizedBox(
                    height: 20),

                const Text(
                  'MEMO',
                  style:
                      TextStyle(
                    color: Colors
                        .pinkAccent,
                    fontWeight:
                        FontWeight
                            .bold,
                  ),
                ),
                Text(
                  log.memo
                          .isEmpty
                      ? 'なし'
                      : log.memo,
                  style:
                      const TextStyle(
                    color: Colors
                        .white70,
                  ),
                ),

                const SizedBox(
                    height: 20),

                const Text(
                  'TAGS',
                  style:
                      TextStyle(
                    color: Colors
                        .pinkAccent,
                    fontWeight:
                        FontWeight
                            .bold,
                  ),
                ),

                Wrap(
                  spacing: 8,
                  children: log
                      .tags
                      .map(
                        (tag) =>
                            Chip(
                          backgroundColor:
                              Colors.cyan,
                          label:
                              Text(
                            tag,
                          ),
                        ),
                      )
                      .toList(),
                ),

                const SizedBox(
                    height: 30),

                ElevatedButton.icon(
                  style:
                      ElevatedButton
                          .styleFrom(
                    backgroundColor:
                        Colors
                            .pinkAccent,
                  ),
                  onPressed: log
                          .videoUrl
                          .isEmpty
                      ? null
                      : () {
                          openUrl(
                              log.videoUrl);
                        },
                  icon: const Icon(
                      Icons
                          .play_arrow),
                  label:
                      const Text(
                    '動画を開く',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}