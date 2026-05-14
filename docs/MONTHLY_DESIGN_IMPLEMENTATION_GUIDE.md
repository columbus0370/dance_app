# 月別植物デザイン実装ガイド

このドキュメントは、各月の植物デザイン（CustomPainter）を実装する開発者向けのガイドです。

## 概要

アプリの植物成長ゲームは、毎月異なる花のデザインで実装します。デザイン情報は花屋さんからの提供情報に基づいています。

## ファイル構成

```
lib/
├── models/
│   └── monthly_flower.dart          # 月別花情報のモデル
├── widgets/
│   ├── monthly_plant_monster_widget.dart  # 月別ウィジェット
│   └── plant_designs/
│       ├── monthly_plant_painter.dart     # 基底クラス
│       ├── plant_painter_template.dart    # テンプレート
│       ├── plant_painter_jan.dart         # 1月実装
│       ├── plant_painter_feb.dart         # 2月実装
│       └── ... (12月まで)
```

## 実装手順

### 1. 月別情報の更新

`lib/models/monthly_flower.dart` の `MonthlyFlowerRepository.flowers` リストを更新します。

```dart
MonthlyFlower(
  month: 1,
  flowerName: '福寿草',
  description: '春を告げる黄色い小花',
  primaryColors: [Color(0xFF0A6B7F)],      // 主要色
  accentColors: [Color(0xFF14A085)],       // 副色
  symbolism: '新年の始まり、希望',
  season: '冬',
),
```

### 2. Painterの実装

テンプレート（`plant_painter_template.dart`）を参考に、月別Painterを実装します。

**ファイル作成例**: `lib/widgets/plant_designs/plant_painter_jan.dart`

```dart
import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../models/monthly_flower.dart';
import 'monthly_plant_painter.dart';

class PlantPainterJan extends MonthlyPlantPainter {
  PlantPainterJan({
    required int level,
    required MonthlyFlower flower,
  }) : super(level: level, flower: flower);

  @override
  void drawFlowerBase(Canvas canvas, Size size) {
    // 茎や根の描画
  }

  @override
  void drawFlowerPetals(Canvas canvas, Size size) {
    // 花びらの描画
  }

  @override
  void drawFlowerCenter(Canvas canvas, Size size) {
    // 花の中心の描画
  }

  @override
  void drawGrowthStage(Canvas canvas, Size size) {
    // レベル固有の表現（オプション）
  }
}
```

### 3. ファクトリへの登録

`lib/widgets/plant_designs/monthly_plant_painter.dart` の `MonthlyPlantPainterFactory.createPainter()` を更新します。

```dart
static MonthlyPlantPainter createPainter({
  required int month,
  required int level,
}) {
  final flower = MonthlyFlowerRepository.getFlowerByMonth(month);

  switch (month) {
    case 1:
      return PlantPainterJan(level: level, flower: flower);
    case 2:
      return PlantPainterFeb(level: level, flower: flower);
    // ... 他の月
    default:
      return DefaultMonthlyPlantPainter(level: level, flower: flower);
  }
}
```

## 描画ガイドライン

### 色の使用

```dart
// 花屋さんから提供される色
final primaryColor = flower.primaryColors[0];    // 主要色
final accentColor = flower.accentColors[0];      // 副色

// 描画例
final paint = Paint()
  ..color = primaryColor
  ..style = PaintingStyle.fill;
```

### レベル別成長表現

各レベルで花の成長を表現します（推奨）：

- **Level 0-1**: 蕾や若い花
- **Level 2-3**: 花が開き始める
- **Level 4-5**: 満開、複数の花が咲く

```dart
@override
void drawGrowthStage(Canvas canvas, Size size) {
  if (level >= 3) {
    // 複数花の描画
  }
  if (level >= 5) {
    // グロウエフェクト（光の表現など）
  }
}
```

### サイズの計算

```dart
// キャンバスサイズに対する相対値で計算（スケーラブル）
final baseRadius = size.width * 0.1;        // 幅の10%
final petalSize = size.width * 0.06;        // 幅の6%
```

## テスト方法

### ローカルテスト

```dart
// Test widget
CustomPaint(
  painter: PlantPainterJan(
    level: 3,
    flower: MonthlyFlowerRepository.getFlowerByMonth(1),
  ),
  size: Size(120, 120),
)
```

### ステージング環境確認

1. 実装を `develop` ブランチにコミット
2. `https://columbus0370.github.io/dance_app/staging/` で確認

### 確認項目

- [ ] 花の色が正確に反映されているか
- [ ] レベル 0-5 での成長表現が適切か
- [ ] 他の月との視覚的バランスが取れているか
- [ ] モバイル画面でも見やすいか

## パフォーマンス考慮事項

- `shouldRepaint()` を正しく実装（不要な再描画を避ける）
- 複雑な計算は `paint()` の外に出す
- `canvas.save()`/`canvas.restore()` で変換を管理

## 参考資料

- [Flutter CustomPaint ドキュメント](https://api.flutter.dev/flutter/widgets/CustomPaint-class.html)
- `plant_painter_template.dart`: 実装例
- `MONTHLY_FLOWER_SPECIFICATION.md`: 花屋さんからの情報仕様

## よくある質問

**Q: 複雑すぎるデザインだとパフォーマンスに影響する？**
A: 現在の実装より「少し複雑」な程度なので問題ないはず。過度に複雑な場合は SVG をCanvasKit で描画することも検討できます。

**Q: 過去の月のデザインに戻すことはできる？**
A: `MonthlyPlantMonsterWidget` の `month` パラメータで任意の月を指定可能です。

**Q: レベル計算に影響しない？**
A: 描画だけで、レベル計算は `PlantAvatar` モデルで行われているため影響なし。

---

**最終更新**: 2026-05-14
