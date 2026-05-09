import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() =>
      _SplashPageState();
}

class _SplashPageState
    extends State<SplashPage>
    with
        SingleTickerProviderStateMixin {
  late AnimationController
      _controller;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(
      vsync: this,
      duration:
          const Duration(
              seconds: 2),
    )..forward();

    Future.delayed(
      const Duration(
          seconds: 3),
      () {
        if (!mounted) return;

        Navigator.pushReplacementNamed(
          context,
          '/home',
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(
      BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(
              0xFF09090F),
      body: Center(
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment
                  .center,
          children: [
            ScaleTransition(
              scale: Tween<double>(
                begin: 0.5,
                end: 1.0,
              ).animate(_controller),
              child: Image.asset(
                'assets/icon.png',
                width: 120,
                height: 120,
              ),
            ),
            const SizedBox(
                height: 40),
            const Text(
              'GrooveTracker',
              style: TextStyle(
                color:
                    Colors.white,
                fontSize: 32,
                fontWeight:
                    FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(
                height: 8),
            const Text(
              'STREET MODE',
              style: TextStyle(
                color: Colors.cyan,
                letterSpacing: 6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}