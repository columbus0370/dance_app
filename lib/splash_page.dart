import 'package:flutter/material.dart';
import 'dart:math';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with TickerProviderStateMixin {
  late AnimationController waveController;
  late AnimationController lightController;

  @override
  void initState() {
    super.initState();

    // 背景グラデーションの波アニメーション
    waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);

    // スポットライトのクロスアニメーション
    lightController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([waveController, lightController]),
      builder: (context, _) {
        // 波打つ動き（sin波）
        final wave = sin(waveController.value * pi * 2) * 0.4;

        // ライトの角度（-30° → +30°）
        final angle = (lightController.value * 60 - 30) * pi / 180;

        return Scaffold(
          body: Stack(
            children: [
              // ★ 波打つグラデーション背景
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment(-1 + wave, -1),
                    end: Alignment(1 - wave, 1),
                    colors: const [
                      Color(0xFF0A0A12),
                      Color(0xFF111827),
                      Color(0xFF1E1B4B),
                      Color(0xFF2A1B6B),
                    ],
                  ),
                ),
              ),

              // ★ 左ライト（角度つき）
              Positioned(
                bottom: -120,
                left: MediaQuery.of(context).size.width / 2 - 120,
                child: Transform.rotate(
                  angle: angle,
                  child: _coneLight(Colors.cyanAccent),
                ),
              ),

              // ★ 右ライト（角度つき・逆方向）
              Positioned(
                bottom: -120,
                left: MediaQuery.of(context).size.width / 2 + 120,
                child: Transform.rotate(
                  angle: -angle,
                  child: _coneLight(Colors.pinkAccent),
                ),
              ),

              // ★ アプリ名 GrooveTracks
              Center(
                child: Text(
                  "GrooveTracks",
                  style: TextStyle(
                    color: Colors.cyanAccent.shade100,
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 4,
                    shadows: [
                      Shadow(
                        color: Colors.cyanAccent.withOpacity(0.9),
                        blurRadius: 25,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ★ 円錐形ライト（上が細く、下が広い）
  Widget _coneLight(Color color) {
    return ClipPath(
      clipper: _ConeClipper(),
      child: Container(
        width: 260,
        height: 400,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              color.withOpacity(0.0),
              color.withOpacity(0.25),
              color.withOpacity(0.0),
            ],
          ),
        ),
      ),
    );
  }
}

// ★ 円錐形の形を作るクリッパー
class _ConeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(size.width / 2, 0); // 上の細い部分
    path.lineTo(0, size.height); // 左下
    path.lineTo(size.width, size.height); // 右下
    path.close();
    return path;
  }

  @override
  bool shouldReclip(_) => true;
}
