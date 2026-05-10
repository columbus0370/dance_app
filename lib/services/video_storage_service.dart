import 'dart:async';
import 'dart:js_interop';
import 'package:web/web.dart' as web;
import 'package:file_picker/file_picker.dart';

class VideoStorageService {
  static const int _maxSeconds = 90;
  static const String _dbName = 'dance_app_videos';
  static const String _storeName = 'videos';
  static const int _dbVersion = 1;

  static web.IDBDatabase? _database;
  static bool _initialized = false;

  static Future<void> initialize() async {
    if (_initialized) return;

    final completer = Completer<web.IDBDatabase>();
    final request = web.window.indexedDB.open(_dbName, _dbVersion);

    request.onupgradeneeded = (web.IDBVersionChangeEvent event) {
      final db =
          (event.target as web.IDBOpenDBRequest).result as web.IDBDatabase;
      bool exists = false;
      final names = db.objectStoreNames;
      for (int i = 0; i < names.length; i++) {
        if (names.item(i) == _storeName) {
          exists = true;
          break;
        }
      }
      if (!exists) db.createObjectStore(_storeName);
    }.toJS;

    request.onsuccess = (web.Event event) {
      completer.complete(
        (event.target as web.IDBOpenDBRequest).result as web.IDBDatabase,
      );
    }.toJS;

    request.onerror = (web.Event _) {
      completer.completeError(Exception('IndexedDB の初期化に失敗しました'));
    }.toJS;

    _database = await completer.future;
    _initialized = true;
  }

  /// 動画ファイルを選択・長さチェック・IndexedDB 保存
  static Future<(String blobUrl, double duration)?> selectAndStoreVideo() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.video,
      allowMultiple: false,
    );

    if (result == null || result.files.isEmpty) return null;

    final bytes = result.files.first.bytes;
    if (bytes == null) throw Exception('動画ファイルの読み込みに失敗しました');

    final blob = web.Blob([bytes.toJS].toJS);
    final url = web.URL.createObjectURL(blob);

    final duration = await _getVideoDuration(url);

    if (duration > _maxSeconds) {
      web.URL.revokeObjectURL(url);
      throw Exception(
        '動画は${_maxSeconds}秒以内にしてください\n'
        '（選択した動画: ${duration.toStringAsFixed(1)}秒）',
      );
    }

    final key = DateTime.now().millisecondsSinceEpoch.toString();
    await _storeBlob(key, blob);

    return (url, duration);
  }

  static Future<double> _getVideoDuration(String url) async {
    final completer = Completer<double>();
    final video = web.HTMLVideoElement();

    video.onloadedmetadata = (web.Event _) {
      completer.complete(video.duration);
    }.toJS;

    video.onerror = (web.Event _) {
      if (!completer.isCompleted) {
        completer.completeError(Exception('動画ファイルが無効です'));
      }
    }.toJS;

    video.src = url;

    Future.delayed(const Duration(seconds: 10)).then((_) {
      if (!completer.isCompleted) {
        completer.completeError(Exception('動画情報の取得がタイムアウトしました'));
      }
    });

    return completer.future;
  }

  static Future<void> _storeBlob(String key, web.Blob blob) async {
    if (_database == null) throw Exception('IndexedDB が初期化されていません');

    final completer = Completer<void>();
    final tx = _database!.transaction(_storeName.toJS, 'readwrite');
    final request = tx.objectStore(_storeName).put(blob, key.toJS);

    request.onsuccess = (web.Event _) {
      completer.complete();
    }.toJS;
    request.onerror = (web.Event _) {
      completer.completeError(Exception('動画の保存に失敗しました'));
    }.toJS;

    return completer.future;
  }

  static void revokeBlobUrl(String url) {
    web.URL.revokeObjectURL(url);
  }

  static int get maxSeconds => _maxSeconds;
}
