import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFF09090F),
      appBar: AppBar(
        backgroundColor:
            Colors.black,
        title: const Text(
          'HELP',
          style: TextStyle(
            color: Colors.cyan,
            fontWeight:
                FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
      ),
      body: Container(
        decoration:
            const BoxDecoration(
          gradient: LinearGradient(
            begin:
                Alignment.topLeft,
            end: Alignment
                .bottomRight,
            colors: [
              Color(0xFF09090F),
              Color(0xFF111827),
              Color(0xFF1E1B4B),
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding:
              const EdgeInsets
                  .all(16),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment
                    .start,
            children: [
              const Text(
                'GrooveTracker',
                style: TextStyle(
                  color:
                      Colors.cyan,
                  fontSize: 28,
                  fontWeight:
                      FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(
                  height: 8),
              const Text(
                'ダンス練習管理アプリ',
                style: TextStyle(
                  color:
                      Colors.white70,
                  fontSize: 16,
                ),
              ),
              const SizedBox(
                  height: 24),
              _buildSection(
                title: 'アプリについて',
                content:
                    'GrooveTrackerは、ダンス練習の記録と管理を簡単にするアプリです。日々の練習時間、メモ、タグを記録し、統計情報やカレンダーで進捗を可視化できます。',
              ),
              const SizedBox(
                  height: 20),
              _buildSection(
                title:
                    'ホーム画面（STREET MODE）',
                content:
                    '• TODAY：本日の練習時間\n• WEEK：今週の累計練習時間\n• STREAK：連続練習日数\n• RECENT SESSION：最近の練習内容',
              ),
              const SizedBox(
                  height: 20),
              _buildSection(
                title: 'セッションリスト',
                content:
                    'リストボタンから過去の練習記録を確認できます。タグで検索・フィルタリングも可能です。各セッションをタップすると詳細情報と動画を開けます。',
              ),
              const SizedBox(
                  height: 20),
              _buildSection(
                title: 'カレンダー',
                content:
                    'カレンダーボタンから月単位の統計と練習日を確認できます。練習量に応じて色分け表示され、進捗を視覚的に把握できます。',
              ),
              const SizedBox(
                  height: 20),
              _buildSection(
                title: 'ログ入力',
                content:
                    '保存ボタンから新しいセッションを記録します。\n• 練習時間：クイックボタン（15/30/45/60/90分）で簡単入力\n• メモ：内容や気づきを記録\n• タグ：動きやテーマで分類\n• 動画URL：参考動画やセルフ動画を保存',
              ),
              const SizedBox(
                  height: 20),
              _buildSection(
                title: '使い方のコツ',
                content:
                    '• タグを統一することで、後から検索しやすくなります\n• 動画URLを記録すれば、後で確認できます\n• ストリークを意識して毎日練習を継続しましょう！',
              ),
              const SizedBox(
                  height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String content,
  }) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment
              .start,
      children: [
        Text(
          title,
          style:
              const TextStyle(
            color:
                Colors.pinkAccent,
            fontSize: 18,
            fontWeight:
                FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(
            height: 10),
        Container(
          padding:
              const EdgeInsets
                  .all(14),
          decoration:
              BoxDecoration(
            color: const Color(
                0xFF111827),
            borderRadius:
                BorderRadius
                    .circular(14),
            border: Border.all(
              color: Colors.cyan,
              width: 1,
            ),
          ),
          child: Text(
            content,
            style:
                const TextStyle(
              color:
                  Colors.white70,
              height: 1.6,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}
