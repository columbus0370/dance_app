import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

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
  // モバイルブラウザは await 後の window.open をブロックするため、
  // ページ表示時に Blob URL を事前取得しておき、タップ時に同期で開く。
  bool _isPreloading = false;
  String? _blobUrl;

  @override
  void initState() {
    super.initState();
    _preloadBlobUrl();
  }

  @override
  void dispose() {
    if (_blobUrl != null) {
      VideoStorageService.revokeBlobUrl(_blobUrl!);
    }
    super.dispose();
  }

  Future<void> _preloadBlobUrl() async {
    final url = widget.log.videoUrl;
    if (url.isEmpty || !VideoStorageService.isStoredKey(url)) return;

    setState(() => _isPreloading = true);
    try {
      await VideoStorageService.initialize();
      final blob = await VideoStorageService.createBlobUrlFromKey(url);
      if (mounted) setState(() => _blobUrl = blob);
    } catch (_) {
      // 事前取得失敗時はボタン押下時にエラー表示
    } finally {
      if (mounted) setState(() => _isPreloading = false);
    }
  }

  // 同期メソッド：ユーザーアクション内で呼ばれるため window.open がモバイルでもブロックされない
  void _openVideo() {
    final url = widget.log.videoUrl;
    if (url.isEmpty) return;

    if (VideoStorageService.isStoredKey(url)) {
      if (_blobUrl == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('動画が見つかりませんでした')),
        );
        return;
      }
      VideoStorageService.openVideoInNewTab(_blobUrl!);
    } else {
      final uri = Uri.parse(url);
      launchUrl(uri);
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
                      : _isPreloading
                          ? null
                          : _openVideo,
                  icon: _isPreloading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.play_arrow),
                  label: Text(_isPreloading ? '読み込み中...' : '動画を開く'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
