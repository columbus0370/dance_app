import 'dart:js_interop';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web/web.dart' as web;

import 'log.dart';
import 'log_input_page.dart';
import 'provider/log_provider.dart';
import 'provider/plant_avatar_provider.dart';
import 'services/video_storage_service.dart';

class LogDetailPage extends ConsumerStatefulWidget {
  final Log log;

  const LogDetailPage({
    super.key,
    required this.log,
  });

  @override
  ConsumerState<LogDetailPage> createState() => _LogDetailPageState();
}

class _LogDetailPageState extends ConsumerState<LogDetailPage> {
  bool _isOpeningVideo = false;

  Future<void> _openVideo(String videoValue) async {
    if (_isOpeningVideo) return;
    setState(() => _isOpeningVideo = true);

    try {
      if (VideoStorageService.isStoredKey(videoValue)) {
        // IndexedDB のキーから Blob URL を生成して開く
        await VideoStorageService.initialize();
        final blobUrl = await VideoStorageService.createBlobUrlFromKey(videoValue);

        if (blobUrl == null) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('動画が見つかりませんでした')),
          );
          return;
        }

        // 新しいタブで開く
        web.window.open(blobUrl, '_blank', ''.toJS);

        // 使用後に URL を解放（少し遅延させてブラウザが読み込めるようにする）
        Future.delayed(const Duration(seconds: 5), () {
          VideoStorageService.revokeBlobUrl(blobUrl);
        });
      } else {
        // 通常の URL（外部リンク）として開く
        final uri = Uri.parse(videoValue);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri);
        }
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('動画を開けませんでした: $e')),
      );
    } finally {
      if (mounted) setState(() => _isOpeningVideo = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF09090F),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'SESSION DETAIL',
          style: TextStyle(
            color: Colors.cyan,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        actions: [
          IconButton(
            color: Colors.cyan,
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => LogInputPage(
                    key: ValueKey(widget.log.key),
                    editLog: widget.log,
                  ),
                ),
              );
            },
          ),
          IconButton(
            color: Colors.pinkAccent,
            icon: const Icon(Icons.delete),
            onPressed: () async {
              final plant = ref.read(plantAvatarProvider);
              final deductExp = plant.calculateExp(
                practiceMinutes: widget.log.practiceMinutes,
                streakDays: 0,
                videoUploads: 0,
              );
              final newExp =
                  (plant.currentExp - deductExp).clamp(0, double.infinity).toInt();

              await ref.read(logListProvider.notifier).delete(widget.log.key as int);
              await ref.read(plantAvatarProvider.notifier).setExpDirect(newExp);

              if (!context.mounted) return;
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Card(
          color: const Color(0xFF111827),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: ListView(
              children: [
                Text(
                  '${widget.log.date.year}/${widget.log.date.month}/${widget.log.date.day}',
                  style: const TextStyle(
                    color: Colors.cyan,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  '練習時間: ${widget.log.practiceMinutes}分',
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
                const SizedBox(height: 20),
                const Text(
                  'MEMO',
                  style: TextStyle(
                    color: Colors.pinkAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.log.memo.isEmpty ? 'なし' : widget.log.memo,
                  style: const TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 20),
                const Text(
                  'TAGS',
                  style: TextStyle(
                    color: Colors.pinkAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Wrap(
                  spacing: 8,
                  children: widget.log.tags
                      .map((tag) => Chip(
                            backgroundColor: Colors.cyan,
                            label: Text(tag),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 30),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pinkAccent,
                  ),
                  onPressed: widget.log.videoUrl.isEmpty
                      ? null
                      : _isOpeningVideo
                          ? null
                          : () => _openVideo(widget.log.videoUrl),
                  icon: _isOpeningVideo
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.play_arrow),
                  label: Text(_isOpeningVideo ? '読み込み中...' : '動画を開く'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
