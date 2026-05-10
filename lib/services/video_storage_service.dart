import 'dart:async';
import 'dart:html' as html;
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';

class VideoStorageService {
  static const String _dbName = 'dance_app_videos';
  static const String _storeName = 'videos';
  static const int _dbVersion = 1;
  static const Duration _maxVideoDuration = Duration(seconds: 90);

  static late html.IDBDatabase _database;
  static bool _initialized = false;

  /// IndexedDB を初期化
  static Future<void> initialize() async {
    if (_initialized) return;

    final request = html.window.indexedDB!.open(_dbName, _dbVersion);

    request.onUpgradeNeeded.listen((event) {
      final db = (event.target as html.IDBOpenDBRequest).result as html.IDBDatabase;
      if (!db.objectStoreNames!.contains(_storeName)) {
        db.createObjectStore(_storeName);
      }
    });

    _database = await request.future;
    _initialized = true;
  }

  /// 動画ファイルを選択して保存
  /// returns: (blob_url, duration_in_seconds) または null
  static Future<(String blobUrl, double duration)?> selectAndStoreVideo() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.video,
        allowMultiple: false,
      );

      if (result == null || result.files.isEmpty) {
        return null;
      }

      final file = result.files.first;
      final bytes = file.bytes;

      if (bytes == null) {
        throw Exception('動画ファイルの読み込みに失敗しました');
      }

      // 動画の長さを確認
      final duration = await _getVideoDuration(bytes);

      if (duration > _maxVideoDuration.inSeconds) {
        throw Exception(
          '動画は${_maxVideoDuration.inSeconds}秒以内にしてください\n'
          '(選択した動画: ${duration.toStringAsFixed(1)}秒)'
        );
      }

      // IndexedDB に保存
      final blob = html.Blob([bytes]);
      final blobUrl = html.Url.createObjectUrlFromBlob(blob);
      final timestamp = DateTime.now().millisecondsSinceEpoch;

      await _storeVideoBlob(timestamp.toString(), blob);

      return (blobUrl, duration);
    } catch (e) {
      rethrow;
    }
  }

  /// 動画の長さを取得（秒）
  static Future<double> _getVideoDuration(Uint8List bytes) async {
    final completer = Completer<double>();

    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);

    final video = html.VideoElement();
    video.onLoadedMetadata.listen((_) {
      completer.complete(video.duration ?? 0.0);
      html.Url.revokeObjectUrl(url);
    });

    video.onError.listen((_) {
      completer.completeError(Exception('動画ファイルが無効です'));
      html.Url.revokeObjectUrl(url);
    });

    video.src = url;

    // タイムアウト設定
    Future.delayed(const Duration(seconds: 10)).then((_) {
      if (!completer.isCompleted) {
        completer.completeError(
          Exception('動画情報の取得がタイムアウトしました')
        );
        html.Url.revokeObjectUrl(url);
      }
    });

    return completer.future;
  }

  /// Blob を IndexedDB に保存
  static Future<void> _storeVideoBlob(
    String key,
    html.Blob blob,
  ) async {
    final transaction = _database.transaction(_storeName, 'readwrite');
    final store = transaction.objectStore(_storeName);
    await store.put(blob, key).future;
  }

  /// Blob URL を削除
  static void revokeBlobUrl(String blobUrl) {
    html.Url.revokeObjectUrl(blobUrl);
  }

  /// 最大動画時間を取得
  static Duration get maxVideoDuration => _maxVideoDuration;
}
